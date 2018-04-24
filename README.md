# このリポジトリは？
下記の万葉さんの新人研修をやってみるリポジトリ  
https://github.com/everyleaf/el-training

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

### tips
#### スタートページアクセス時にDB関係のエラーが出る
DBが未作成、マイグレーションが未実行の可能性がありますので、下記コマンドを実行してみてください。
```
$ docker exec -it cando_web_server_1 bash
$ rails db:create
$ rails db:migrate
``` 

#### コンテナ起動時にdockersampleapp_web_server_1 exited with code 1が発生する
`tmp/pids/server.pid`を削除して再度、`docker-compose up`を実行してみてください。
