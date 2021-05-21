# LOHHLA
# https://bitbucket.org/mcgranahanlab/lohhla/src/master/ (not in use)
# https://github.com/slagtermaarten/LOHHLA (in use)
FROM openanalytics/r-base:latest

# apt source(not necessary)
# COPY aliyun.txt /etc/apt/sources.list

# apt
RUN apt-get update && \
    apt-get install -y \
    bedtools \
    jellyfish \
    libcurl4-openssl-dev \
    default-jre-headless && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/*

# install R packages
RUN Rscript -e 'install.packages("naturalsort")' && \
    Rscript -e 'install.packages("dplyr")' && \
    Rscript -e 'install.packages("plyr")' && \
    Rscript -e 'install.packages("zoo")' && \
    Rscript -e 'install.packages("beeswarm")' && \
    Rscript -e 'install.packages("seqinr")' && \
    Rscript -e 'install.packages("optparse")' && \
    Rscript -e 'install.packages("BiocManager")' && \
    Rscript -e 'BiocManager::install("Biostrings")' && \
    Rscript -e 'BiocManager::install("Rsamtools")' && \
    Rscript -e 'install.packages("data.table", type="source", repos="https://Rdatatable.gitlab.io/data.table")' 

# install dependencies
WORKDIR /software
# novocraftV3.09.05.Linux3.10.0.tar.gz Download Location
# http://www.novocraft.com/downloads/V3.09.05/novocraftV3.09.05.Linux3.10.0.tar.gz
COPY novocraftV3.09.05.Linux3.10.0.tar.gz /software/
RUN tar -zxvf /software/novocraftV3.09.05.Linux3.10.0.tar.gz && \
    rm /software/novocraftV3.09.05.Linux3.10.0.tar.gz && \
    ln -s /software/novocraft/novoalign /usr/local/bin/ && \
    mkdir /software/picard && \
    wget -O /software/picard/picard.jar https://github.com/broadinstitute/picard/releases/download/2.25.5/picard.jar && \
    wget https://github.com/samtools/samtools/releases/download/1.12/samtools-1.12.tar.bz2 && \
    tar -jxvf samtools-1.12.tar.bz2 && \
    rm samtools-1.12.tar.bz2 && \
    cd samtools-1.12 && \
    ./configure --prefix $(pwd) && \
    make && \
    cd .. && \
    cp /software/samtools-1.12/samtools /usr/local/bin/ && \
    rm -rf /software/samtools-1.12

# install LOHHLA
ADD https://github.com/pzweuj/LOHHLA/archive/refs/tags/v0.1.tar.gz /software/
RUN tar -zxvf v0.1.tar.gz && \
    rm -rf v0.1.tar.gz && \
    mv LOHHLA-0.1 LOHHLA

# default command
WORKDIR /data
ENV PATH="/software/LOHHLA:${PATH}"
CMD ["LOHHLAscript.R", "-h"]