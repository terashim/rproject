R プロジェクトのひな形
==================================================

## 特徴

- Docker と Docker Compose
    - RStudio Server の Docker コンテナイメージ [`rocker/rstudio`](https://hub.docker.com/r/rocker/rstudio) を使用する
    - OS や 共有ライブラリ, R のバージョンなどの環境を複数のマシンで再現できる
    - コンテナ起動時の設定を [`docker-compose.yml`](./docker-compose.yml) ファイルで管理する
    - `docker-compose up` や `docker-compose down` のコマンドだけで作業環境を起動・終了できる
- Git と GitHub
    - [Git](https://git-scm.com/) でソースコードのバージョン管理を行う
    - [GitHub](https://github.com/) でソースコードをチームに共有して共同作業を行う
- renv
    - [renv](https://rstudio.github.io/renv/index.html) でプロジェクト固有のライブラリを作成し, 依存関係を管理する
    - `renv.lock` ファイルでパッケージのバージョンを固定する
    - Docker ホストからパッケージキャッシュをマウントしてストレージ容量とインストール時間を改善する
- dotfiles
    - RStudio や Git のグローバル設定ファイルを dotfiles リポジトリで管理する
    - 設定ファイルを Docker ホストからコンテナにマウントして利用する
    - 一度コンテナを停止しても設定内容が維持される
    - 複数プロジェクトのコンテナに同一の設定を反映できる
    - 同一プロジェクトでもチームメンバー個人ごとに設定をカスタマイズできる
    - GitHub を経由してマシン間で設定を同期できる

## 初期設定

### 開発者ごとの初期設定

- GitHub アカウント（例: `username`）を用意する
- GitHub でテンプレートリポジトリ [`terashim/rproject-dotfiles-template`](https://github.com/terashim/rproject-dotfiles-template) を元に, 自分の dotfiles リポジトリ (例: `username/rproject-dotfiles`) を作成する
- dotfiles リポジトリの `.gitconfig` ファイルを編集して Git で使用するユーザー名とメールアドレスを設定する

### マシンごとの初期設定

- dotfiles
    - GitHub 上の dotfiles リポジトリ（例: `username/rproject-dotfiles`）をローカル環境の適当な場所（例: `~/.ghq/github.com/username/rproject-dotfiles`）にクローンする.
- renv
    - renv パッケージキャッシュとなるディレクトリを作成する. 例えば macOS なら `~/Library/Application Support/renv/cache` が標準的なディレクトリパスとなる.
- GitHub への SSH 接続
    - GitHub に接続するための SSH 公開鍵/秘密鍵ペアを用意する.
    - GitHub のユーザー設定で公開鍵を登録する.
    - 秘密鍵はマシンの適当な場所（例: `~/.ssh/id_ed25519`）に保存しておく.

### プロジェクトごとの初期設定

- このテンプレートリポジトリ [`terashim/rproject`](https://github.com/terashim/rproject) を元に, プロジェクトのリポジトリ（例: `your-org/your-rproject`）を作成する.

### プロジェクト × マシンごとの初期設定

- プロジェクトの GitHub リポジトリ（例: `your-org/your-rproject`）をローカル環境の適当な場所（例: `~/.ghq/github.com/your-team/your-rproject`）にクローンする.
- [`.env.example`](./.env.example) ファイルをコピーして `.env` ファイルを作成する.
- `.env` ファイルを編集して下記の項目を設定する

| 環境変数  | 意味      | 例        |
|:----------|:----------|:----------|
| `PROJECT_MOUNT_PATH`  | プロジェクトのマウント先ディレクトリパス | `/home/rstudio/your-rproject` |
| `IMAGE_NAME`          | Docker コンテナのイメージ名 | `your-repo/your-rproject-rstudio:4.0.3` |
| `DOTFILES_ROOT`       | dotfiles のディレクトリパス | `~/.ghq/github.com/username/rproject-dotfiles` |
| `RENV_PATHS_CACHE`    | renv パッケージキャッシュのディレクトリパス | `~/Library/Application Support/renv/cache` |
| `GITHUB_SSH_IDENTITY` | SSH 秘密鍵のファイルパス | `~/.ssh/id_ed25519` |

## 作業フロー

### 作業環境の起動〜終了

1. このディレクトリで `docker-compose up -d` を実行して RStudio Server の Docker コンテナを起動する
2. ブラウザで <http://localhost:8787> を開き RStudio Server に接続する
3. RStudio Server 上で分析／開発を行う
4. このディレクトリで `docker-compose down` を実行して Docker コンテナを停止する

### RStudio の設定変更と同期

RStudio Server 上で "Tools" > "Global Options" からカラーテーマやフォント, ペイン構成などの設定を変更すると dotfiles リポジトリの `.config/rstudio/` 以下のファイルが更新される.
dotfiles リポジトリは Docker ホスト（コンテナの外）に保存されているので, コンテナを一度停止して再起動したときや他のプロジェクトで別のコンテナを起動したときにも同じ設定が反映される.
さらに, 複数マシン間で設定を共有したい場合は変更された内容をコミットして GitHub にプッシュする.

### Git の操作

Git でソースコードの変更履歴を管理する.
RStudio Server の "Git" タブを使っても, "Terminal" タブからコマンドで操作しても良い.
Docker ホストにインストールされた Git や GUI ツールを使用しても良い.

RStudio Server の "Terminal" タブから `git config --global` コマンドで設定を変更すると dotfiles の `.gitconfig` ファイルが書き換えられる.
dotfiles リポジトリは Docker ホスト（コンテナの外）に保存されているので, コンテナを一度停止して再起動したときや他のプロジェクトで別のコンテナを起動したときにも同じ設定が反映される.
さらに複数マシン間で設定を共有したい場合は変更された内容をコミットして GitHub にプッシュする.

### renv によるパッケージ管理

- renv によってプロジェクト固有のライブラリ（プライベートライブラリ）が作成される.
- 新しいパッケージをライブラリにインストールするときは `renv::install()` 関数を使用する.
- ライブラリの状態を記録するには `renv::snapshot()` 関数を使用する. このとき, ライブラリにインストールされたパッケージのバージョン情報が `renv.lock` ファイルに保存される. この内容を GitHub にプッシュし, チームメンバー間で共有する.
- `renv::restore()` 関数を使用すると, `renv.lock` ファイルに保存された情報からライブラリの状態を復元することができる.
- インストールされたパッケージの実体ファイルは Docker ホスト上（コンテナの外）のパッケージキャッシュに保存される. コンテナを一度停止して再起動したときや他のプロジェクトで別のコンテナを起動したとき, 同じパッケージを使用するならパッケージキャッシュに保存されたファイルが再利用される.

## 参考

- Git
    - [Git - Git の設定](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%9E%E3%82%A4%E3%82%BA-Git-%E3%81%AE%E8%A8%AD%E5%AE%9A)
    - [Git - Git エイリアス](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E5%9F%BA%E6%9C%AC-Git-%E3%82%A8%E3%82%A4%E3%83%AA%E3%82%A2%E3%82%B9)
    - [GitHub に SSH で接続する - GitHub Docs](https://docs.github.com/ja/github/authenticating-to-github/connecting-to-github-with-ssh)
- Docker
    - Docker のインストール等について: [Docker Desktop overview | Docker Documentation](https://docs.docker.com/desktop/)
    - `docker-compose.yml` の文法: [Compose file version 3 reference | Docker Documentation](https://docs.docker.com/compose/compose-file/compose-file-v3/)
    - `docker-compose` コマンドについて: [Overview of docker-compose CLI | Docker Documentation](https://docs.docker.com/compose/reference/overview/)
- dotfiles
    - dotfiles + GitHub 運用についての情報サイト: [GitHub does dotfiles - dotfiles.github.io](https://dotfiles.github.io/)
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
