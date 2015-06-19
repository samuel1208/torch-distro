#!/bin/bash
currdir=`dirname $0`
currdir=$(cd "$currdir" && pwd)
#######################################
PREFIX="${currdir}/install"
#######################################

echo "Prefix set to $PREFIX"

if [[ `uname` == 'Linux' ]]; then
    export CMAKE_LIBRARY_PATH=/opt/OpenBLAS/include:/opt/OpenBLAS/lib:$CMAKE_LIBRARY_PATH
fi

git submodule init
git submodule update
git submodule foreach git pull origin master

mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DCMAKE_BUILD_TYPE=Release
make && make install
cd ..

# check if we are on mac and fix RPATH for local install
path_to_install_name_tool=$(which install_name_tool)
if [ -x "$path_to_install_name_tool" ]
then
   install_name_tool -id ${PREFIX}/lib/libluajit.dylib ${PREFIX}/lib/libluajit.dylib
fi

$PREFIX/bin/luarocks install luafilesystem
$PREFIX/bin/luarocks install penlight
$PREFIX/bin/luarocks install lua-cjson


### intall the exe 
cd ${currdir}/exe/qtlua && $PREFIX/bin/luarocks make rocks/qtlua-scm-1.rockspec && sudo rm -rf build/*
cd ${currdir}/exe/trepl && $PREFIX/bin/luarocks make trepl-scm-1.rockspec

### install the packages
cd ${currdir}/pkg/sundown && $PREFIX/bin/luarocks make rocks/sundown-scm-1.rockspec && sudo rm -rf */*.o libsundown.so
cd ${currdir}/pkg/cwrap && $PREFIX/bin/luarocks make rocks/cwrap-scm-1.rockspec
cd ${currdir}/pkg/paths && $PREFIX/bin/luarocks make rocks/paths-scm-1.rockspec && sudo rm -rf build/*
cd ${currdir}/pkg/torch && $PREFIX/bin/luarocks make rocks/torch-scm-1.rockspec && sudo rm -rf build/*
cd ${currdir}/pkg/itorch && $PREFIX/bin/luarocks make itorch-scm-1.rockspec && sudo rm -rf build/*
cd ${currdir}/pkg/dok && $PREFIX/bin/luarocks make rocks/dok-scm-1.rockspec
cd ${currdir}/pkg/gnuplot && $PREFIX/bin/luarocks make rocks/gnuplot-scm-1.rockspec
cd ${currdir}/pkg/qttorch && $PREFIX/bin/luarocks make rocks/qttorch-scm-1.rockspec && sudo rm -rf build/*
cd ${currdir}/pkg/sys && $PREFIX/bin/luarocks make sys-1.1-0.rockspec && sudo rm -rf build/*
cd ${currdir}/pkg/xlua && $PREFIX/bin/luarocks make xlua-1.0-0.rockspec
cd ${currdir}/pkg/image && $PREFIX/bin/luarocks make image-1.1.alpha-0.rockspec
cd ${currdir}/pkg/optim && $PREFIX/bin/luarocks make optim-1.0.5-0.rockspec && sudo rm -rf build/*

### install the extra modules
cd ${currdir}/extra/nn && $PREFIX/bin/luarocks make rocks/nn-scm-1.rockspec && sudo rm -rf build/*
path_to_nvidiasmi=$(which nvidia-smi)
if [ -x "$path_to_nvidiasmi" ]
then
    cd ${currdir}/extra/cutorch && $PREFIX/bin/luarocks make rocks/cutorch-scm-1.rockspec
    cd ${currdir}/extra/cunn && $PREFIX/bin/luarocks make rocks/cunn-scm-1.rockspec
    cd ${currdir}/extra/cudnn && $PREFIX/bin/luarocks make cudnn-scm-1.rockspec
fi
cd ${currdir}/extra/sdl2 && $PREFIX/bin/luarocks make rocks/sdl2-scm-1.rockspec
cd ${currdir}/extra/threads && $PREFIX/bin/luarocks make rocks/threads-scm-1.rockspec
cd ${currdir}/extra/graphicsmagick && $PREFIX/bin/luarocks make graphicsmagick-1.scm-0.rockspec
cd ${currdir}/extra/gfx.js && $PREFIX/bin/luarocks make gfx.js-scm-0.rockspec  
cd ${currdir}/extra/argcheck && $PREFIX/bin/luarocks make rocks/argcheck-scm-1.rockspec
cd ${currdir}/extra/audio && $PREFIX/bin/luarocks make audio-0.1-0.rockspec && sudo rm -rf build/*
cd ${currdir}/extra/fftw3 && $PREFIX/bin/luarocks make rocks/fftw3-scm-1.rockspec
cd ${currdir}/extra/signal && $PREFIX/bin/luarocks make rocks/signal-scm-1.rockspec
cd ${currdir}/extra/nnx && $PREFIX/bin/luarocks make nnx-0.1-1.rockspec && sudo rm -rf build/*
cd ${currdir}/extra/unsup && $PREFIX/bin/luarocks make unsup-0.1-0.rockspec && sudo rm -rf build/*
cd ${currdir}/extra/manifold && $PREFIX/bin/luarocks make manifold-scm-0.rockspec
cd ${currdir}/extra/metriclearning && $PREFIX/bin/luarocks install metriclearning
cd ${currdir}/extra/dp && $PREFIX/bin/luarocks install dp
cd ${currdir}/extra/decomposition  && $PREFIX/bin/luarocks make decomposition-scm-0.rockspec 
cd ${currdir}/extra/lmdb  && $PREFIX/bin/luarocks make lmdb.torch-scm-1.rockspec && rm -rf build/*

## should add `pwd`/install into the path, otherwise it can't find the torch_config.cmake
#cd ${currdir}/extra/torch-svm && $PREFIX/bin/luarocks make svm-0.1-0.rockspec && sudo rm -rf build/*
