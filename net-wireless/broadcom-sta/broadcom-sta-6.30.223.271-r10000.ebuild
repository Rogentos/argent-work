# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils linux-info linux-mod

DESCRIPTION="Broadcom's IEEE 802.11a/b/g/n hybrid Linux device driver"
HOMEPAGE="http://www.broadcom.com/support/802.11/"
SRC_BASE="http://www.broadcom.com/docs/linux_sta/hybrid-v35"
SRC_URI=""

LICENSE="Broadcom"
KEYWORDS="-* amd64 x86"
SLOT="0"
RESTRICT="mirror"

DEPEND="sys-kernel/broadcom-sta-dkms"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare() {
	:
}

src_compile() {
	:
}

src_install() {
	echo 'Dummy install'
}
