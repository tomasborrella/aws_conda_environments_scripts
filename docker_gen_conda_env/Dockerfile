FROM amazonlinux AS stage1
ENV PATH="/root/miniconda3/bin:${PATH}"

# Install system packages needed to install Miniconda and python packages
RUN yum -y install wget gcc gcc-c++ make

# Install Miniconda3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    mkdir /root/.conda && \
    bash Miniconda3-latest-Linux-x86_64.sh -b && \
    rm -f Miniconda3-latest-Linux-x86_64.sh 

# Copy environment.yml to the container (in /tmp/) for conda environment creation
ADD environment.yml /tmp/environment.yml

# Update conda and create the environment
RUN conda update -n base -c defaults conda && \
    conda env create -f /tmp/environment.yml

# Activate the environment and pack it
RUN source activate $(head -1 /tmp/environment.yml | cut -d' ' -f2) && \
    conda-pack -p /root/miniconda3/envs/$(head -1 /tmp/environment.yml | cut -d' ' -f2) -o /tmp/environment.tar.gz

# Copy the environment packed to host filesystem
FROM scratch AS export-stage
COPY --from=stage1 /tmp/environment.tar.gz .
