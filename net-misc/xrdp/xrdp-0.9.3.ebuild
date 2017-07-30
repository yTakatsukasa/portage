# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils pam

DESCRIPTION="An open source Remote Desktop Protocol server"
HOMEPAGE="http://www.xrdp.org/"
SRC_URI="https://github.com/neutrinolabs/xrdp/releases/download/v0.9.3/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/openssl:0=
	x11-libs/libX11:0=
	x11-libs/libXfixes:0=
	x11-libs/libXrandr:0=
	net-misc/tigervnc:0[server,xorgmodule]
	"

DEPEND="${RDEPEND}"

src_prepare() {
	epatch_user
	./bootstrap.sh
}

src_configure() {
	econf "${myconf[@]}"
}

src_install() {
	default
	prune_libtool_files --all

	# and our startwm.sh
	exeinto /etc/xrdp
	doexe "${FILESDIR}"/startwm.sh

	# Fedora stuff
	rm -r "${ED}"/etc/default || die

	# own /etc/xrdp/rsakeys.ini
	: > rsakeys.ini
	insinto /etc/xrdp
	doins rsakeys.ini

	# contributed by Jan Psota <jasiupsota@gmail.com>
	newinitd "${FILESDIR}/${PN}-initd" ${PN}
}

pkg_preinst() {
	# either copy existing keys over to avoid CONFIG_PROTECT whining
	# or generate new keys (but don't include them in binpkg!)
	if [[ -f ${EROOT}/etc/xrdp/rsakeys.ini ]]; then
		cp {"${EROOT}","${ED}"}/etc/xrdp/rsakeys.ini || die
	else
		einfo "Running xrdp-keygen to generate new rsakeys.ini ..."
		"${S}"/keygen/xrdp-keygen xrdp "${ED}"/etc/xrdp/rsakeys.ini \
			|| die "xrdp-keygen failed to generate RSA keys"
	fi
}

pkg_postinst() {
	# check for use of bundled rsakeys.ini (installed by default upstream)
	if [[ $(cksum "${EROOT}"/etc/xrdp/rsakeys.ini) == '2935297193 1019 '* ]]
	then
		ewarn "You seem to be using upstream bundled rsakeys.ini. This means that"
		ewarn "your communications are encrypted using a well-known key. Please"
		ewarn "consider regenerating rsakeys.ini using the following command:"
		ewarn
		ewarn "  ${EROOT}/usr/bin/xrdp-keygen xrdp ${EROOT}/etc/xrdp/rsakeys.ini"
		ewarn
	fi

	elog "Various session types require different backend implementations:"
	elog "- sesman-Xvnc requires net-misc/tigervnc[server,xorgmodule]"
	elog "- sesman-X11rdp requires net-misc/x11rdp"
}
