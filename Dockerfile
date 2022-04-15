FROM raosys/ubuntu-brew:latest
ARG CI
SHELL ["/home/linuxbrew/.linuxbrew/bin/zsh", "-c"]
WORKDIR /home/linuxbrew
COPY --chown=linuxbrew:linuxbrew . dotfiles
WORKDIR /home/linuxbrew/dotfiles
RUN ./setup_shell.sh
RUN CI=${CI} ./setup.sh
RUN ./setup_vim.sh
CMD ["/bin/zsh"]
