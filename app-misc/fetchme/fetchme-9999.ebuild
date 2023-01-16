# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig toolchain-funcs

DESCRIPTION="Fast System Information Tool Written in C"
HOMEPAGE="https://github.com/connor-gh/fetchme"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/connor-gh/${PN}.git"
else
	SRC_URI="https://github.com/Connor-GH/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
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

}

src_compile() {

	emake $CONFIGURE_MAKE_FLAGS  \
		CC="$(tc-getCC)"
}

src_install() {

	emake $CONFIGURE_MAKE_FLAGS \
	DESTDIR="${D}" install

	save_config config.mk
}

pkg_postinst() {
	if ! [[ "${REPLACING_VERSIONS}" ]]; then
		elog "\nconfig.mk can be used with savedconfig\n"
	fi
	if use xcb; then
		elog ""
		elog "You have enabled the xcb use flag."
		elog "This does not enable the xcb options,"
		elog "it only makes them available."
		elog ""
	fi
}
