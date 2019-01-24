EAPI=7
inherit git-r3

DESCRIPTION="Rocm cmake modules"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROC-smi"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm_bandwidth_test.git"
#EGIT_SUBMODULES=( '*' )
EGIT_COMMIT="roc-${PV}"
EGIT_BRANCH="master"
SLOT="0"
KEYWORDS="amd64"
IUSE="debug"
RESTRICT="debug? ( strip )"

src_configure() {
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi
	mkdir -p build && cd build
	cmake -L -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ..
}

src_compile() {
	cd build
	emake
}

src_install() {
	cd build
	exeinto /opt/rocm/bin/
	doexe rocm_bandwidth_test
}
