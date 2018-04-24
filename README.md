# このリポジトリは？
下記の万葉さんの新人研修をやってみるリポジトリ  
https://github.com/everyleaf/el-training


# 勉強の基本的な進め方
1. ローカルにrailsの開発環境を作成し、`rails new`する。
    * 開発環境構築に、このリポジトリを使う場合は、`Fork`して下記の`構築方法`を参照
1. github上にリモートリポジトリを作成し、`master`ブランチに`push`
1. `master`ブランチから任意の名前の作業用のブランチを切ってPRベースで`master`に`merge`する
1. 勉強会または、Web上でお互いPRのレビューを行う

PRをお互いにレビューして共有して、良い感じに高まる感じを目指す:muscle:

# このリポジトリの使い方
## 環境構築
### 環境
Dockerで下記環境が構築されるようになってます。

|環境|version|
|:--|:--|
|ruby|2.5.1|
|rails|5.2.0|
|posgresql|latest|

### 構築方法
下記コマンドを実行して、`localhost:3000`にアクセスするとRailsのスタートページが表示されます。
```
$ git clone https://github.com/Madogiwa0124/docker_sample_app.git
$ docker-compose up
```

## tips
### スタートページアクセス時にDB関係のエラーが出る
DBが未作成、マイグレーションが未実行の可能性がありますので、下記コマンドを実行してみてください。
```
$ docker exec -it cando_web_server_1 bash
$ rails db:create
$ rails db:migrate
``` 

### コンテナ起動時にdockersampleapp_web_server_1 exited with code 1が発生する
`tmp/pids/server.pid`を削除して、`docker-compose run web_server rails s`を実行してみてください。
```
$ rm tmp/pids/server.pid
$ docker-compose run web_server rails s
```
