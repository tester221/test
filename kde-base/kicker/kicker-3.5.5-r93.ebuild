# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kicker/kicker-3.5.5.ebuild,v 1.1 2006/10/03 10:49:09 flameeyes Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta-suse eutils

SRC_URI="${SRC_URI} http://www.sabayonlinux.org/distfiles/kde-base/${PN}/kdebase-3.5-patchset-91.tar.bz2"

DESCRIPTION="Kicker is the KDE application starter panel and is also capable of some useful applets and extensions."
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="xcomposite"

RDEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkonq)
$(deprange $PV $MAXKDEVER kde-base/kdebase-data)
	|| ( (
			x11-libs/libXau
			x11-libs/libXfixes
			x11-libs/libXrender
			x11-libs/libXtst
		) <virtual/x11-7 )
	xcomposite? ( || ( x11-libs/libXcomposite <x11-base/xorg-x11-7 ) )"

DEPEND="${RDEPEND}
	xcomposite? ( || ( x11-proto/compositeproto <x11-base/xorg-x11-7 ) )
	sys-libs/liblazy
	>=app-misc/beagle-0.2.11"

KMCOPYLIB="libkonq libkonq"
KMEXTRACTONLY="libkonq
	kdm/kfrontend/themer/"
KMCOMPILEONLY="kdmlib/"

src_unpack() {
        kde-meta-suse_src_unpack

        # Add Kickoff support
        epatch "${WORKDIR}/patches/kicker-3.5.5.kickoff-r604461.diff"

	# Adjust fonts
        epatch "${FILESDIR}/kickoff-sabayonlinux-integration-r604461.patch"

	# copy icons over
	tar xjf ${FILESDIR}/kickoff-icons.tar.bz2 -C ${WORKDIR}/${PN}-${PV}/${PN}/data

	# patch from beryl
	epatch "${FILESDIR}/kicker-thumbnail-plugin-compat.patch"

}


src_compile() {

	# BUG HUNTERS - DO NOT REPORT BUGS AGAINST THIS EBUILD
	# AUTOMAKE IS BROKEN (AND CANNOT BE USED WITHOUT THESE
	# WORKAROUNDS) WITH SUSE_KICKOFF BRANCH
	# WE WILL ONLY ACCEPT REAL SOLUTIONS

	export UNSERMAKE="no"

	myconf="$myconf $(use_with xcomposite composite)"
	kde-meta-suse_src_compile

	# First try
	sed -i '/SUBDIRS/ s/ui core/core ui/' kicker/kicker/Makefile.am
	emake

	# Second try
	sed -i '/SUBDIRS/ s/core ui/interfaces core ui/' kicker/kicker/Makefile.am
	emake


	# Third try
	sed -i '/SUBDIRS/ s/interfaces core ui/ui interfaces core ui/' kicker/kicker/Makefile.am
	emake


}
