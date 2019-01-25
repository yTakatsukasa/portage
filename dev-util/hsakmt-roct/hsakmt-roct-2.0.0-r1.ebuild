# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit git-r3

DESCRIPTION="Radeon Open Compute Thunk Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface.git"
EGIT_BRANCH="master"
EGIT_COMMIT="roc-$(ver_cut 1-3)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
DEPEND="sys-process/numactl"
IUSE="debug"
RESTRICT="debug? ( strip )"

src_configure() {
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
		CFLAGS="$(echo ${CFLAGS} | sed -e 's/-O.//g') -O0 -g"
		CXXFLAGS="$(echo ${CXXFLAGS} | sed -e 's/-O.//g') -O0 -g"
	else
		CMAKE_BUILD_TYPE=Release
	fi
    mkdir -p build; cd build
	cmake -L -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}  ..
}


src_compile() {
    cd build
    emake
}

src_install() {
    cd build
	insinto /usr/include/
	doins ../include/*.h
	into /usr/
	dolib.so lib*.so*
}
