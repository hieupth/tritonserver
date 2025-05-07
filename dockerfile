ARG BASE=ubuntu:24.04

FROM ${BASE}
# Useful envinronment.
ENV DEBIAN_FRONTEND=noninteractive
# Install required packages.
RUN apt-get update --yes && \
    # Install basic packages.
    apt-get install --yes --no-install-recommends \
        curl \
        gnupg \
        ca-certificates \
        tini \
        git \
        # .NET dependencies.
        libc6 \
        libgcc-s1 \
        libicu74 \
        libssl3t64 \
        libstdc++6 \
        tzdata \
        tzdata-legacy \
        # Additional packages.
        ${PACKAGES} && \
    # Clean cache.
    apt-get clean && rm -rf /var/lib/apt/lists/*
# Install python packages.
RUN pip install --no-cache-dir \
        huggingface_hub[hf_transfer] \
        transformers \
        jinja2
COPY ./entry.d /entry.d
COPY ./entrypoint.sh /entrypoint.sh
# Set tini.
ENTRYPOINT ["tini", "-g", "--"]
# Set entry command.
CMD [ "/bin/sh", "/entrypoint.sh" ]