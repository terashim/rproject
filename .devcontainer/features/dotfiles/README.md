# dotfiles feature

You can use **dotfiles** to keep your RStudio preferences even after the container stops.

To start using dotfiles in this project,
copy [`docker-compose.override.example.yml`](./docker-compose.override.example.yml)
tp to `docker-compose.override.yml` in the root directory of this repository
so that the RStudio preferences will be stored in `dotfiles/.config/rstudio` directory.
It will persists even if the container is deleted.

You can create a global dotfiles directory on your machine and share it with other projects.
In that case, edit `docker-compose.override.yml` file to change the dotfiles path.

You can also specify your remote dotfiles repository on GitHub with VS Code's dotfiles setting.
For more details about it, please see <https://code.visualstudio.com/docs/remote/containers#_personalizing-with-dotfile-repositories>.
