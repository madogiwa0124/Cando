require 'rails_helper'
RSpec.describe '登録したタスクを確認する', type: :feature, js: true do
  let!(:task1) { FactoryBot.create(:task, :low,    :done,  title: 'タイトル1', deadline: Time.current.since(1.day)) }
  let!(:task2) { FactoryBot.create(:task, :medium, :doing, title: 'タイトル2', deadline: Time.current.since(2.days)) }
  let!(:task3) { FactoryBot.create(:task, :high,   :todo,  title: 'タイトル3', deadline: Time.current.since(3.days)) }

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

    describe 'タスクの並び替え' do
      it '期限の降順で並び替えが行えること' do
        within(all('thead th')[3]) do
          click_button '▼'
        end
        expect(all('tbody tr')[0]).to have_content task3.title
        expect(all('tbody tr')[1]).to have_content task2.title
        expect(all('tbody tr')[2]).to have_content task1.title
      end

      it '期限の昇順で並び替えが行えること' do
        within(all('thead th')[3]) do
          click_button '▲'
        end
        expect(all('tbody tr')[0]).to have_content task1.title
        expect(all('tbody tr')[1]).to have_content task2.title
        expect(all('tbody tr')[2]).to have_content task3.title
      end
    end
  end

  describe 'タスク詳細' do
    before { visit task_path(task1) }

    it '指定したタスクの詳細が表示されること' do
      expect(page).to have_content task1.title
    end
  end
end
