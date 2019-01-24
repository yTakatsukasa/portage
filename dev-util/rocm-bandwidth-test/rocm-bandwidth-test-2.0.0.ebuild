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

	src_configure() {
	mkdir -p build && cd build
	cmake -L ..
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
