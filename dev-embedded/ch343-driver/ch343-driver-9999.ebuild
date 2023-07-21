EAPI=7

DESCRIPTION="CH343 kernel driver"

HOMEPAGE="https://github.com/WCHSoftGroup/ch343ser_linux"

EGIT_REPO_URI="https://github.com/WCHSoftGroup/ch343ser_linux.git"
EGIT_CHECKOUT_DIR=${WORKDIR}/ch343ser_linux
S=${EGIT_CHECKOUT_DIR}

inherit eutils autotools git-r3 linux-mod

RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELDIR=${KV_DIR} KERNOUT=${KV_OUT_DIR}"
	MODULE_NAMES="ch343(usb/serial:${S}/driver:${S}/driver)"
	BUILD_TARGETS="default"
}

src_unpack() {
	git-r3_src_unpack
}

src_configure() {
	rm -f ${S}/Module.symvers
}

src_compile() {
	linux-mod_src_compile || die "driver compile failed"
}

src_install() {
	linux-mod_src_install || die "driver install failed"
}

pkg_preinst() {
	linux-mod_pkg_preinst
}

pkg_postinst() {
	linux-mod_pkg_postinst
}

