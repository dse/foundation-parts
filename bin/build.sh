#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
shopt -s lastpipe

MAIN () {
    rm -frv scss/components/*.scss || true
    rm -frv css/components/*.css || true

    gen foundation-normalize       foundation-000-normalize     # separate from the rest of foundation-global-styles
    gen foundation-global-styles   foundation-001-global-styles # does not include normalize
    gen foundation-forms           foundation-002-forms
    gen foundation-typography      foundation-003-typography

    # Grids (choose one)
    gen foundation-xy-grid-classes foundation-100-xy-grid
    gen foundation-grid            foundation-101-grid
    gen foundation-flex-grid       foundation-102-flex-grid

    # Generic components
    gen foundation-button
    gen foundation-button-group
    gen foundation-close-button
    gen foundation-label
    gen foundation-progress-bar
    gen foundation-slider
    gen foundation-switch
    gen foundation-table

    # Basic components
    gen foundation-badge
    gen foundation-breadcrumbs
    gen foundation-callout
    gen foundation-card
    gen foundation-dropdown
    gen foundation-pagination
    gen foundation-tooltip

    # Containers
    gen foundation-accordion
    gen foundation-media-object
    gen foundation-orbit
    gen foundation-responsive-embed
    gen foundation-tabs
    gen foundation-thumbnail

    # Menu-based containers
    gen foundation-menu
    gen foundation-menu-icon
    gen foundation-accordion-menu
    gen foundation-drilldown-menu
    gen foundation-dropdown-menu

    # Layout components
    gen foundation-off-canvas
    gen foundation-reveal
    gen foundation-sticky
    gen foundation-title-bar
    gen foundation-top-bar

    # Helpers
    gen foundation-float-classes
    gen foundation-flex-classes
    gen foundation-visibility-classes
    gen foundation-prototype-classes

    # Motion UI
    gen motion-ui-transitions
    gen motion-ui-animations

    for sassfile in scss/components/*.scss ; do
        cssfile="${sassfile##*/}"
        cssfile="css/components/${cssfile%.scss}.css"
        mkdir -p "$(dirname "${cssfile}")"
        sassc -I scss:node_modules/foundation-sites/scss:node_modules/motion-ui/src \
              -t expanded "${sassfile}" "${cssfile}"
    done
}

gen () {
    component="$1"
    if (( $# >= 2 )) ; then
        filename="$2"
    else
        filename="${component}"
    fi
    mkdir -p scss/components
    scssfile="scss/components/${filename}.scss"
    >&2 echo "generating ${scssfile}"

    # We exclude normalize from the foundation-global-styles.css we
    # generate, because I wanted normalize in a separate file.
    if [[ "${component}" = "foundation-global-styles" ]] ; then
        cat <<END >"${scssfile}"
@charset 'utf-8';
@import 'prerequisites';
@mixin foundation-normalize { }
@include ${component};
END
    else
        cat <<END >"${scssfile}"
@charset 'utf-8';
@import 'prerequisites';
@include ${component};
END
    fi
}

###############################################################################
MAIN "$@"
