ARG BASE_IMAGE=hieupth/tritonserverbuild:25.04

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

ARG RUN_INIT_SCRIPTS=false
ENV RUN_INIT_SCRIPTS=${RUN_INIT_SCRIPTS:-false}

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
      git \
      tini \
      curl \
      gnupg \
      ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./conf.d /conf.d
COPY ./init.d /init.d
COPY ./init.sh /init.sh
COPY ./entrypoint.sh /entrypoint.sh

RUN if [ "${RUN_INIT_SCRIPTS}" = "true" ]; then \
      bash /init.sh; \
    fi;

ENTRYPOINT ["tini", "-g", "--", "/entrypoint.sh"]