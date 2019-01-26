EAPI=7
inherit git-r3

DEPEND="dev-util/hip-cub
	"
DESCRIPTION="HIP back-end for Thrust"

HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Thrust"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/Thrust.git"
#No cub
EGIT_SUBMODULES=( "-thrust/system/cuda/detail/cub-hip" )
#EGIT_COMMIT="roc-${PV}.x"

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
