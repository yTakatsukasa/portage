EAPI=7
inherit git-r3

DEPEND=dev-util/hsa-rocr
DESCRIPTION="HIP : Convert CUDA to Portable C++ Code"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP/"

EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP.git"
#EGIT_SUBMODULES=( '*' )
#EGIT_COMMIT="roc-${PV}.x"
EGIT_OVERRIDE_BRANCH_ROCM_DEVELOPER_TOOLS_HIP="roc-${PV}.x"

SLOT="0"
KEYWORDS="~amd64"

src_configure() {
    mkdir -p build; cd build
	cmake -DHSA_PATH=/opt/rocm -DCMAKE_BUILD_TYPE=Release ..
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