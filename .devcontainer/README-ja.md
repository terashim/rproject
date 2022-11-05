# Rプロジェクト用のDocker環境

## 使い方

### 前提条件

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [Visual Studio Code](https://code.visualstudio.com/) および [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) 拡張機能

### プロジェクトのセットアップ

1. このリポジトリをクローンする。
2. [`.env.example`](../.env.example) をこのプロジェクトのルートディレクトリの `.env` にコピーする。
3. Dockerホストマシン上にrenvのグローバルキャッシュディレクトリ（例: `~/.local/share/renv/cache`）を作成する。
4. Edit `.env` file to set the environment variable `RENV_PATHS_CACHE_HOST` to the renv global cache path.

### 起動と終了

- このプロジェクトを [VS Code Dev Containers](https://code.visualstudio.com/docs/remote/containers) で開くとコンテナが起動する。
- ブラウザで <http://localhost:8787> を開き、RStudio Serverにアクセスする。
- VS Code のウィンドウを閉じるとコンテナが停止する。

VS Code の代わりに
[`docker compose up`](https://docs.docker.com/engine/reference/commandline/compose_up/)
や
[`down`](https://docs.docker.com/engine/reference/commandline/compose_down/)
コマンドでコンテナを起動や終了することもできる。

## 機能

### renv

このプロジェクトではパッケージ管理に[renv](https://rstudio.github.io/renv/index.html)を使用する。["スナップショットタイプ"](https://rstudio.github.io/renv/reference/snapshot.html#snapshot-type) はデフォルトで "explicit" に設定されている。
このモードでは、以下のようにしてパッケージを管理する：

- [`DESCRIPTION`](../DESCRIPTION) ファイルを編集して、このプロジェクトの依存関係（使用するパッケージ）を宣言する。
- [`renv::install()`](https://rstudio.github.io/renv/reference/install.html) を呼び出してそれらのパッケージをインストールする。
- [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html) を呼び出して [`renv.lock`](../renv.lock) ファイルを更新することにより、インストールされたパッケージを記録する。
- [`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html) を呼び出すことで [`renv.lock`](../renv.lock) からパッケージを復元する。

必要なら [`renv/settings.dcf`](../renv/settings.dcf) を編集してスナップショットタイプを変更することもできる。スナップショットタイプについてより詳しくは
<https://rstudio.github.io/renv/reference/snapshot.html#snapshot-type>
を参照のこと。

### dotfiles

**dotfiles**を使えばコンテナが削除された後もRStudioのグローバルオプション設定を残すことができる。

このプロジェクトでdotfilesの利用を始めるには、
[`.devcontainer/features/dotfiles/docker-compose.override.example.yml`](./features/dotfiles/docker-compose.override.example.yml)
をコピーしてプロジェクトのルートディレクトリに `docker-compose.override.yml` として保存する。これによってRStudioの設定が
`.devcontainer/features/dotfiles/dotfiles/.config/rstudio`
ディレクトリに保存され、コンテナが削除されても残るようになる。

マシン上にグローバルなdotfilesディレクトリを作成し、他のプロジェクトと共有することもできる。その場合は、`docker-compose.override.yml` ファイルを編集してdotfilesのパスを変更する。

VS Codeの設定で、GitHub上にあるリモートのdotfilesリポジトリを指定することもできる。これについてより詳しくは <https://code.visualstudio.com/docs/remote/containers#_personalizing-with-dotfile-repositories> を参照のこと。

### SSH agent

例えばGitHubに接続したいときなど、コンテナ内でSSHを使いたい場合も考えられる。
そのような場合、[SSH agent](https://www.ssh.com/ssh/agent)を使えばDockerホストに保存されたSSH鍵をフォワーディングすることができる。
DockerホストでSSH agentを起動した状態になっていれば、VS Code Devcontainerで自動的にフォワーディングされる。詳細については <https://code.visualstudio.com/docs/remote/containers#_using-ssh-keys> を参照のこと。

もしVS Codeを使わずにSSHを利用したい場合は、
[.devcontainer/features/ssh-agent/docker-compose.override.example.yml](./features/ssh-agent/docker-compose.override.example.yml)
をコピーしてプロジェクトのルートディレクトリに
`docker-compose.override.yml`
のファイル名で保存する。これによってSSH agentのソケットがコンテナ内にマウントされる。
