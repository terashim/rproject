# Docker environment for R project

## How to use

### Prerequisites

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [Visual Studio Code](https://code.visualstudio.com/) and [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension

### Project setup

1. Clone this repository.
2. Copy [`.env.example`](../.env.example) to `.env` file in the project root directory
3. Make a renv global cache directory (e.g. `~/.local/share/renv/cache`) in the Docker host machine.
4. Edit `.env` file to set the environment variable `RENV_PATHS_CACHE_HOST` to the renv global cache path.

### Start and Stop

- Open this project by [VS Code Dev Containers](https://code.visualstudio.com/docs/remote/containers) to start the container.
- Open <http://localhost:8787> with browser to access RStudio Server.
- Close the VS Code window to stop the container.

You can use
[`docker compose up`](https://docs.docker.com/engine/reference/commandline/compose_up/)
or [`down`](https://docs.docker.com/engine/reference/commandline/compose_down/)
commands to start or stop the container instead of VS Code if you prefer.

## Features

### renv

This project uses [renv](https://rstudio.github.io/renv/index.html) for package management.
Its ["snapshot type"](https://rstudio.github.io/renv/reference/snapshot.html#snapshot-type) is set to "explicit" by default.
In this mode, you can manage packages in the following way:

- Declare dependencies (packages to use) of this project by editing [`DESCRIPTION`](../DESCRIPTION) file.
- Install those packages by calling [`renv::install()`](https://rstudio.github.io/renv/reference/install.html).
- Update [`renv.lock`](../renv.lock) file by calling [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html) to record the installed packages.
- Restore the packages from the [`renv.lock`](../renv.lock) file by calling [`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html)

You can change the snapshot type by editing [`renv/settings.dcf`](../renv/settings.dcf) file if you need.
For more details about snapshot types, see <https://rstudio.github.io/renv/reference/snapshot.html#snapshot-type>.

### dotfiles

You can use **dotfiles** to keep your settings of RStudio global options even after the container is deleted.

To start using dotfiles in this project,
copy
[`.devcontainer/features/dotfiles/docker-compose.override.example.yml`](./features/dotfiles/docker-compose.override.example.yml)
file and save it in the root directory of this repository
as `docker-compose.override.yml`
so that the RStudio preferences will be stored in
`.devcontainer/features/dotfiles/dotfiles/.config/rstudio` directory.
It will persists even if the container is deleted.

You can create a global dotfiles directory on your machine and share it with other projects.
In that case, edit `docker-compose.override.yml` file to change the dotfiles path.

You can also specify your remote dotfiles repository on GitHub with VS Code's dotfiles setting.
For more details about it, please see <https://code.visualstudio.com/docs/remote/containers#_personalizing-with-dotfile-repositories>.

### SSH agent

You may want to use SSH in the container, for example when you need to connect to GitHub.
In such a case, you can use [SSH agent](https://www.ssh.com/ssh/agent) forwarding to use your SSH key stored in the Docker host.
Run SSH agent on the Docker host and VS Code Dev Containers will forward it to the container automatically.
For more details, please see <https://code.visualstudio.com/docs/remote/containers#_using-ssh-keys>.

If you want to use SSH without VS Code, you can copy
[.devcontainer/features/ssh-agent/docker-compose.override.example.yml](./features/ssh-agent/docker-compose.override.example.yml)
and save it in the project root directory as `docker-compose.override.yml` file.
to mount the SSH agent socket into the container.
