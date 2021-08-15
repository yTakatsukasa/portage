# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="7"
inherit font

MY_PV="${PV/_p/-}"

DESCRIPTION="Mixing mplus and IPA fonts"
HOMEPAGE="http://mix-mplus-ipa.osdn.jp/"
SRC_URI="http://ja.osdn.net/dl/mix-mplus-ipa/migmix-1m-${MY_PV}.zip
	http://ja.osdn.net/dl/mix-mplus-ipa/migmix-1p-${MY_PV}.zip
	http://ja.osdn.net/dl/mix-mplus-ipa/migmix-2m-${MY_PV}.zip
	http://ja.osdn.net/dl/mix-mplus-ipa/migmix-2p-${MY_PV}.zip
	http://ja.osdn.net/dl/mix-mplus-ipa/migu-1p-${MY_PV}.zip
	http://ja.osdn.net/dl/mix-mplus-ipa/migu-1c-${MY_PV}.zip
	http://ja.osdn.net/dl/mix-mplus-ipa/migu-1m-${MY_PV}.zip
	http://ja.osdn.net/dl/mix-mplus-ipa/migu-2m-${MY_PV}.zip"

LICENSE="mplus-fonts IPAfont"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}"

FONT_SUFFIX="ttf"
FONT_S="${S}"

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	mv */*.${FONT_SUFFIX} "${FONT_S}" || die
}
