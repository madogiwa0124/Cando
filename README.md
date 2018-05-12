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
# 進捗メモ :memo:
## 必須要件
* [x] ステップ1: Railsの開発環境を構築しよう
* [x] ステップ2: GitHubにリポジトリを作成しよう
* [x] ステップ3: Railsプロジェクトを作成しよう
* [x] ステップ4: 作りたいアプリケーションのイメージを考えよう
* [x] ステップ5: データベースの接続設定（周辺設定）をしよう
* [x] ステップ6: タスクモデルを作成しよう
* [x] ステップ7: タスクを登録・更新・削除できるようにしよう
* [x] ステップ8: E2Eテストを書こう
* [x] ステップ9: アプリの日本語部分を共通化しよう
* [x] ステップ10: Railsのタイムゾーンを設定しよう
* [x] ステップ11: タスク一覧を作成日時の順番で並び替えよう
* [x] ステップ12: バリデーションを設定しよう
* [x] ステップ13: デプロイをしよう
* [x] ステップ14: 終了期限を追加しよう
* [x] ステップ15: ステータスを追加して、検索できるようにしよう
* [x] ステップ16: 優先順位を設定しよう
* [x] ステップ17: ページネーションを追加しよう
* [x] ステップ18: デザインを当てよう
* [x] ステップ19: 複数人で利用できるようにしよう（ユーザの導入）
* [ ] ステップ20: ログイン/ログアウト機能を実装しよう
* [ ] ステップ21: ユーザの管理画面を実装しよう
* [ ] ステップ22: ユーザにロールを追加しよう
* [ ] ステップ23: タスクにラベルをつけられるようにしよう
* [ ] ステップ24: エラーページを適切に設定しよう
## オプション要件
* [ ] オプション要件1: 終了間近や期限の過ぎたタスクがあった場合、アラートを出したい
* [ ] オプション要件2: ユーザの間でタスクを共有できるようにしたい
* [ ] オプション要件3: グループを設定できるようにしたい
* [ ] オプション要件4: タスクに添付ファイルをつけられるようにしたい
* [ ] オプション要件5: ユーザにプロフィール画像を設定できるようにしてみましょう
* [ ] オプション要件6: タスクカレンダーの機能がほしい
* [ ] オプション要件7: タスクをドラッグ&ドロップで並べ替えられるようにしたい
* [ ] オプション要件8: ラベルの使用頻度をグラフ化してみましょう
* [ ] オプション要件9: 終了間近のタスクを作成ユーザ宛てにメール通知してみましょう
* [ ] オプション要件10: AWS にインスタンスを作って環境構築する
