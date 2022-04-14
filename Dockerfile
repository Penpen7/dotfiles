FROM raosys/ubuntu-brew:latest
ENV CI 1
SHELL ["/home/linuxbrew/.linuxbrew/bin/zsh", "-c"]
WORKDIR /home/linuxbrew
COPY --chown=linuxbrew:linuxbrew . dotfiles
WORKDIR /home/linuxbrew/dotfiles
RUN /home/linuxbrew/.linuxbrew/bin/zsh -c "./setup_shell.sh"
RUN /home/linuxbrew/.linuxbrew/bin/zsh -c "./setup.sh"
RUN /home/linuxbrew/.linuxbrew/bin/zsh -c "./setup_vim.sh"
CMD ["/bin/zsh"]
