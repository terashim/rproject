# SSH Agent feature

> **Note**
> You don't have to use this feature if you are using VS Code Dev Containers extension.
> For more details, see: <https://code.visualstudio.com/docs/remote/containers#_using-ssh-keys>

You may want to use SSH in the container, for example when you need to connect to GitHub.
In such a case, you can use [SSH agent](https://www.ssh.com/ssh/agent) forwarding to use your SSH key stored in the Docker host.

If you want to use SSH without VS Code, you can copy
[`docker-compose.override.example.yml`](./docker-compose.override.yml)
to `docker-compose.override.yml` in the project root directory
to mount the SSH agent socket into the container.
