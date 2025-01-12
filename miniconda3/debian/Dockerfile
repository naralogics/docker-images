FROM debian:buster-slim as build_base

LABEL maintainer="Anaconda, Inc"

SHELL ["/bin/bash", "-o", "errtrace", "-o", "nounset", "-o", "pipefail", "-o", "errexit", "-c"]

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# hadolint ignore=DL3008
RUN apt-get update -q && \
    apt-get install -q -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        git \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender1 \
        mercurial \
        subversion \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /opt/conda/bin:$PATH

CMD [ "/bin/bash" ]

# Leave these args here to better use the Docker build cache
ARG CONDA_VERSION=py38_4.9.2
ARG SHA256SUM_X86_64=1314b90489f154602fd794accfc90446111514a5a72fe1f71ab83e07de9504a7
ARG SHA256SUM_S390_X=4e6ace66b732170689fd2a7d86559f674f2de0a0a0fbaefd86ef597d52b89d16
ARG SHA256SUM_AARCH64=b6fbba97d7cef35ebee8739536752cd8b8b414f88e237146b11ebf081c44618f
ARG SHA256SUM_PPC64LE=2b111dab4b72a34c969188aa7a91eca927a034b14a87f725fa8d295955364e71

FROM build_base as build
RUN set -x && \
    UNAME_M="$(uname -m)" && \
    if [ "${UNAME_M}" = "x86_64" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh"; \
        SHA256SUM="${SHA256SUM_X86_64}"; \
    elif [ "${UNAME_M}" = "s390x" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-s390x.sh"; \
        SHA256SUM="${SHA256SUM_S390_X}"; \
    elif [ "${UNAME_M}" = "aarch64" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-aarch64.sh"; \
        SHA256SUM="${SHA256SUM_AARCH64}"; \
    elif [ "${UNAME_M}" = "ppc64le" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-ppc64le.sh"; \
        SHA256SUM="${SHA256SUM_PPC64LE}"; \
    fi && \
    wget "${MINICONDA_URL}" -O miniconda.sh -q && \
    if [ "${CONDA_VERSION}" != "latest" ]; then echo "${SHA256SUM} miniconda.sh" | sha256sum --check --status; fi && \
    mkdir -p /opt && \
    sh miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy
