EAPI=7
inherit git-r3

DEPEND="dev-util/rocm-hip \
	dev-util/roc-sparse \
"
DESCRIPTION="ROCm SPARSE marshalling library"

HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSPARSE"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/hipSPARSE.git"
#EGIT_SUBMODULES=( '*' )
#EGIT_COMMIT="roc-${PV}.x"

SLOT="0"
KEYWORDS="~amd64"

src_configure() {
    mkdir -p build; cd build
	cmake -DCMAKE_BUILD_TYPE=Release ..
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
