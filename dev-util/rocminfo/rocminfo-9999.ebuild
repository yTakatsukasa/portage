EAPI=7
inherit git-r3

DEPEND="dev-util/hsa-rocr dev-util/rocm-cmake"
DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"

EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocminfo.git"

SLOT="0"
KEYWORDS="~amd64"

src_configure() {
    mkdir -p build; cd build
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${D}/opt/rocm/" ..
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
