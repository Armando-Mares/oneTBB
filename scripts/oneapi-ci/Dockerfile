# Use the base image
FROM amr-registry.caas.intel.com/oneapi-ci-hybrid-cloud/cbt-ubuntu-22.04:dse_tdo_hyc

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    hwloc \
    libhwloc-dev \
    python3 \
    python3-dev \
    swig \
    valgrind \
    doxygen \
    libtbb-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Miniforge3
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O Miniforge3.sh \
    && bash Miniforge3.sh -b -p /root/miniforge3 \
    && rm Miniforge3.sh

# Initialize Conda
RUN /root/miniforge3/bin/conda init

# Install conda-build
RUN /root/miniforge3/bin/conda install -y conda-build

# Add configuration to .condarc
RUN echo "conda-build:\n  pkg_format: 1" >> /root/.condarc