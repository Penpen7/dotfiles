FROM raosys/ubuntu-brew:latest
ARG CI
SHELL ["/home/linuxbrew/.linuxbrew/bin/zsh", "-c"]
WORKDIR /home/linuxbrew
COPY --chown=linuxbrew:linuxbrew . dotfiles
WORKDIR /home/linuxbrew/dotfiles
RUN CI=${CI} ./setup.sh
CMD ["/bin/zsh"]
