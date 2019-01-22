EAPI=7
inherit git-r3

DEPEND=dev-util/hcc
DESCRIPTION="RAND library for HIP programming language "

HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocRAND.git"
#EGIT_SUBMODULES=( '*' )
#EGIT_COMMIT="roc-${PV}.x"

SLOT="0"
KEYWORDS="~amd64"

src_configure() {
    mkdir -p build; cd build
	env CXX=/opt/rocm/hcc/bin/hcc cmake -DCMAKE_BUILD_TYPE=Release ..
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
