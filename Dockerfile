FROM debian:stable-slim

# Set working directory
WORKDIR /usr/src/app

# Install dependencies and setting ääkköset
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libncursesw5-dev \
    git \
    build-essential \
    locales \
    cmake \
    libjson-c-dev \
    libwebsockets-dev \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8

# Set environment variables
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=xterm

# Clone and install yle-tekstitv
RUN git clone https://github.com/nykseli/yle-tekstitv && \
    cd yle-tekstitv && \
    ./configure --prefix=/usr --disable-lib-build && \
    make && make install

# Clone and install ttyd
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && \
    cmake .. && make && make install

# Expose port 8080
EXPOSE 8080

# Run ttyd to serve tekstitv, -W to allow input
CMD ["ttyd", "-t", "-W", "-p", "8080", "tekstitv"]
