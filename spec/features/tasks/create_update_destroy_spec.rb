require 'rails_helper'
RSpec.describe 'タスクの登録・更新・削除', type: :feature, js: true do
  describe 'タスクの登録' do
    let(:task) { FactoryBot.build(:task) }
    context '正常な入力値でタスクを登録した場合' do
      before do
        visit new_task_path
        fill_in 'Title',       with: task.title
        fill_in 'Description', with: task.description
        select task.status,    from: 'Status'
        select task.priority,  from: 'Priority'
        fill_in 'Deadline',    with: task.deadline
      end

      it 'タスクが登録されること' do
        expect { click_button 'Save' }.to change(Task, :count).by(1)
      end
    end

    context '異常な入力値でタスクを登録した場合' do
      before do
        visit new_task_path
        fill_in 'Title',       with: task.title
        fill_in 'Description', with: task.description
        select task.status,    from: 'Status'
        select task.priority,  from: 'Priority'
        fill_in 'Deadline',    with: Time.current.ago(1.day)
      end

      it 'タスクが登録されないこと' do  
        expect { click_button 'Save' }.to change(Task, :count).by(0)
      end
    end
  end

  describe 'タスクの更新' do
    let!(:task) { FactoryBot.create(:task) }
    context '正常な入力値でタスクを登録した場合' do
      before do
        visit edit_task_path(task)
        fill_in 'Title', with: 'edited'
        click_button 'Save'
      end

      it 'タスクが更新されること' do
        expect(Task.find(task.id).title).to eq 'edited'
      end
    end

    context '異常な入力値でタスクを更新した場合' do
      before do
        visit edit_task_path(task)
        fill_in 'Title',    with: 'edited'
        fill_in 'Deadline', with: Time.current.ago(1.day)
        click_button 'Save'
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
      expect { first('tbody tr').click_link 'Destroy' }.to change(Task, :count).by(-1)
    end
  end
end
