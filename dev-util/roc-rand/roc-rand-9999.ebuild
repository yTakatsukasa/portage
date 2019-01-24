EAPI=7
inherit git-r3

DEPEND="dev-util/hcc \
	dev-util/rocm-hip \
	dev-util/rocm-cmake \
	"
DESCRIPTION="RAND library for HIP programming language "

HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocRAND.git"
#EGIT_SUBMODULES=( '*' )
#EGIT_COMMIT="roc-${PV}.x"

SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"
RESTRICT="debug? ( strip )"

src_configure() {
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi
    mkdir -p build; cd build
	env CXX=/opt/rocm/hcc/bin/hcc cmake -L -DBUILD_TEST=OFF -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ..
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
