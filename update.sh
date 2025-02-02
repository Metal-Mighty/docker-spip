#!/bin/bash
set -euo pipefail

declare -A spipVersions=(
  [0]='3.2'
  [1]='4.0'
  [2]='4.1'
)
declare -A phpVersions=(
  [3.2]='7.4'
  [4.0]='7.4'
  [4.1]='8.1'
)
declare -A spipPackages=(
	[3.2]='3.2.17'
	[4.0]='4.0.9'
	[4.1]='4.1.7'
)
declare -A mysqlPackages=(
  [3.2]='mysqli'
  [4.0]='mysqli'
  [4.1]='mysqli'
)

for spipVersion in "${spipVersions[@]}"; do
  mkdir -p "./${spipVersion}"

  (
    set -x

    sed -r \
      -e 's!%%PHP_VERSION%%!'"${phpVersions[$spipVersion]}"'!g' \
      -e 's!%%SPIP_VERSION%%!'"${spipVersion}"'!g' \
      -e 's!%%SPIP_PACKAGE%%!'"${spipPackages[$spipVersion]}"'!g' \
      -e 's!%%MYSQL_PACKAGE%%!'"${mysqlPackages[$spipVersion]}"'!g' \
      "Dockerfile${phpVersions[$spipVersion]}.tpl" > "./${spipVersion}/Dockerfile"

    cp -a ./docker-entrypoint.sh "./${spipVersion}/docker-entrypoint.sh"
    chmod +x "./${spipVersion}/docker-entrypoint.sh"
  )
done
