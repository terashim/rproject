R プロジェクトのひな形
==================================================

Git/GitHub、Docker、RStudio、renv を利用した R プロジェクトのひな形

## 特徴

- Git と GitHub
    - [Git](https://git-scm.com/) でソースコードのバージョン管理を行う
    - [GitHub](https://github.com/) でソースコードをチームに共有して共同作業を行う
- Docker と Docker Compose
    - RStudio Server の Docker コンテナイメージ [`rocker/rstudio`](https://hub.docker.com/r/rocker/rstudio) を使用する
    - Linux ディストリビューションや共有ライブラリ、R のバージョンなどについて同じ環境を複数のマシン上で再現できる
    - コンテナを起動する際の設定を [`docker-compose.yml`](./docker-compose.yml) ファイルで管理する
    - `docker compose up` や `docker compose down` のコマンドだけで作業環境を起動・終了できる
    - Docker なしでも RStudio Desktop で動作させることは可能
- renv
    - [renv](https://rstudio.github.io/renv/index.html) でプロジェクト固有のライブラリを作成し、依存関係を管理する
    - `renv.lock` ファイルでパッケージのバージョンを固定する
    - Docker ホストからパッケージキャッシュをマウントしてストレージ容量とインストール時間を改善する
- dotfiles
    - RStudio や Git のグローバル設定ファイルを dotfiles フォルダで管理する
    - 設定ファイルを Docker ホストからコンテナにマウントして利用する
    - コンテナを停止しても設定内容が維持される
    - 複数プロジェクトのコンテナに同一の設定を反映できる
    - 同一プロジェクトでもチームメンバー個人ごとに設定をカスタマイズできる
    - GitHub を経由してマシン間で設定を同期できる

## 初期設定

### プロジェクトの作成

このテンプレートリポジトリ [`terashim/rproject`](https://github.com/terashim/rproject) を元に、プロジェクトのリポジトリ（例: `your-org/your-rproject`）を作成する。

### マシンごとの初期設定

- Git と Docker をインストールし、GitHub へ接続できるようにしておく。
- プロジェクトの GitHub リポジトリ（例: `your-org/your-rproject`）をローカル環境の適当な場所（例: `~/ghq/github.com/your-org/your-rproject`）にクローンする。

## 作業フロー

### 作業環境の起動〜終了

マシン上で Docker デーモンが起動しているものとする。

1. このディレクトリで `docker compose up -d` を実行することで RStudio Server の Docker コンテナを起動する
2. ブラウザで <http://localhost:8787> を開き RStudio Server に接続する
3. RStudio Server 上でこのプロジェクトを開き、分析/開発作業を行う
4. 作業を終了するときは、このディレクトリで `docker compose down` を実行することで Docker コンテナを停止する

VS Code と Remote Container を利用している場合は、コマンドパレットから
"Remote-Containers: Open Folder in Container..."
を選び、プロジェクトルート（このディレクトリの一つ上）を開くことで RStudio Server を起動することもできる。

### RStudio の設定変更

- RStudio Server 上で "Tools" > "Global Options" からカラーテーマやフォント、ペイン構成、キーボードショートカットなどの設定を変更すると [`.docker/dotfiles/.config/rstudio/`](`./.docker/dotfiles/.config/rstudio/`) 内の設定ファイルが更新される。
- dotfiles は Docker ホスト（コンテナの外）に保存されているので、コンテナを一度停止して再起動しても同じ設定が反映される。
- 変更した設定を複数のプロジェクト間で共有したい場合は、プロジェクト間で共通の dotfiles を利用する（後述）。

### Git の操作

#### バージョン管理

- Git でソースコードの変更履歴を管理する。
- Docker ホストにインストールされた Git や SourceTree などの GUI ツールを使用しても良い。
- RStudio Server の "Git" タブを使っても、"Terminal" タブからコマンドで操作しても良い。

#### グローバル設定の管理

- RStudio Server の "Terminal" タブから `git config --global` コマンドで設定を変更すると dotfiles の `.gitconfig` ファイルが書き換えられる。
- dotfiles は Docker ホスト（コンテナの外）に保存されているので、コンテナを一度停止してから再起動しても同じ設定が反映される。
- 同じ設定を複数のプロジェクト間で共有したい場合は、プロジェクト間で共通の dotfiles を利用する（後述）。

#### GitHub との通信

- コンテナ内から GitHub への push や pull を行いたい場合は、Docker ホストで SSH Agent を有効にし、ソケットをコンテナへマウントする（後述）。

### renv によるパッケージ管理

- プロジェクトを開いたら `renv::load()` で renv を有効にする。
- renv によってプロジェクト固有のライブラリ（プライベートライブラリ）が `/home/rstudio/.renv/library/` 以下のディレクトリ内に作成される。
- `renv::restore()` 関数を使用すると、`renv.lock` ファイルに記録された情報からライブラリの状態を復元することができる。
- 新しいパッケージをライブラリにインストールするときは [`DESCRIPTION`](../DESCRIPTION) ファイルに依存関係を追加し、`renv::install()` 関数を実行する。
- ライブラリの状態を記録するには `renv::snapshot()` 関数を使用する。このとき、`DESCRIPTION` ファイルに記載されたパッケージとその依存関係について、バージョン情報が [`renv.lock`](./renv.lock) ファイルに記録される。この内容を GitHub にプッシュし、チームメンバー間で共有することで同じライブラリの状態が再現される。
    - ※注意：設定ファイル [`../renv/settings.dcf`](../renv/settings.dcf) でデフォルトのスナップショットタイプを `explicit` に指定しているため、`DESCRIPTION` ファイルに記載されたパッケージとその依存関係のみがバージョン固定の対象となる。
- インストールされたパッケージの実体ファイルは Docker ホスト上（コンテナの外）のパッケージキャッシュに保存される。コンテナを一度停止してからまた再起動したときは、パッケージキャッシュに保存されたファイルが再利用される。

## カスタマイズ

### `.env` ファイルによる環境変数の設定

[`.env.example`](./.env.example) ファイルをコピーして `.env` ファイルを作成する。`.env` ファイル内の環境変数を書き換えることによってコンテナ起動時の設定を制御する。

なおこの環境変数はユーザー `rstudio` の R セッションに反映されないので注意のこと。
R セッションで使用する環境変数をファイルで管理したい場合は `.env` ファイルではなく [`.Renviron`](../.Renviron) ファイルを利用する。

### renv パッケージキャッシュのプロジェクト間共有

デフォルトでは [renv のパッケージキャッシュ](https://rstudio.github.io/renv/articles/renv.html#cache-1) が [`./data/renv/cache/`](./data/renv/cache) に作成される。
しかしこのパッケージキャッシュはプロジェクト固有で使用されるため、保存されたパッケージファイルが別のプロジェクトでは再利用されない。

ダウンロードしたパッケージを他のプロジェクトで再利用するためには、プロジェクト間で共通の renv パッケージキャッシュディレクトリをマシン上に１つ作成する。例えば macOS なら `~/Library/Application Support/renv/cache` が標準的なディレクトリパスとなる。

共通パッケージキャッシュを作成したら、`.env` ファイル内の環境変数 `RENV_PATHS_CACHE_HOST` でそのパスを指定する。

例：

```
RENV_PATHS_CACHE_HOST="~/Library/Application Support/renv/cache"
```

### 共通 dotfiles によるプロジェクト間での設定共有

デフォルトでは RStudio や Git のグローバル設定が [`dotfiles/`](./dotfiles) フォルダ内の `.config/rstudio/rstudio-prefs.json` や `.config/git/config` などのファイルに保存される。
しかしこのフォルダはプロジェクト固有で使用されるため、別のプロジェクトには設定内容が反映されない。

設定内容を複数のプロジェクト間で共有したい場合は、プロジェクト固有の [`dotfiles/`](./dotfiles) の代わりにプロジェクト間で共通の dotfiles ディレクトリ（例: `~/rproject-dotfiles` ）をマシン上に１つ作成する。
共通 dotfiles ディレクトリを作成したら、そのパスを `.env` ファイル内の環境変数 `DOTFILES_DIR_HOST` で指定する。

例：

```
DOTFILES_DIR_HOST=~/rproject-dotfiles
```

さらに、dotfiles を GitHub リポジトリとして管理することにより複数のマシン間で設定内容を同期することもできる。

VS Code の Remote Container 拡張機能を使う場合、
GitHub による dotfiles の管理オプションを利用することもできる。
その場合はボリュームのマウントによる dotfiles を無効にするため、
`.env` ファイルで

```
DOTFILES_DIR_HOST=/dev/null
```

と設定する。

### Git と GitHub

コンテナ内の Git を使いたい場合は、以下の設定を行う。Docker ホストの Git を使用する場合は設定しなくても良い。

#### ユーザー名とメールアドレスの設定

RStudio で Terminal ペインを開き、以下のようなコマンドを実行してコンテナ内の Git で使用するユーザー名とメールアドレスを設定する:

```sh
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```

この設定内容は `dotfiles` 内の `.config/git/config` ファイルに書き込まれる。

プロジェクト間で共通の dotfiles を使っている場合は、この設定はプロジェクトごとに個別に行わなくても良い。

#### SSH 秘密鍵の設定

Docker ホストマシン上で以下の設定を行う。

- GitHub に接続するための SSH 秘密鍵を作成・保存する。
- その秘密鍵を `ssh-add` で SSH Agent に追加しておく。
- SSH Agent ソケットのパスを環境変数 `SSH_AUTH_SOCK` から読み取る。
- コンテナにマウントするため、`.env` ファイルで `SSH_AUTH_SOCK_HOST` にソケットのパスを設定する。
    - ただし Docker Desktop for Mac を使っている場合は環境変数 `SSH_AUTH_SOCK` から読み取った値ではなく `/run/host-services/ssh-auth.sock` を指定する。

### プロジェクトのマウント先パス

デフォルトではこのプロジェクトフォルダがコンテナ内の `/home/rstudio/project` にマウントされる。
マウント先のパスは `.env` の環境変数 `PROJECT_PATH_CONTAINER` で変更することができる。

例:

```
PROJECT_PATH_CONTAINER=/home/rstudio/yourproject
```

## 参考

- Git
    - [Git - Git の設定](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%9E%E3%82%A4%E3%82%BA-Git-%E3%81%AE%E8%A8%AD%E5%AE%9A)
    - [Git - Git エイリアス](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E5%9F%BA%E6%9C%AC-Git-%E3%82%A8%E3%82%A4%E3%83%AA%E3%82%A2%E3%82%B9)
    - [GitHub に SSH で接続する - GitHub Docs](https://docs.github.com/ja/github/authenticating-to-github/connecting-to-github-with-ssh)
- Docker
    - Docker のインストール等について: [Docker Desktop overview | Docker Documentation](https://docs.docker.com/desktop/)
    - `docker-compose.yml` の文法: [Compose file version 3 reference | Docker Documentation](https://docs.docker.com/compose/compose-file/compose-file-v3/)
    - `docker-compose` コマンドについて: [Overview of docker-compose CLI | Docker Documentation](https://docs.docker.com/compose/reference/overview/)
    - SSH Agent ソケットの転送について: [Networking features in Docker Desktop for Mac | Docker Documentation](https://docs.docker.com/desktop/mac/networking/#ssh-agent-forwarding)
- dotfiles
    - dotfiles + GitHub 運用についての情報サイト: [GitHub does dotfiles - dotfiles.github.io](https://dotfiles.github.io/)
    - [RStudio のオプション設定を dotfiles で管理する - terashim.com](https://terashim.com/posts/rstudio-dotfiles/)
- RStudio
    - RStudio Server 公式ページ: [RStudio - RStudio](https://rstudio.com/products/rstudio/#rstudio-server)
    - RStudio 設定ファイルについて: [RStudio 1.3 Preview: Configuration and Settings | RStudio Blog](https://blog.rstudio.com/2020/02/18/rstudio-1-3-preview-configuration/)
    - ショートカットキーのカスタマイズについて: [Customizing Keyboard Shortcuts – RStudio Support](https://support.rstudio.com/hc/en-us/articles/206382178-Customizing-Keyboard-Shortcuts)
    - RStudio での Git 操作について: [Version Control with Git and SVN – RStudio Support](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN)
    - rocker プロジェクト: [Rocker Project](https://www.rocker-project.org/)
- renv
    - renv 公式ドキュメント: [Project Environments • renv](https://rstudio.github.io/renv/index.html)
    - Docker との併用について: [Using renv with Docker • renv](https://rstudio.github.io/renv/articles/docker.html)
    - [Rのパッケージ管理のためのrenvの使い方 - Qiita](https://qiita.com/okiyuki99/items/688a00ca9a58e42e3bfa)
    - [renv と Docker の相互運用パターン - terashim.com](https://terashim.com/posts/renv-docker-patterns/)
- VS Code と Remote Containers 拡張機能
    - [Developing inside a Container using Visual Studio Code Remote Development](https://code.visualstudio.com/docs/remote/containers)
    - [【R】Windows10のRStudio Desktop使うのをやめてVSCodeからrockerコンテナ立ち上げている話 - Qiita](https://qiita.com/eitsupi/items/ae0f89266b560b4e7096#devcontainerdevcontainerjson)
