# タスクの作成
100.times do |n|
  FactoryBot.create(:task, title: "タイトル_#{n}")
end

5.times do |n|
  FactoryBot.create(:user, name: "test_user_#{n}")
end
