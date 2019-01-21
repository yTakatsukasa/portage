EAPI=7
inherit git-r3

DEPEND=dev-util/rocm-hip
DESCRIPTION="ROCm BLAS marshalling library"

HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS/"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/hipBLAS.git"
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
