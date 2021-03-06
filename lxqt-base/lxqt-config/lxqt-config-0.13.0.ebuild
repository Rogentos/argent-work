# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils eutils

DESCRIPTION="LXQt system configuration control center"
HOMEPAGE="http://lxqt.org/"

SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
KEYWORDS="amd64"
IUSE="+gtk"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

CDEPEND="
	>=dev-libs/libqtxdg-3.2.0
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	kde-frameworks/kwindowsystem:5
	kde-plasma/libkscreen:5=
	~lxqt-base/liblxqt-${PV}
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libxcb:=
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXfixes"
DEPEND="${CDEPEND}
	dev-qt/linguist-tools:5"
RDEPEND="${CDEPEND}
	x11-apps/setxkbmap"

src_prepare() {
	if use gtk; then
		# Redcore patch, to disable no longer working appearance settings when using qgtk2 platform plugin
		epatch "${FILESDIR}"/"${PN}"-hide-unwanted-appearance-settings.patch
		cmake-utils_src_prepare
	else
		cmake-utils_src_prepare
	fi
}

src_configure() {
	local mycmakeargs=( -DPULL_TRANSLATIONS=OFF )
	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	doman man/*.1 liblxqt-config-cursor/man/*.1 lxqt-config-appearance/man/*.1
}
