require 'rails_helper'
RSpec.describe '登録したタスクを確認する', type: :feature, js: true do
  let!(:task1) { FactoryBot.create(:task, title: 'タイトル1', status: Task.statuses[:done]) }
  let!(:task2) { FactoryBot.create(:task, title: 'タイトル2') }
  let!(:task3) { FactoryBot.create(:task, title: 'タイトル3') }

  describe 'タスク一覧' do
    before { visit tasks_path }

    it 'タスクの一覧が表示されること' do  
      expect(page).to have_content task1.title
      expect(page).to have_content task2.title
      expect(page).to have_content task3.title
    end

    describe 'タスク検索' do
      before do
        fill_in Task.human_attribute_name(:title), with: task1.title
        select Task.statuses_i18n[task1.status], from: Task.human_attribute_name(:status)
        click_button I18n.t('common.search')
      end

      it 'タイトルとステータスでタスクの検索が行えること' do
        expect(page).to have_content task1.title
        expect(page).to_not have_content task2.title
        expect(page).to_not have_content task3.title
      end

      it '検索後も入力値が保持されること' do
        expect(page).to have_field Task.human_attribute_name(:title), with: task1.title
        expect(page).to have_select Task.human_attribute_name(:status), selected: Task.statuses_i18n[task1.status]
      end
    end
  end

  describe "タスク詳細" do
    before { visit task_path(task1) }

    it '指定したタスクの詳細がが表示されること' do  
      expect(page).to have_content task1.title
    end
  end
end
