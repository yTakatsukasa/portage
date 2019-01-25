EAPI=7
inherit git-r3

DEPEND=dev-util/hcc
DESCRIPTION="Next generation SPARSE implementation for ROCm platform "

HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSPARSE"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocSPARSE.git"
#EGIT_SUBMODULES=( '*' )
#EGIT_COMMIT="roc-${PV}.x"

SLOT="0"
KEYWORDS="~amd64"
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
    mkdir -p build; cd build
	env CXX=/opt/rocm/hcc/bin/hcc cmake -L -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ..
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
