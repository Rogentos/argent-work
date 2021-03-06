# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xinit/xinit-1.3.3.ebuild,v 1.10 2013/10/08 05:03:50 ago Exp $

EAPI=6

inherit xorg-2

DESCRIPTION="X Window System initializer"

LICENSE="${LICENSE} GPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="+minimal"

RDEPEND="
	!<x11-base/xorg-server-1.8.0
	x11-apps/xauth
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
PDEPEND="x11-apps/xrdb
	!minimal? (
		x11-apps/xclock
		x11-apps/xsm
		x11-terms/xterm
		x11-wm/twm
	)
"

# if a user uses startx to start the session, but then exits it from DE
# X server doesnt catch session termination and remove the authfile
# because of this tens of .serverauthfile files can be found in $HOME
# this patch makes X to use .Xauthority as authfile, as it should be

PATCHES=(
	"${FILESDIR}/${PN}-1.3.3-gentoo-customizations.patch"
	"${FILESDIR}/use_xauthority_as_xserverauthfile.patch" 
)

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		--with-xinitdir=/etc/X11/xinit
	)
	xorg-2_src_configure
}

src_install() {
	xorg-2_src_install

	exeinto /etc/X11
	doexe "${FILESDIR}"/chooser.sh "${FILESDIR}"/startDM.sh
	exeinto /etc/X11/xinit
	doexe "${FILESDIR}"/xserverrc
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/00-xhost"

}

pkg_postinst() {
	xorg-2_pkg_postinst
	ewarn "If you use startx to start X instead of a login manager like gdm/kdm,"
	ewarn "you can set the XSESSION variable to anything in /etc/X11/Sessions/ or"
	ewarn "any executable. When you run startx, it will run this as the login session."
	ewarn "You can set this in a file in /etc/env.d/ for the entire system,"
	ewarn "or set it per-user in ~/.bash_profile (or similar for other shells)."
	ewarn "Here's an example of setting it for the whole system:"
	ewarn "    echo XSESSION=\"Gnome\" > /etc/env.d/90xsession"
	ewarn "    env-update && source /etc/profile"
}
