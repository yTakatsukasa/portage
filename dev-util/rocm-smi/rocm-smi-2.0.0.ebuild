EAPI=7
inherit git-r3

DESCRIPTION="Rocm cmake modules"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROC-smi"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROC-smi.git"
#EGIT_SUBMODULES=( '*' )
EGIT_COMMIT="roc-${PV}"
EGIT_BRANCH="roc-$(ver_cut 1-2).x"
SLOT="0"
KEYWORDS="amd64"

src_compile() {
	#Nothing to do
	einfo "Nothing to do"
}

src_install() {
	into "/opt/rocm/"
	dobin rocm_smi.py rocm-smi
}
