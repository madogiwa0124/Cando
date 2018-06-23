require 'rails_helper'
RSpec.describe 'タスクの登録・更新・削除', type: :feature, js: true do
  let!(:current_user) { FactoryBot.create(:user) }

  before do
    visit login_path
    fill_in User.human_attribute_name(:email),    with: current_user.email
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('user_sessions.new.submit')
  end

  describe 'タスクの登録' do
    let(:task) { FactoryBot.build(:task, :with_label) }

    context '正常な入力値でタスクを登録した場合' do
      before do
        visit new_task_path
        fill_in Task.human_attribute_name(:title),       with: task.title
        fill_in Task.human_attribute_name(:description), with: task.description
        fill_in Task.human_attribute_name(:deadline),    with: task.deadline
        fill_in I18n.t('activerecord.attributes.task.label_list'), with: task.labels.pluck(:name).join(',')
        select Task.statuses_i18n[task.status],     from: Task.human_attribute_name(:status)
        select Task.priorities_i18n[task.priority], from: Task.human_attribute_name(:priority)
      end

      it 'タスクが登録されること' do
        expect { click_button I18n.t('common.save') }.to change(Task, :count).by(1)
      end

      it 'ownerがログインユーザーと一致すること' do
        click_button I18n.t('common.save')
        expect(Task.last.owner).to eq current_user
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
    let!(:task) { FactoryBot.create(:task, user: current_user, owner: current_user) }
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

    context '他グループのユーザのタスクを編集しようとした場合' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:group) { FactoryBot.create(:group) }
      let!(:user_group) { FactoryBot.create(:user_group, group: group, user: user) }
      let!(:other_task) { FactoryBot.create(:task, title: 'タイトル_1', user: user, owner: user) }

      it '編集画面に遷移できないこと' do
        expect(current_path).to eq tasks_path
      end
    end
  end

  describe 'タスクの削除' do
    let!(:task) { FactoryBot.create(:task, user: current_user, owner: current_user) }
    before { visit tasks_path }

    it 'タスクが削除されること' do
      expect { first('tbody tr').click_link I18n.t('common.destroy') }.to change(Task, :count).by(-1)
    end
  end
end
