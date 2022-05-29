# 2022/05/29

- renv のバージョンを 0.15.5 に修正
- README を修正
- docker-compose.yml を compose.yml に変更
- .env.example のコメントを修正
- コンテナにインストール済みの renv でプロジェクトをロードするよう修正

# 2022/05/03

- R のバージョンを 4.2.0 に、renv のバージョンを 0.15.4 に修正
- VS Code Remote Container でも起動できるように修正
- SSH 鍵ファイルのマウントに代えて SSH Agent を利用するよう修正
- renv によるバージョン固定で "explicit" なスナップショットタイプを推奨
- コンテナ起動スクリプトを修正
- フォルダ構成を変更