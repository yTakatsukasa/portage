EAPI=7
inherit git-r3

DESCRIPTION="Rocm cmake modules"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm-cmake"

EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm-cmake.git"
#EGIT_SUBMODULES=( '*' )
#EGIT_COMMIT="roc-${PV}.x"

SLOT="0"
KEYWORDS="~amd64"

src_configure() {
    mkdir -p build; cd build
	cmake .. -DCMAKE_INSTALL_PREFIX=${D}/opt/rocm/
}

src_compile() {
    cd build
    emake
}

src_install()
{
    cd build
    emake install
}
