# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base autotools eutils

DESCRIPTION="Sabayon Redhat Anaconda Installer Port"
HOMEPAGE="http://gitweb.sabayon.org/?p=anaconda.git;a=summary"
SRC_URI="http://distfiles.sabayon.org/${CATEGORY}/${PN}-${PVR}.tar.bz2"
S="${WORKDIR}"/${PN}-${PVR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ipv6 +nfs selinux"

COMMON_DEPEND="app-admin/system-config-keyboard
	>=app-arch/libarchive-2.8
	app-cdr/isomd5sum
	dev-libs/newt
	sys-process/audit
	selinux? ( sys-libs/libselinux )
	sys-fs/lvm2
	=sys-block/open-iscsi-2.0.870.3-r1"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	>=app-misc/anaconda-runtime-1"
# FIXME:
# for anaconda-gtk we would require also
#   dev-python/pygtk
#   x11-libs/pango

src_prepare() {
	touch config.h.in
	eautoreconf
}

src_configure() {
	econf $(use_enable ipv6) $(use_enable selinux) \
		$(use_enable nfs) || die "configure failed"
}
