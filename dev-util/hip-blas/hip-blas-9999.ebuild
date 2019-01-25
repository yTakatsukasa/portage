EAPI=7
inherit git-r3

DEPEND="dev-util/rocm-hip \
	dev-util/roc-blas \
	"
DESCRIPTION="ROCm BLAS marshalling library"

HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS/"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/hipBLAS.git"
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
	cmake -L -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ..
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
