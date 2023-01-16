# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


inherit savedconfig toolchain-funcs

DESCRIPTION="Fast System Information Tool Written in C"
HOMEPAGE="https://github.com/connor-gh/${PN}"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/connor-gh/${PN}.git"
else
	SRC_URI="https://github.com/Connor-GH/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~ppc64 ~riscv ~x86"
fi

IUSE="minimal savedconfig xcb"
LICENSE="Apache-2.0"
SLOT="0"
RDEPEND="
		!xcb? (
			>=x11-libs/libXrandr-1.2.0
		)
		xcb? (
			x11-libs/libxcb
		)
		!minimal? (
			x11-libs/libX11
			sys-apps/pciutils
		)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	restore_config config.mk

}

src_configure() {
	if use xcb && use minimal; then
		die "Cannot enable xcb and minimal flags together. Disable one."
	fi
	CONFIGURE_MAKE_FLAGS=

	if use minimal; then
		CONFIGURE_MAKE_FLAGS="\
			M_RESOLUTION=n M_REFRESH_RATE=n M_WM=n M_GPU=n"
	fi

	if use xcb; then
		CONFIGURE_MAKE_FLAGS="$CONFIGURE_MAKE_FLAGS \
			M_RESOLUTION_XCB=y M_REFRESH_RATE_XCB=y"
	fi
}


src_install() {

	emake $CONFIGURE_MAKE_FLAGS DESTDIR="${D}" \
		CC="$(tc-getCC)" LINKER="$(tc-getLD)" install \
		|| die "emake install failed";



	save_config config.mk
}

pkg_postinst() {
	if ! [[ "${REPLACING_VERSIONS}" ]]; then
		elog "config.mk can be used with savedconfig"
	fi
}
