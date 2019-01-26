EAPI=7
inherit git-r3

DEPEND=""
DESCRIPTION="An implementation of CUB on the ROCM stack. Currently Beta."
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/cub-hip/"
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/cub-hip.git"
EGIT_BRANCH="hip_port_${PV}"

SLOT="0"
KEYWORDS="amd64"
IUSE="debug"
RESTRICT="debug? ( strip )"

src_configure() {
    mkdir -p build; cd build
	cmake -L -DCMAKE_INSTALL_PREFIX=${D}/opt/rocm .. || die
}

src_compile() {
    emake -C build || die
}

src_install() {
    emake -C build install || die
}
