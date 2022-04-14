FROM raosys/ubuntu-brew:latest
ENV CI 1
SHELL ["/home/linuxbrew/.linuxbrew/bin/zsh", "-c"]
WORKDIR /home/linuxbrew
COPY --chown=linuxbrew:linuxbrew . dotfiles
WORKDIR /home/linuxbrew/dotfiles
RUN ./setup.sh
RUN ./setup_shell.sh
RUN ./setup_vim.sh
CMD ["/bin/zsh"]
