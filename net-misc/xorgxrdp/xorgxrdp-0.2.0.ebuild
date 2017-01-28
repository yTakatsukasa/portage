EAPI=6

inherit eutils
#
DESCRIPTION="X plugin for xrdp"

HOMEPAGE="http://www.xrdp.org/"

SRC_URI="https://github.com/neutrinolabs/xorgxrdp/releases/download/v0.2.0/${P}.tar.gz"


LICENSE=""

SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND=">=net-misc/xrdp-0.9"

RDEPEND="${DEPEND}"

