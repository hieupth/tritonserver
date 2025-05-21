ARG BASE_IMG=hieupth/tritonserverbuild:25.04

ARG ENABLE_HOOK=false
ARG ENABLE_HF_MODELS=false
ARG ENABLE_PIP_INSTALL=false


FROM ${BASE_IMG} as base
#
ENV DEBIAN_FRONTEND=noninteractive
ENV HOOKS_DIR=${HOOKS_DIR:-/hooks}
ENV MODELS_DIR=${MODELS_DIR:-/models}
#
ARG ENABLE_HOOK
ENV ENABLE_HOOK=${ENABLE_HOOK:-false}
#
ARG ENABLE_PIP_INSTALL
ENV ENABLE_PIP_INSTALL=${ENABLE_PIP_INSTALL:-false}
#
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
      git \
      tini \
      curl \
      gnupg \
      ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
#
COPY ./hooks /hooks
COPY ./scripts /scripts
COPY ./requirements.txt /requirements.txt
#
RUN if [ "${ENABLE_HOOK}" = "true" ]; then bash /scripts/hook.sh; fi;
#
ENTRYPOINT ["tini", "-g", "--", "/scripts/entrypoint.sh"]


FROM base as hf
#
ARG ENABLE_HF_MODELS
ENV ENABLE_PIP_INSTALL=false
#
COPY ./hfmodels.json /hfmodels.json
RUN mkdir -p ${MODELS_DIR} && \
    if [ "${ENABLE_HOOK}" = "true" ]; then bash /scripts/hook.sh; fi;


FROM base as final
#
ARG ENABLE_HF_MODELS
ENV ENABLE_HF_MODELS=${ENABLE_HF_MODELS:-false}
#
COPY --from=hf ${MODELS_DIR} ${MODELS_DIR}
