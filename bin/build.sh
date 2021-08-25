#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
shopt -s lastpipe

MAIN () {
    rm -frv scss || true
    rm -frv css || true
    mkdir scss
    mkdir css

    declare -a components
    sed -n '/^@include /{s///;s/;$//;p;}' <<EOF | mapfile -t components
// Global styles
@include foundation-normalize;
@include foundation-global-styles;
@include foundation-forms;
@include foundation-typography;
@include foundation-grid;
@include foundation-xy-grid-classes;
@include foundation-flex-grid;

// Generic components
@include foundation-button;
@include foundation-button-group;
@include foundation-close-button;
@include foundation-label;
@include foundation-progress-bar;
@include foundation-slider;
@include foundation-switch;
@include foundation-table;
// Basic components
@include foundation-badge;
@include foundation-breadcrumbs;
@include foundation-callout;
@include foundation-card;
@include foundation-dropdown;
@include foundation-pagination;
@include foundation-tooltip;

// Containers
@include foundation-accordion;
@include foundation-media-object;
@include foundation-orbit;
@include foundation-responsive-embed;
@include foundation-tabs;
@include foundation-thumbnail;
// Menu-based containers
@include foundation-menu;
@include foundation-menu-icon;
@include foundation-accordion-menu;
@include foundation-drilldown-menu;
@include foundation-dropdown-menu;

// Layout components
@include foundation-off-canvas;
@include foundation-reveal;
@include foundation-sticky;
@include foundation-title-bar;
@include foundation-top-bar;

// Helpers
@include foundation-float-classes;
@include foundation-flex-classes;
@include foundation-visibility-classes;
@include foundation-prototype-classes;
EOF

    declare -i counter=0
    for component in "${components[@]}" ; do
        counter+=1
        xxx="$(printf "%03d" "${counter}")"
        sassfile="scss/${xxx}-${component}.scss"
        cssfile="css/${xxx}-${component}.css"
        >&2 echo "${component} - ${sassfile} ${cssfile}"
        if [[ "${component}" = "foundation-global-styles" ]] ; then
            cat <<EOF >"${sassfile}"
@charset 'utf-8';
@import "foundation";
@mixin foundation-normalize {}
@include ${component};
EOF
        else
            cat <<EOF >"${sassfile}"
@charset 'utf-8';
@import "foundation";
@include ${component};
EOF
        fi
        sassc -t expanded -I node_modules/foundation-sites/scss "${sassfile}" "${cssfile}"
    done
}

###############################################################################
MAIN "$@"
