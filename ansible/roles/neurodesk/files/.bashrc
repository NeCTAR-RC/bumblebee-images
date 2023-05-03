#things in .bashrc get executed for every subshell
if [ -f '/usr/share/module.sh' ]; then source /usr/share/module.sh; fi

alias ll='ls -la'


if [ -f '/usr/share/module.sh' ]; then
        if [ -d /cvmfs/neurodesk.ardc.edu.au/neurodesk-modules ]; then
                module use /cvmfs/neurodesk.ardc.edu.au/neurodesk-modules/*
        else
                export MODULEPATH="/neurodesktop-storage/containers/modules"
                module use $MODULEPATH
                export CVMFS_DISABLE=true
        fi

        echo 'Run "ml av" to see which tools are available - use "ml <tool>" to use them in this shell.'
        if [ -v "$CVMFS_DISABLE" ]; then
                if [ ! -d $MODULEPATH ]; then
                        echo 'Neurodesk tools not yet downloaded. Choose tools to install from the Application menu.'
                fi
        fi
fi


# This sets the freesurfer subject output directory: Please change if you would like your freesurfer outputs to be stored somewhere else.
export SINGULARITYENV_SUBJECTS_DIR=~/freesurfer-subjects-dir

export PATH="/usr/local/singularity/bin:${PATH}"
export PATH=$PATH:~/.local/bin
export neurodesk_singularity_opts="${neurodesk_singularity_opts} --bind /neurodesktop-storage "
