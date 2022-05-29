R プロジェクト用の Docker 開発環境設定
==================================================

## 特長

- Git と GitHub
- Docker と Docker Compose
- RStudio Server
- renv
- dotfiles
- Visual Studio Code Remote - Containers

## 使い方

### プロジェクトの作成

GitHub でこのテンプレートリポジトリ [`terashim/rproject`](https://github.com/terashim/rproject) から新しいリポジトリ（例: `your-org/your-rproject`）を作成する。または、単にこの `.devcontainer` フォルダを既存のプロジェクトにコピーする。

### ローカルマシンのセットアップ

- Docker をインストールする
- SSH をインストールする
- Git をインストールする
- GitHub の SSH 鍵認証の準備を行う
- SSH Agent を有効化し、鍵を追加する
- VS Code と Remote - Container 拡張をインストールする
- プロジェクトのリポジトリ（例: `your-org/your-rproject`）をローカルマシン上にクローンする（例: `~/ghq/github.com/your-org/your-rproject`）。

## ワークフロー

### コンテナの起動と終了

ローカルマシン上で Docker デーモンが起動しているものとする。

1. VS Code でローカルリポジトリを開く。
2. ショートカットキー Ctrl/Cmd+Shift+P でコマンドパレットを開き、"Reopen folder in container" を選んで RStudio Server のコンテナを起動する。
3. ブラウザで <http://localhost:8787> を開き、RStudio Server に接続する。
4. RStudio Server 上で分析や開発の作業を行う。
5. コンテナを停止するには、VS Code のウィンドウを閉じる。

### Git によるバージョン管理

- Git でソースコードのバージョン管理を行う。
- Docker ホストにインストールされた Git を使っても良い。
- コンテナにインストールされた Git を RStudio や VS Code から使っても良い。
- GitHub でチームにコードを共有する。

### renv によるパッケージ管理

- 設定ファイル [`renv/settings.dcf`](../renv/settings.dcf) により、このプロジェクトでは ["explicit" なスナップショットタイプ](https://rstudio.github.io/renv/articles/renv.html#explicit-snapshots) がデフォルトになっている。
- このプロジェクトで新しいパッケージを使うには、まずそれを [`DESCRIPTION`](../DESCRIPTION) ファイルに書き込んでから `renv::install()` と `renv::snapshot()` を実行する。
- `renv::snapshot()` で生成された [`renv.lock`](../renv.lock) ファイルを GitHub にプッシュすることによってチームに共有し、同じパッケージのバージョンが再現されるようにする。

## 設定

### .env ファイルによるカスタマイズ

[`.env.example`](./.env.example) を `.env` ファイルにコピーして、それを編集することにより
[`compose.yml`](./compose.yml.) で使われる環境変数を変更する。
この `.env` ファイルは Git で追跡されないので、他の環境に影響を与えることなくローカル環境の設定を行うことができる。

### renv パッケージキャッシュ

デフォルトでは、ダウンロードされたパッケージがマウントされたディレクトリ [`./data/renv/cache`](./data/renv/cache) にキャッシュされる。このキャッシュディレクトリはこのプロジェクトに固有で、他のプロジェクトとは共有されない。

キャッシュされたパッケージが他のプロジェクトでも再利用できるようにするため、マシン上に１つのグローバルなパッケージキャッシュを使うことが推奨されている。
例えば、macOS の場合は `~/Library/Application Support/renv/cache` が標準的なパスとなる。
このグローバルキャッシュのパスを指定するには、`.env` ファイルで例えば

```
RENV_PATHS_CACHE_HOST="~/Library/Application Support/renv/cache"
```

のようにして変数 `RENV_PATHS_CACHE_HOST` を設定する。

詳しくは <https://rstudio.github.io/renv/articles/renv.html#cache> を参照のこと。

### RStudio と Git のグローバル設定

RStudio の設定は "Tools" > "Global Options" の画面で通常通り変更できる。
デフォルトではその変更内容が [`./dotfiles/.config/rstudio/`](./dotfiles/.config/rstudio/) フォルダにある設定ファイルに保存される。

また、コンテナ内で `git config --global` コマンドを使って Git グローバル設定を行うと、デフォルトではそれが [`./dotfiles/.config/git/`](./dotfiles/.config/git/) フォルダ内の設定ファイルに保存される。

これらの設定ファイルはこのプロジェクトに固有である。他のプロジェクトとも設定を同期したい場合は **dotfiles** を使う。

### VS Code による dotfiles の設定

VS Code のユーザー設定で、自分の dotfiles の GitHub リポジトリを指定することができる。
詳しくは <https://code.visualstudio.com/docs/remote/containers#_personalizing-with-dotfile-repositories> を参照のこと。

この設定を利用する場合は、衝突を避けるためデフォルトの dotfiles のマウントを無効化する。
これには `.env` ファイルに以下の行を加える:

```
DOTFILES_DIR_HOST=/dev/null
DOTFILES_INSTALL_COMMAND=":"
```

### dotfiles のマウント

Docker ホスト上にある共通 dotfiles ディレクトリ（例: `~/dotfiles`）をコンテナにマウントすることもできる。
その場合は例えば次のように `.env` ファイルを編集して、Docker ホスト上のディレクトリパスとコンテナへのマウント先パス、およびインストール用コマンドを指定する。

```
DOTFILES_DIR_HOST=~/dotfiles
DOTFILES_DIR_CONTAINER=/home/rstudio/dotfiles
DOTFILES_INSTALL_COMMAND="~/dotfiles/install.sh"
```

### SSH 認証

コンテナ内から GitHub に SSH で接続したい場合は、以下のステップに従う。

1. SSH 鍵を作成し、それを GitHub アカウントに追加する。
2. Docker ホスト上で SSH Agent を有効化する・
3. 鍵を SSH Agent に追加する。
4. VS Code によって自動的に SSH Agent のソケットがコンテナにマウントされ、コンテナ内から鍵が使えるようになる。

### ワークスペースのパス

デフォルトでは、このフォルダの親フォルダがコンテナの `/home/rstudio/project` にマウントされる。
`.env` ファイルを編集することにより、マウント元とマウント先をそれぞれ変数 `LOCAL_WORKSPACE_FOLDER` と変数 `CONTAINER_WORKSPACE_FOLDER` で変更できる。

例

```
LOCAL_WORKSPACE_FOLDER=../sub-dir
CONTAINER_WORKSPACE_FOLDER=/home/rstudio/your-project-name
```

## 参考資料

Git  
- [Git - Book](https://git-scm.com/book/ja/v2)
- [GitHub に SSH で接続する - GitHub Docs](https://docs.github.com/ja/authentication/connecting-to-github-with-ssh)

Docker  
- [Docker Desktop overview | Docker Documentation](https://docs.docker.com/desktop/)
- [Compose specification | Docker Documentation](https://docs.docker.com/compose/compose-file/)
- [docker compose | Docker Documentation](https://docs.docker.com/engine/reference/commandline/compose/)
- [Networking features in Docker Desktop for Mac | Docker Documentation](https://docs.docker.com/desktop/mac/networking/#ssh-agent-forwarding)

dotfiles  
- [GitHub does dotfiles - dotfiles.github.io](https://dotfiles.github.io/)
- [RStudio のオプション設定を dotfiles で管理する - terashim.com](https://terashim.com/posts/rstudio-dotfiles/)

RStudio  
- [RStudio - RStudio](https://rstudio.com/products/rstudio/#rstudio-server)
- [RStudio 1.3 Preview: Configuration and Settings | RStudio Blog](https://blog.rstudio.com/2020/02/18/rstudio-1-3-preview-configuration/)
- [Customizing Keyboard Shortcuts – RStudio Support](https://support.rstudio.com/hc/en-us/articles/206382178-Customizing-Keyboard-Shortcuts)
- [Version Control with Git and SVN – RStudio Support](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN)
- [Rocker Project](https://www.rocker-project.org/)

renv  
- [Project Environments • renv](https://rstudio.github.io/renv/index.html)
- [Using renv with Docker • renv](https://rstudio.github.io/renv/articles/docker.html)
- [Rのパッケージ管理のためのrenvの使い方 - Qiita](https://qiita.com/okiyuki99/items/688a00ca9a58e42e3bfa)
- [renv と Docker の相互運用パターン - terashim.com](https://terashim.com/posts/renv-docker-patterns/)

Visual Studio Code Remote - Containers  
- [Developing inside a Container using Visual Studio Code Remote Development](https://code.visualstudio.com/docs/remote/containers)
- [【R】Windows10のRStudio Desktop使うのをやめてVSCodeからrockerコンテナ立ち上げている話 - Qiita](https://qiita.com/eitsupi/items/ae0f89266b560b4e7096#devcontainerdevcontainerjson)
