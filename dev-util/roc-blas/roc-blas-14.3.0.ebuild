EAPI=7
inherit git-r3

DEPEND=dev-util/rocm-hip
DESCRIPTION="ROCm BLAS marshalling library"

HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS.git"
EGIT_BRANCH="master"
EGIT_COMMIT="v${PV}"

SLOT="0"
KEYWORDS="amd64"
IUSE="debug"
RESTRICT="debug? ( strip )"

src_configure() {
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
		CFLAGS="$(echo ${CFLAGS} | sed -e 's/-O.//g') -O0 -g"
		CXXFLAGS="$(echo ${CXXFLAGS} | sed -e 's/-O.//g') -O0 -g"
	else
		CMAKE_BUILD_TYPE=Release
	fi
	#SMI and/or rocminfo accesses here
	addpredict /dev/kfd
	#addread /dev/kfd
	#addwrite /dev/kfd
	#if [ -d /dev/dri ]; then
		#addread /dev/dri
		#addwrite /dev/dri
	#fi
	addpredict /dev/random
	einfo "devices"
	/opt/rocm/bin/rocm_agent_enumerator
	#Because Tensile works only on python2.7, but most of gentoo user uses 3.x as default. so set explicitly.
	sed -e 's/virtualenv.py/virtualenv.py -p python2.7/' -i cmake/virtualenv.cmake
    mkdir -p build; cd build
	env CXX=/opt/rocm/hcc/bin/hcc TENSILE_ROCM_ASSEMBLER_PATH=/opt/rocm/hcc/bin/hcc cmake -L -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ..
}

src_compile() {
    cd build
    emake
}

src_install()
{
    cd build
    emake DESTDIR=${D} install
}
