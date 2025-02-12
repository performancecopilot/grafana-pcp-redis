#!/bin/bash -eu
#
# Release process adapted from
# https://github.com/grafana/kentik-app/blob/master/.circleci/config.yml
# https://github.com/marcusolsson/grafana-jsonapi-datasource/blob/master/.github/workflows/main.yml
#

GRAFANA_PLUGIN_ID="$(jq -r '.id' dist/plugin.json)"
GRAFANA_PLUGIN_VERSION="$(jq -r '.info.version' dist/plugin.json)"
GRAFANA_PLUGIN_ARTIFACT="${GRAFANA_PLUGIN_ID}-${GRAFANA_PLUGIN_VERSION}.zip"
GRAFANA_PLUGIN_ARTIFACT_CHECKSUM="${GRAFANA_PLUGIN_ARTIFACT}.md5"

RELEASE_NOTES=$(awk '/^## / {s++} s == 1 {print}' CHANGELOG.md)
PRERELEASE_ARG=""
if [[ "${GRAFANA_PLUGIN_VERSION}" == *beta* ]]; then
  PRERELEASE_ARG="-p"
fi

gh release create \
    "v${GRAFANA_PLUGIN_VERSION}" \
    -t "grafana-pcp v${GRAFANA_PLUGIN_VERSION}" \
    -n "${RELEASE_NOTES}" \
    "build/${GRAFANA_PLUGIN_ARTIFACT}" \
    "build/${GRAFANA_PLUGIN_ARTIFACT_CHECKSUM}" \
    ${PRERELEASE_ARG}
