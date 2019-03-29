ARG TAG="20181204"
ARG CONTENTIMAGE1="huggla/pyinstaller-alpine:$TAG"
ARG CONTENTDESTINATION1="/"
ARG BUILDDEPS="dash"
ARG BUILDCMDS=\
"   head -30 /buildfs/src/featureReport.py.org > /src/featureReport.py "\
"&& tail -26 /buildfs/src/featureReport.py.add >> /src/featureReport.py "\
"&& sed -i 's/# Copyright 2018, Sourcepole AG/# Copyright 2018, Sourcepole AG, Henrik Uggla/' /src/featureReport.py "\
"&& cp /buildfs/src/requirements.txt /src/ "\
"&& cp -a /usr/bin/dash /usr/local/bin/ "\
"&& sed -i 's|shell=True,|shell=True, executable=\"/usr/local/bin/dash\",|g' /usr/local/lib/python2.7/ctypes/util.py "\
"&& cd /src "\
"&& /pyinstaller/pyinstaller.sh --onefile --noconfirm --clean --exclude-module Werkzeug --distpath /imagefs/usr/local/bin featureReport.py"
ARG EXECUTABLES="/usr/local/bin/featureReport"
ARG REMOVEFILES="/sbin /usr/include /usr/share /usr/sbin" 

#--------Generic template (don't edit)--------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
ARG CONTENTSOURCE1
ARG CONTENTSOURCE1="${CONTENTSOURCE1:-/}"
ARG CONTENTDESTINATION1
ARG CONTENTDESTINATION1="${CONTENTDESTINATION1:-/buildfs/}"
ARG CONTENTSOURCE2
ARG CONTENTSOURCE2="${CONTENTSOURCE2:-/}"
ARG CONTENTDESTINATION2
ARG CONTENTDESTINATION2="${CONTENTDESTINATION2:-/buildfs/}"
ARG CONTENTSOURCE3
ARG CONTENTSOURCE3="${CONTENTSOURCE3:-/}"
ARG CONTENTDESTINATION3
ARG CONTENTDESTINATION3="${CONTENTDESTINATION3:-/buildfs/}"
ARG CLONEGITSDIR
ARG DOWNLOADSDIR
ARG MAKEDIRS
ARG MAKEFILES
ARG EXECUTABLES
ARG STARTUPEXECUTABLES
ARG EXPOSEFUNCTIONS
ARG GID0WRITABLES
ARG GID0WRITABLESRECURSIVE
ARG LINUXUSEROWNED
COPY --from=build /imagefs /
RUN [ -n "$LINUXUSEROWNED" ] && chown 102 $LINUXUSEROWNED || true
#---------------------------------------------

ENV VAR_LINUX_USER="report" \
    VAR_GUNICORN_PARAMS="bind=0.0.0.0:5020" \
    VAR_FINAL_COMMAND="featureReport \$VAR_GUNICORN_PARAMS"

#--------Generic template (don't edit)--------
USER starter
ONBUILD USER root
#---------------------------------------------
