EAPI=7
inherit git-r3

DEPEND=dev-util/rocm-hip
DESCRIPTION="ROCm BLAS marshalling library"

HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS.git"
#EGIT_SUBMODULES=( '*' )
#EGIT_COMMIT="roc-${PV}.x"

SLOT="0"
KEYWORDS="~amd64"

src_configure() {
	#SMI and/or rocminfo accesses here
	addread /dev/kfd
	addwrite /dev/kfd
	if [ -d /dev/dri ]; then
		addread /dev/dri
		addwrite /dev/dri
	fi
	addpredict /dev/random
	einfo "devices"
	/opt/rocm/bin/rocm_agent_enumerator
	#Because Tensile works only on python2.7, but most of gentoo user uses 3.x as default. so set explicitly.
	sed -e 's/virtualenv.py/virtualenv.py -p python2.7/' -i cmake/virtualenv.cmake
    mkdir -p build; cd build
	env CXX=/opt/rocm/hcc/bin/hcc TENSILE_ROCM_ASSEMBLER_PATH=/opt/rocm/hcc/bin/hcc cmake -DCMAKE_BUILD_TYPE=Release ..
}

src_compile() {
    cd build
    emake
}

src_install()
{
    cd build
    emake DESTDIR=${D} install
}
