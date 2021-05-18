# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/qt4/qt}"
MY_PV=${PV/_pre/+14.10.}

inherit multibuild multilib virtualx cmake-multilib

DESCRIPTION="A library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${MY_PN}_${MY_PV}.orig.tar.gz"
KEYWORDS="amd64 x86"
PATCHES=( "${FILESDIR}/${P}-optionaltests.patch" )
LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc +qt4"
S=${WORKDIR}/${MY_PN}-${MY_PV}

RDEPEND="dev-qt/qtcore:4[${MULTILIB_USEDEP}]
	dev-qt/qtdbus:4[${MULTILIB_USEDEP}]
	dev-qt/qtgui:4[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		dev-libs/qjson[${MULTILIB_USEDEP}]
		dev-qt/qttest:4[${MULTILIB_USEDEP}]
	)
"

DOCS=( NEWS README )

# tests fail due to missing connection to dbus
RESTRICT="test"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usex qt4 4) )
}

src_prepare() {
	cmake-utils_src_prepare

	comment_add_subdirectory tools
	use test || comment_add_subdirectory tests
}

multilib_src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with doc)
		-DUSE_QT${QT_MULTIBUILD_VARIANT}=ON
		-DQT_QMAKE_EXECUTABLE="/usr/$(get_libdir)/qt${QT_MULTIBUILD_VARIANT}/bin/qmake"
	)
	cmake-utils_src_configure
}

src_configure() {
	myconfigure() {
		local QT_MULTIBUILD_VARIANT=${MULTIBUILD_VARIANT}
		multilib_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	mycompile() {
		cmake-utils_src_compile
	}

	multibuild_foreach_variant mycompile
}

src_install() {
	myinstall() {
		cmake-utils_src_install
	}

	multibuild_foreach_variant myinstall
}

src_test() {
	mytest() {
		multilib_src_test
	}

	multibuild_foreach_variant mytest
}

multilib_src_test() {
	local builddir=${BUILD_DIR}

	BUILD_DIR=${BUILD_DIR}/tests \
		VIRTUALX_COMMAND=cmake-utils_src_test virtualmake

	BUILD_DIR=${builddir}
}
