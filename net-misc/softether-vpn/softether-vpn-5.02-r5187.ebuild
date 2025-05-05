EAPI=8
inherit "git-r3"

DESCRIPTION="Cross-platform multi-protocol VPN software."

HOMEPAGE="https://github.com/SoftEtherVPN/SoftEtherVPN"

EGIT_REPO_URI="https://github.com/SoftEtherVPN/SoftEtherVPN.git"
EGIT_COMMIT="5.02.5187"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="amd64"

IUSE="+cmd +server -bridge -client"

PATCHES=(
	"${FILESDIR}/Server.c-activate-all-feature.patch"
)

src_configure() {
	mkdir -p build
	pushd build
	cmake -DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DSE_LOGDIR=/var/log/softether \
		-DSE_DBDIR=/etc/softether \
		-DSE_PIDDIR=/var/run \
		-L \
		..
	popd
}

src_compile() {
	pushd build
	emake
	popd
}

src_install() {
	pushd build
	emake DESTDIR="${D}" install
	if use server; then
		newinitd ${FILESDIR}/vpnserver vpnserver || die
		mkdir -p ${D}/etc/softether/backup.vpn_server.config
		touch ${D}/etc/softether/vpn_server.config
		touch ${D}/etc/softether/lang.config
		mkdir -p ${D}/var/log/softether
		touch ${D}/var/log/softether/.keep
	fi
	popd
}
