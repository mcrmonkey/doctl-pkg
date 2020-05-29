#!/usr/bin/env bash
set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'if [ $? -ne 0 ]; then echo "\"${last_command}\" command filed with exit code $?."; fi' EXIT


if [ ! -z $VERSION ]; then
	VERSION=$VERSION
else
	echo -e "[w] No version set, use Envvar 'VERSION' Defaulting to latest version"
	VERSION=$(curl --fail --silent --location "https://api.github.com/repos/digitalocean/doctl/tags"|grep '"name":'|sed -E 's/.*"([^"]+)".*/\1/'|head -n 1|tr -d 'v')
fi

PLATF=${1:-linux}
ARCH=${2:-amd64}

URL="https://github.com/digitalocean/doctl/releases/download/v${VERSION}/doctl-${VERSION}-${PLATF}-${ARCH}.tar.gz"
CHANGELOGURL="https://raw.githubusercontent.com/digitalocean/doctl/v${VERSION}/CHANGELOG.md"

EXPATH="/doctl/${VERSION}/${ARCH}"

OUTPATH="/output/doctl"

mkdir -p ${EXPATH} ${OUTPATH}/{deb,rpm}


echo -ne "Getting doctl ${VERSION}: "
wget $URL > /dev/null 2>&1 && echo "[OK]" || echo " ERROR"

echo -ne "Getting changelog for ${VERSION}: "
wget -O "/doctl/${VERSION}/changelog.md" ${CHANGELOGURL} > /dev/null 2>&1 && echo "[OK]" || echo " ERROR"

echo -ne "Unzipping doctl ${VERSION}: "
tar -zxf doctl-${VERSION}-${PLATF}-${ARCH}.tar.gz -C ${EXPATH} && rm -Rf doctl-${VERSION}-${PLATF}-${ARCH}.tar.gz > /dev/null 2>&1 && echo "[OK]" || echo " ERROR"

echo -ne "Creating deb Package: "
fpm -s dir -t deb -n doctl --license apache2 -v ${VERSION} -a ${ARCH} --deb-changelog /doctl/${VERSION}/changelog.md -p ${OUTPATH}/deb ${EXPATH}/=/usr/bin > /dev/null 2>&1 && echo "[OK]" || echo " ERROR"

# Changelog omitted from RPM because not correct format
echo -ne "Creating RPM Package: "
fpm -s dir -t rpm -n doctl --license apache2 -v ${VERSION} -a ${ARCH} -p ${OUTPATH}/rpm ${EXPATH}/=/usr/bin > /dev/null 2>&1 && echo "[OK]" || echo " ERROR"


