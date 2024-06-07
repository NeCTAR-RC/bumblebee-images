#!/bin/bash

# This script requires:
#  - Packer
#  - jq (JSON CLI tool)
#  - QEMU tools
#  - OpenStack credentials loaded in your environment

FILE="$1"
if [ -z "$1" ]; then
    echo "Usage: $0 JSONFILE [VOL_SIZE]"
    exit 1
fi

# Optional volume size argument 
if [ -z "$2" ]; then
    VOL_SIZE=50
else
    VOL_SIZE=$2
fi

# Find packer
if ! hash packer >/dev/null 2>&1; then
    echo "You need packer installed to use this script"
    exit 1
fi

# Find jq
if ! hash jq >/dev/null 2>&1; then
    echo "You need jq installed to use this script"
    exit 1
fi

if [ -z "${OS_USERNAME}" ]; then
    echo "Please load the OpenStack credentials"
    exit 1
fi

# Die on unbound variable and errors
set -eu

# Packer is dumb! See notes on OpenStack Authorization at:
#   https://www.packer.io/docs/builders/openstack.html
export OS_TENANT_NAME=$OS_PROJECT_NAME
export OS_DOMAIN_NAME=$OS_PROJECT_DOMAIN_NAME

# Set the AZ
AZ=melbourne-qh2
if echo $OS_AUTH_URL | grep -q test; then
    AZ=coreservices
fi

NAME=$(basename -s .json $FILE)
IMAGE_NAME=$(jq -r '.builders[0].image_name' $FILE)
BUILD_NUMBER=$(date "+%Y%m%d%H%M")
BUILD_NAME="packer_build_${BUILD_NUMBER}"
FACT_DIR=ansible/.facts
TAG_DIR=ansible/.tags
rm -fr $FACT_DIR $TAG_DIR

# Update the name to include build number
jq ".builders[0].image_name = \"$BUILD_NAME\" | .builders[0].availability_zone = \"$AZ\"" $FILE > /tmp/${BUILD_NAME}_packer.json

echo "Building image ${IMAGE_NAME}..."
packer build /tmp/${BUILD_NAME}_packer.json
rm /tmp/${BUILD_NAME}_packer.json

openstack image save --file ${BUILD_NAME}-large.qcow2 $BUILD_NAME
openstack image delete $BUILD_NAME

echo "Shrinking image..."
echo "==> qemu-img convert -c -o compat=0.10 -O qcow2 $BUILD_NAME $BUILD_NAME.qcow2"
qemu-img convert -c -o compat=0.10 -O qcow2 ${BUILD_NAME}-large.qcow2 ${BUILD_NAME}.qcow2
rm ${BUILD_NAME}-large.qcow2

echo "Creating final image..."
IMAGE_ID=$(openstack image create -f value -c id --disk-format qcow2 --container-format bare --file $BUILD_NAME.qcow2 "$IMAGE_NAME")
echo "Image $IMAGE_ID created!"
rm ${BUILD_NAME}.qcow2

echo "Applying properties..."
for FACT in $(ls $FACT_DIR); do
    [[ $FACT =~ ^nectar_ ]] && continue
    VAL=$(cat $FACT_DIR/$FACT)
    echo "  -> $FACT: '$VAL'..."
    openstack image set --property $FACT=$"$VAL" $IMAGE_ID
done

echo "Applying tags..."
for TAG in $(ls $TAG_DIR); do
    echo "  -> tag: '$TAG'..."
    openstack image set --tag $TAG $IMAGE_ID
done

echo "Image build successful"
openstack image show --max-width=120 $IMAGE_ID

echo "Creating bootable volume..."
openstack volume create --bootable --size $VOL_SIZE --availability-zone $AZ --image $IMAGE_ID "$IMAGE_NAME"
