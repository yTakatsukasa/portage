EAPI=7
inherit git-r3

IUSE="debug +roc_amd roc_nv"
DEPEND="dev-util/rocm-hip \
	roc_amd? ( dev-util/roc-blas ) \
	roc_nv? ( dev-util/nvidia-cuda-sdk ) \
	"
BACKENDS="roc_amd roc_nv"
REQUIRED_USE="|| ( $BACKENDS )"
DESCRIPTION="ROCm BLAS marshalling library"

HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS/"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/hipBLAS.git"
EGIT_COMMIT=v${PV}
EGIT_BRANCH="master"

SLOT="0"
KEYWORDS="amd64"
RESTRICT="debug? ( strip )"
src_configure() {
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
		CFLAGS="$(echo ${CFLAGS} | sed -e 's/-O.//g') -O0 -g"
		CXXFLAGS="$(echo ${CXXFLAGS} | sed -e 's/-O.//g') -O0 -g"
	else
		CMAKE_BUILD_TYPE=Release
	fi
	for backend in ${BACKENDS}; do
		if use $backend; then
			einfo "Configuring for $backend"
			if [ $backend = "roc_amd" ]; then
				#Force to use hipBlas
				CUDA_TOOLKIT_ROOT_DIR=/dev/null
				CMAKE_INSTALL_PREFIX=/opt/rocm
			else
				CUDA_TOOLKIT_ROOT_DIR=/opt/cuda
				CMAKE_INSTALL_PREFIX=/opt/rocm_nv
			fi
			mkdir -p build_${backend}; cd build_${backend}
			cmake -L \
				-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
				-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
				-DCUDA_TOOLKIT_ROOT_DIR=${CUDA_TOOLKIT_ROOT_DIR} .. || die
			cd ..
		fi
	done
}

src_compile() {
	for backend in ${BACKENDS}; do
		if use $backend; then
			emake -C build_${backend}
		fi
	done
}

src_install() {
	for backend in ${BACKENDS}; do
		if use $backend; then
			emake -C build_${backend} DESTDIR=${D} install
		fi
	done
}
