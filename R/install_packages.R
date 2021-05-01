# パッケージのインストール

# パッケージをインストールするには次のようにする
renv::install("palmerpenguins")

# パッケージを追加／変更したら renv.lock ファイルを更新する
renv::snapshot()
