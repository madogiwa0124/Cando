require 'rails_helper'
RSpec.describe '登録したタスクを確認する', type: :feature, js: true do
  let!(:task1) { FactoryBot.create(:task, title: 'タイトル1') }
  let!(:task2) { FactoryBot.create(:task, title: 'タイトル2') }
  let!(:task3) { FactoryBot.create(:task, title: 'タイトル3') }

  describe 'タスク一覧' do
    before { visit tasks_path }

    it 'タスクの一覧が表示されること' do  
      expect(page).to have_content task1.title
      expect(page).to have_content task2.title
      expect(page).to have_content task3.title
    end
  end

  describe "タスク詳細" do
    before { visit task_path(task1) }

    it '指定したタスクの詳細がが表示されること' do  
      expect(page).to have_content task1.title
    end
  end
end
