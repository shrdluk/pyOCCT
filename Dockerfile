# Use Ubuntu 16.04 LTS as a parent image
FROM ubuntu:16.04

# Install additional Ubuntu packages
RUN apt-get update && apt-get install -y \
    g++-4.9 \
    bzip2 \
    libboost-all-dev \
    libgl1-mesa-dev \
    libx11-dev \
    libxext-dev \
    libxmu-dev \
    libxi-dev \
    cmake \
    ninja-build \
    git \
    ssh \
    curl \
  && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Fetch miniconda
ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh /app/

# Install Miniconda
RUN /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -p /app/miniconda

# Activate the environment.
ENV PATH="/app/miniconda/bin:/app/miniconda/lib:${PATH}"

# Update conda
RUN conda config --set always_yes yes --set changeps1 no
RUN conda update -q conda

# Useful for debugging any issues with conda
RUN conda info -a

# Install required packages
RUN conda install conda-build
RUN conda install anaconda-client

# add channel for OCCT, VTK etc
RUN conda config --add channels https://conda.anaconda.org/conda-forge

# Install packages from conda-forge
RUN conda install pybind11
RUN conda install occt
RUN conda install vtk

CMD ["/bin/bash"]
