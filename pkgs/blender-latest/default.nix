{ config
, stdenv
, lib
, fetchurl
, boost
, cmake
, ffmpeg
, gettext
, glew
, ilmbase
, libXi
, libX11
, libXext
, libXrender
, libjpeg
, libpng
, libsamplerate
, libsndfile
, libtiff
, libGLU
, libGL
, openal
, opencolorio
, openexr
, openimagedenoise
, openimageio2
, openjpeg
, openvdb
, libXxf86vm
, tbb
, alembic
, zlib
, fftw
, opensubdiv
, freetype
, jemalloc
, ocl-icd
, addOpenGLRunpath
, jackaudioSupport ? false, libjack2
, colladaSupport ? true, opencollada
, spaceNavSupport ? stdenv.isLinux, libspnav
, makeWrapper
, pugixml
, llvmPackages
, SDL
, potrace
, openxr-loader
, embree
, gmp
, python310Packages
, python310
, libharu
, git
, zstd
}:

with lib;
stdenv.mkDerivation rec {
  pname = "blender";
  version = "3.1.0";

  src = fetchurl {
    url = "https://download.blender.org/source/${pname}-${version}.tar.xz";
    sha256 = "sha256-HCbT0zz71EVlArBoegjE0cE6v4fHSm8bpwZ99pc5BLQ=";
  };

  nativeBuildInputs = [ cmake makeWrapper python310Packages.wrapPython llvmPackages.llvm.dev ];
  buildInputs =
    [ boost 
      ffmpeg 
      gettext 
      glew 
      ilmbase
      freetype 
      libjpeg 
      libpng 
      libsamplerate 
      libsndfile 
      libtiff
      opencolorio 
      openexr 
      openimagedenoise 
      openimageio2 
      openjpeg 
      python310 
      zlib 
      fftw 
      jemalloc
      alembic
      (opensubdiv.override { })
      tbb
      embree
      gmp
      pugixml
      potrace
      libharu
      git
      zstd
    ]
    ++ (if (!stdenv.isDarwin) then [
      libXi libX11 libXext libXrender
      libGLU libGL openal
      libXxf86vm
      openxr-loader
      # OpenVDB currently doesn't build on darwin
      openvdb
    ]
    else [
      llvmPackages.openmp SDL Cocoa CoreGraphics ForceFeedback OpenAL OpenGL
    ])
    ++ optional jackaudioSupport libjack2
    #++ optional cudaSupport cudatoolkit
    ++ optional colladaSupport opencollada
    ++ optional spaceNavSupport libspnav;
  pythonPath = with python310Packages; [ numpy requests ];

  postPatch = ''
    # allow usage of dynamically linked embree
    rm build_files/cmake/Modules/FindEmbree.cmake
  '';

  cmakeFlags =
    [
      "-DWITH_ALEMBIC=ON"
      "-DWITH_MOD_OCEANSIM=ON"
      "-DWITH_CODEC_FFMPEG=ON"
      "-DWITH_CODEC_SNDFILE=ON"
      "-DWITH_INSTALL_PORTABLE=OFF"
      "-DWITH_FFTW3=ON"
      "-DWITH_SDL=OFF"
      "-DWITH_OPENCOLORIO=ON"
      "-DWITH_OPENSUBDIV=ON"
      "-DPYTHON_LIBRARY=${python310.libPrefix}"
      "-DPYTHON_LIBPATH=${python310}/lib"
      "-DPYTHON_INCLUDE_DIR=${python310}/include/${python310.libPrefix}"
      "-DPYTHON_VERSION=${python310.pythonVersion}"
      "-DWITH_PYTHON_INSTALL=OFF"
      "-DWITH_PYTHON_INSTALL_NUMPY=OFF"
      "-DPYTHON_NUMPY_PATH=${python310Packages.numpy}/${python310.sitePackages}"
      "-DPYTHON_NUMPY_INCLUDE_DIRS=${python310Packages.numpy}/${python310.sitePackages}/numpy/core/include"
      "-DWITH_PYTHON_INSTALL_REQUESTS=OFF"
      "-DWITH_OPENVDB=ON"
      "-DWITH_TBB=ON"
      "-DWITH_IMAGE_OPENJPEG=ON"
      "-DWITH_OPENCOLLADA=${if colladaSupport then "ON" else "OFF"}"
    ]
    ++ optionals stdenv.isDarwin [
      "-DWITH_CYCLES_OSL=OFF" # requires LLVM
      "-DWITH_OPENVDB=OFF" # OpenVDB currently doesn't build on darwin

      "-DLIBDIR=/does-not-exist"
    ];
    # Clang doesn't support "-export-dynamic"
    #++ optional stdenv.cc.isClang "-DPYTHON_LINKFLAGS="
    #++ optional jackaudioSupport "-DWITH_JACK=ON"
    #++ optional cudaSupport [
    #  "-DWITH_CYCLES_CUDA_BINARIES=ON"
    #  "-DWITH_CYCLES_DEVICE_OPTIX=ON"
    #  "-DOPTIX_ROOT_DIR=${optix}"
    #];

  #NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR -I${python}/include/${python.libPrefix}";

  # Since some dependencies are built with gcc 6, we need gcc 6's
  # libstdc++ in our RPATH. Sigh.
  #NIX_LDFLAGS = optionalString cudaSupport "-rpath ${stdenv.cc.cc.lib}/lib";

  blenderExecutable = placeholder "out/bin/blender";

  # Set RUNPATH so that libcuda and libnvrtc in /run/opengl-driver(-32)/lib can be
  # found. See the explanation in libglvnd.
  #postFixup = optionalString cudaSupport ''
  #  for program in $out/bin/blender $out/bin/.blender-wrapped; do
  #    isELF "$program" || continue
  #    addOpenGLRunpath "$program"
  #  done
  #'';
}
