require 'rails_helper'
RSpec.describe 'タスクの登録・更新・削除', type: :feature, js: true do
  describe 'タスクの登録' do
    let(:task) { FactoryBot.build(:task) }
    context '正常な入力値でタスクを登録した場合' do
      before do
        visit new_task_path
        fill_in Task.human_attribute_name(:title),       with: task.title
        fill_in Task.human_attribute_name(:description), with: task.description
        fill_in Task.human_attribute_name(:deadline),    with: task.deadline
        select Task.statuses_i18n[task.status],     from: Task.human_attribute_name(:status)
        select Task.priorities_i18n[task.priority], from: Task.human_attribute_name(:priority)
      end

      it 'タスクが登録されること' do
        expect { click_button I18n.t('common.save') }.to change(Task, :count).by(1)
      end
    end

    context '異常な入力値でタスクを登録した場合' do
      before do
        visit new_task_path
        fill_in Task.human_attribute_name(:title),       with: task.title
        fill_in Task.human_attribute_name(:description), with: task.description
        fill_in Task.human_attribute_name(:deadline),    with: Time.current.ago(1.day)
        select Task.statuses_i18n[task.status],     from: Task.human_attribute_name(:status)
        select Task.priorities_i18n[task.priority], from: Task.human_attribute_name(:priority)
      end

      it 'タスクが登録されないこと' do  
        expect { click_button I18n.t('common.save') }.to change(Task, :count).by(0)
      end
    end
  end

  describe 'タスクの更新' do
    let!(:task) { FactoryBot.create(:task) }
    context '正常な入力値でタスクを登録した場合' do
      before do
        visit edit_task_path(task)
        fill_in Task.human_attribute_name(:title), with: 'edited'
        click_button I18n.t('common.save')
      end

      it 'タスクが更新されること' do
        expect(Task.find(task.id).title).to eq 'edited'
      end
    end

    context '異常な入力値でタスクを更新した場合' do
      before do
        visit edit_task_path(task)
        fill_in Task.human_attribute_name(:title),    with: 'edited'
        fill_in Task.human_attribute_name(:deadline), with: Time.current.ago(1.day)
        click_button I18n.t('common.save')
      end

      it 'タスクが更新されないこと' do  
        expect(Task.find(task.id).title).to eq task.title
      end
    end
  end

  describe 'タスクの削除' do
    let!(:task) { FactoryBot.create(:task) }
    before { visit tasks_path }

    it 'タスクが削除されること' do
      expect { first('tbody tr').click_link I18n.t('common.destroy') }.to change(Task, :count).by(-1)
    end
  end
end
