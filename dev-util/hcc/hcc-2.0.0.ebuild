EAPI=7
inherit git-r3

DESCRIPTION="HCC is an Open Source, Optimizing C++ Compiler for Heterogeneous Compute currently for the ROCm GPU Computing Platform"
HOMEPAGE="https://github.com/RadeonOpenCompute/hcc/wiki"

EGIT_REPO_URI="https://github.com/RadeonOpenCompute/hcc.git"
EGIT_SUBMODULES=( '*' )
EGIT_COMMIT="roc-${PV}"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64"
DEPEND=dev-util/hsa-rocr

src_configure() {
    mkdir -p build; cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="/opt/rocm/hcc" -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-rpath=/opt/rocm/hcc/lib' ..
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
