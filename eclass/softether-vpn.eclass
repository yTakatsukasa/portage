EAPI=5

inherit eutils

DESCRIPTION="SoftEther VPN"

HOMEPAGE="https://softether.org/"

RESTRICT="mirror"

REV=`echo ${PR} | /bin/sed -e s/r//g`
SRC_URI="http://jp.softether-download.com/files/softether/v${PV}-${REV}${VER_BETA}-${VER_DATE}-tree/Source_Code/softether-src-v${PV}-${REV}${VER_BETA}.tar.gz"
LICENSE="GPL2"

SLOT="0"
IUSE="+cmd +server -bridge -client"
DEPEND=""
RDEPEND="${DEPEND} sys-apps/ethtool"

S=${WORKDIR}/v${PV}-${REV}

src_prepare() {
	epatch ${FILESDIR}/Unix.c-no-threads-max.patch
	epatch ${FILESDIR}/Unix.c-pid-file-path.patch
	epatch ${FILESDIR}/Server.c-activate-all-feature.patch
	epatch ${FILESDIR}/Cedar.c-log-file-path.patch
}

src_configure() {
	if use arm; then
		echo "BITS	:= 32" > Makefile
	elif use x86; then
		echo "BITS	:= 32" > Makefile
	elif use amd64; then
		echo "BITS	:= 64" > Makefile
	fi
	cat ${FILESDIR}/Makefile >> Makefile
}

src_install() {
	# see files/Unix.c-no-threads-max.patch
	export DISABLE_LINUX_THREADS_MAX_SETTING=1
	dst=opt
	for target in server client cmd bridge; do
		Target=`echo $target | /bin/tr a-z A-Z`
		if use $target; then
			mkdir -p ${D}usr/bin
			emake INSTALL_VPN${Target}_DIR=${D}${dst}/vpn${target}/ INSTALL_BINDIR=${D}usr/bin/ ${D}usr/bin/vpn${target} || die
			rm -r ${D}usr
		fi
	done
	if use server; then
		newinitd ${FILESDIR}/vpnserver vpnserver || die
		mkdir -p ${D}/etc/softether/backup.vpn_server.config
		touch ${D}/etc/softether/vpn_server.config
		touch ${D}/etc/softether/lang.config
		dosym /etc/softether/vpn_server.config /${dst}/vpnserver/vpn_server.config
		dosym /etc/softether/lang.config /${dst}/vpnserver/lang.config
		dosym /etc/softether/backup.vpn_server.config /${dst}/vpnserver/backup.vpn_server.config
		mkdir -p ${D}/var/log/softether
	fi
	if use cmd; then
		dosym /${dst}/vpncmd/vpncmd /usr/sbin/vpncmd
	fi
}
