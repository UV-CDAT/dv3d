#!/usr/bin/env bash
PKG_NAME=vcs
USER=cdat
VERSION="2.12"
ESMF_CHANNEL="nesii/label/dev-esmf"
echo "Trying to upload conda"
if [ `uname` == "Linux" ]; then
    OS=linux-64
    echo "Linux OS"
    conda update -y -q conda
else
    echo "Mac OS"
    OS=osx-64
fi

mkdir ~/conda-bld
conda config --set anaconda_upload no
export CONDA_BLD_PATH=${HOME}/conda-bld
echo "Cloning recipes"
git clone git://github.com/UV-CDAT/conda-recipes
cd conda-recipes
# uvcdat creates issues for build -c uvcdat confises package and channel
rm -rf uvcdat
python ./prep_for_build.py
conda build $PKG_NAME -c conda-forge -c uvcdat 
conda build $PKG_NAME -c uvcdat/label/nightly -c conda-forge -c uvcdat -c ${ESMF_CHANNEL} --python=3.6
anaconda -t $CONDA_UPLOAD_TOKEN upload -u $USER -l nightly $CONDA_BLD_PATH/$OS/$PKG_NAME-$VERSION.`date +%Y*`0.tar.bz2 --force
