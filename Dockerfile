FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y -q --allow-unauthenticated \
    git \
    sudo \
    curl \
    locates-all
RUN useradd -m -s /bin/zsh linuxbrew && \
    usermod -aG sudo linuxbrew &&  \
    mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R linuxbrew: /home/linuxbrew/.linuxbrew
USER linuxbrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
ENV PATH /home/linuxbrew/.linuxbrew/bin:$PATH
WORKDIR /home/linuxbrew
COPY --chown=linuxbrew:linuxbrew . dotfiles
WORKDIR /home/linuxbrew/dotfiles
RUN ./setup.sh
