EAPI=7
inherit git-r3

IUSE="debug +hip_amd hip_nv"
DEPEND="dev-util/hsa-rocr \
	dev-util/hcc \
	hip_nv? ( dev-util/nvidia-cuda-sdk ) \
	"
DESCRIPTION="HIP : Convert CUDA to Portable C++ Code"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP/"

EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP.git"
EGIT_COMMIT="roc-${PV}"
EGIT_BRANCH="roc-$(ver_cut 1-2).x"

BACKENDS="hip_amd hip_nv"
SLOT="0"
KEYWORDS="amd64"
#Always disable strip because stripped library cause hipMemsetAsync failure.
#RESTRICT="debug? ( strip )"
RESTRICT="strip"


src_configure() {
	if use debug; then
		#CMAKE_BUILD_TYPE=Debug or RelWithDebInfo causes hipBlas build failure
		CMAKE_BUILD_TYPE=Release
		CFLAGS="$(echo ${CFLAGS} | sed -e 's/-O.//g') -O0 -g"
		CXXFLAGS="$(echo ${CXXFLAGS} | sed -e 's/-O.//g') -O0 -g"
	else
		CMAKE_BUILD_TYPE=Release
	fi

	for backend in ${BACKENDS}; do
		if use $backend; then
			einfo "Configuring for $backend"
			if [ $backend = "hip_amd" ]; then
				#Force to use hipBlas
				CUDA_TOOLKIT_ROOT_DIR=/dev/null
				INSTALL_PREFIX=/opt/rocm
				HIP_PLATFORM=hcc
			else
				CUDA_TOOLKIT_ROOT_DIR=/opt/cuda
				INSTALL_PREFIX=/opt/rocm_nv
				HIP_PLATFORM=nvcc
			fi
			mkdir -p build_${backend}; cd build_${backend}
			#Because the following cmake command copies some .cmake to isntallation directory.
			cmake -L \
				-DHIP_PLATFORM=${HIP_PLATFORM} \
				-DHSA_PATH=${INSTALL_PREFIX} \
				-DCMAKE_INSTALL_PREFIX=${D}/${INSTALL_PREFIX}/hip \
				-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} .. || die
			cd ..
		fi
	done
}

src_compile() {
	for backend in ${BACKENDS}; do
		if use $backend; then
			emake -C build_${backend} || die
		fi
	done
}

src_install() {
    cd build
	for backend in ${BACKENDS}; do
		if use $backend; then
			if [ $backend = "hip_amd" ]; then
				INSTALL_PREFIX=/opt/rocm
			else
				INSTALL_PREFIX=/opt/rocm_nv
			fi
			emake -C build_${backend} DESTDIR=/ install || die
			for f in ${D}/${INSTALL_PREFIX}/hip/lib/cmake/hip/*.cmake; do
				sed -i -s "s|${D}||g" ${f}
			done
		fi
	done
}
