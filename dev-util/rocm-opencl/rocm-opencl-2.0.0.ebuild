EAPI=7

DESCRIPTION="ROCm OpenCL™ Compatible Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
GIT_REVISION="184c0efb3ad33c7326850fd8d790a3822e62a302"

DEPEND="
    dev-lang/python:2.7
    dev-vcs/git[subversion]
    net-misc/curl
    dev-lang/ocaml
    dev-ml/findlib
    sci-mathematics/z3
    dev-cpp/gtest
"
RDEPEND="
    app-eselect/eselect-opencl
"

BUILD_DIR="${S}_build"
CMAKE_USE_DIR="${S}/opencl"
CMAKE_BUILD_TYPE="Release"

src_unpack() {
    mkdir -p "${S}" && cd "${S}"
    curl https://storage.googleapis.com/git-repo-downloads/repo > ./repo
    chmod a+x ./repo
    python2 ./repo init -u https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime.git -b ${GIT_REVISION} -m opencl.xml
    python2 ./repo sync
}

src_configure() {
    mkdir -p "${BUILD_DIR}" || die "Failed to create build dir"
    cd "${BUILD_DIR}"
    cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCLANG_ENABLE_STATIC_ANALYZER=On "${CMAKE_USE_DIR}"
}

src_compile() {
    cd "${BUILD_DIR}" && emake || die "emake failed"
}

src_install() {
    VENDOR_DIR="/usr/$(get_libdir)/OpenCL/vendors/${PN}"
    insinto "${VENDOR_DIR}"
    doins "${BUILD_DIR}/lib/libOpenCL.so.1.2"
    doins "${BUILD_DIR}/lib/libamdocl64.so"
    fperms a+x "${VENDOR_DIR}/libOpenCL.so.1.2"
    fperms a+x "${VENDOR_DIR}/libamdocl64.so"
    dosym libOpenCL.so.1.2 "${VENDOR_DIR}/libOpenCL.so.1"
    dosym libOpenCL.so.1.2 "${VENDOR_DIR}/libOpenCL.so"
	insinto /etc/OpenCL/vendors/
    echo "${VENDOR_DIR}/libamdocl64.so" > "${PN}.icd" || die "Failed to generate ICD file"
	doins "${PN}.icd"
}
