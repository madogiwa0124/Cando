# タスクの作成
5.times do |n|
  FactoryBot.create(:user, name: "test_user_#{n}")
end

1.times do |n|
  FactoryBot.create(:user, name: "admin_user", email: 'administrater@email.com')
end

100.times do |n|
  case n % 4
  when 0 then FactoryBot.create(:task, :todo, :low, title: "タイトル_#{n}", user: User.first, owner: User.first)
  when 1 then FactoryBot.create(:task, :doing, :medium, title: "タイトル_#{n}", user: User.second, owner: User.fourth)
  when 2 then FactoryBot.create(:task, :done, :high, title: "タイトル_#{n}", user: User.third, owner: User.fifth)
  when 3 then FactoryBot.create(:task, owner: User.first)
  end
end
