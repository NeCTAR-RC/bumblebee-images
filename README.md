# Nectar Virtual Desktop images

This project includes scripts to build a Virtual Desktop images suitable for
use with the ARDC Nectar Bumblebee service.

We have:
 * Packer JSON config for building the image on the Nectar Research Cloud.
 * Ansible roles for provisioning software, including the desktop GUI
 * Vagrant config for building and testing the image build process locally.

The images are built on top of the existing image building tools from the
[Nectar Images](https://github.com/NeCTAR-RC/nectar-images) project.

We overload the `image_source` field in the Packer config to specifiy an
image name, which will be resolved to the actual image ID. This
functionality is not supported in Packer, so we do it as part of our build
scripts.

This repository will be mostly used for automated image building jobs on the
Nectar CI server, but we do support building images by hand, which can be
especially useful for testing.


## Requirements

You'll require the following tools installed and in your path
 * Packer
 * Ansible
 * Vagrant (for testing)
 * OpenStack CLI
 * jq (JSON CLI tool)
 * QEMU tools (for image shrinking process)

(This is pretty much the same set of requirements as for the nectar-images
repo, so check there ... and the ImageBuilding Wiki page ... for updates,
clarifications, etc.)

## Building the image

 1. Make sure all the required software (listed above) is installed
 1. Load your Nectar RC credentials into your environment
 1. cd to the directory containing this README.md file
 1. Check that the git repo is up to date
 1. Check that ./packer-ssh-key has permissions 600.
 1. Run the build script
```
./build_local.sh <image>.json
```

The script uses packer to build the requested image in a Nectar VM.  Then it
downloads the snapshot from Glance, shrinks it, re-uploads it, sets its
properties and finally creates the bootable master volume for Bumblebee.


## Testing the image with Vagrant

We include a Vagrantfile which can be used for testing the provisioning process
with Ansible and test the resulting image.

Run `vagrant status` in the top level directory for a list of available
virtual machine profiles you can test.

To launch a test Vagrant instance, use the following command:

```
$ vagrant up --no-destroy-on-error
```

The Vagrant config prefers the `libvirt` backend, which is ideal for Linux
machines but you'll need to set it up yourself and support non-root access.
The `virtualbox` provider is also enabled if you'd prefer to use that.

You can set the provider manually on the command line using the `provder`
argument. For example:

```
$ vagrant up --provider virtualbox
```
