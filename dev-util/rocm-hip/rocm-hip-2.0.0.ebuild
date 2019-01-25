EAPI=7
inherit git-r3

DEPEND="dev-util/hsa-rocr \
	dev-util/hcc \
	"
DESCRIPTION="HIP : Convert CUDA to Portable C++ Code"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP/"

EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP.git"
EGIT_COMMIT="roc-${PV}"
EGIT_BRANCH="roc-$(ver_cut 1-2).x"

SLOT="0"
KEYWORDS="amd64"
IUSE="debug"
RESTRICT="debug? ( strip )"



src_configure() {
	if use debug; then
		#CMAKE_BUILD_TYPE=Debug or RelWithDebInfo causes hipBlas build failure
		CMAKE_BUILD_TYPE=Release
		CFLAGS="$(echo ${CFLAGS} | sed -e 's/-O.//g') -O0 -g"
		CXXFLAGS="$(echo ${CXXFLAGS} | sed -e 's/-O.//g') -O0 -g"
	else
		CMAKE_BUILD_TYPE=Release
	fi
    mkdir -p build; cd build
	#Because the following cmake command copies some .cmake to isntallation directory.
	cmake -L -DHIP_PLATFORM=hcc -DHSA_PATH=/opt/rocm -DCMAKE_INSTALL_PREFIX=${D}/opt/rocm/hip -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ..
}

src_compile() {
    cd build
    emake
}

src_install()
{
    cd build
    emake DESTDIR=/ install
	for f in ${D}/opt/rocm/hip/lib/cmake/hip/*.cmake; do
		sed -i -s "s|${D}||g" ${f}
	done
}
