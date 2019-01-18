# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6

inherit cmake-utils

DESCRIPTION="ROCm Platform Runtime: ROCr a HPC market enhanced HSA based runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCR-Runtime"
EXT_ROCR_NAME="hsa-ext-rocr-dev_1.1.9-45-ge88639f_amd64.deb"
SRC_URI="
    https://github.com/RadeonOpenCompute/ROCR-Runtime/archive/roc-${PV}.tar.gz -> ${P}.tar.gz
    hsa-ext? ( http://repo.radeon.com/rocm/apt/debian/pool/main/h/hsa-ext-rocr-dev/${EXT_ROCR_NAME} )
"

LICENSE="NCSA"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}/${P}/src"

IUSE="+hsa-ext"

DEPEND="dev-util/hsakmt-roct"
RDEPEND="${DEPEND}"

src_unpack() {
    unpack ${A}
    mv ROCR-Runtime-roc-${PV} ${P}
    if use hsa-ext; then
        tar xf data.tar.gz
    fi
    cd "${S}"
    epatch "${FILESDIR}/install.patch"
    #epatch "${FILESDIR}/fix-compile-error.patch"
}

src_install() {
    cmake-utils_src_install

    if use hsa-ext; then
        cd ${WORKDIR}/opt/rocm/hsa/lib
        cp -a libhsa-* ${ED}/usr/lib64 || die
    fi
}
