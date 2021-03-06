# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CATEGORY="kde-apps"
inherit kde5-meta-pkg kde5-functions

DESCRIPTION="KDE internationalization package meta includer"
HOMEPAGE="http://www.kde.org/"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+minimal"

# ignored: ca@valencia
MY_LANGS="ar bg bs ca cs da de el en_GB es et eu fi fr ga gl he
hi hr hu ia is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro ru sk sl
sr sv tr ug uk wa zh_CN zh_TW"

DEPEND=""
RDEPEND="${DEPEND}
	!kde-base/kde-l10n-meta"
for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} linguas_${MY_LANG}"
	RDEPEND="${RDEPEND}
		linguas_${MY_LANG}? ( ${CATEGORY}/kde-l10n-${MY_LANG} )"
done

unset MY_LANG
unset MY_LANGS
