require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Task Modeling' do
    let!(:user) { FactoryBot.create(:user) }
    let(:task) { FactoryBot.build(:task, owner: user) }
    subject { task.valid? }

    context 'エラーとならない場合' do
      it '正常な値が設定' do
        is_expected.to eq true
      end
    end

    context 'エラーとなる場合' do
      it 'タイトルが未設定' do
        task.title = nil
        is_expected.to eq false
      end

      it 'ステータスが未設定' do
        task.status = nil
        is_expected.to eq false
      end

      it 'ステータスが未定義の値' do
        task.status = nil
        is_expected.to eq false
      end

      it '重要度が未設定' do
        task.priority = nil
        is_expected.to eq false
      end

      it '重要度が未定義の値' do
        task.priority = nil
        is_expected.to eq false
      end

      it '期限が過去日' do
        task.deadline = Time.current.ago(1.day)
        is_expected.to eq false
      end

      it '作成者が未設定' do
        task.owner_id = nil
        is_expected.to eq false
      end
    end

    context 'アソシエーション' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:owner) { FactoryBot.create(:user) }
      let(:task) { FactoryBot.build(:task, user: user, owner: owner) }
      it '紐づくユーザーが取得出来ること' do
        expect(task.user).to eq user
      end

      it '作成者に紐づくユーザーが取得できること' do
        expect(task.owner).to eq owner
      end
    end
  end

  describe 'label' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, :with_label, owner: user) }

    it 'ラベルが設定出来ること' do
      expect { task.label_list.add('label') }.to change(task.label_list, :length).by(1)
    end

    it '設定されたラベルが取得出来ること' do
      expect(task.label_list.present?).to eq true
    end
  end

  describe '.search' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task1) { FactoryBot.create(:task, :with_label, title: 'タイトル_1', owner: user) }
    let!(:task2) { FactoryBot.create(:task, title: 'タイトル_10', status: Task.statuses[:done], owner: user) }
    let!(:task3) { FactoryBot.create(:task, title: 'タイトル_2', owner: user) }
    let!(:task4) { FactoryBot.create(:task, :with_label, title: 'タイトル_11', owner: user) }

    it '正しい検索結果となること※title like param AND status=param' do
      attr = { title: task1.title, status: task1.status, label_list: task1.label_list }
      expect(Task.search(attr).pluck(:title)).to match_array [task4.title, task1.title]
    end
  end

  describe '.with_group' do
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }
    let!(:user3) { FactoryBot.create(:user) }
    let!(:user4) { FactoryBot.create(:user) }
    let!(:group1) { FactoryBot.create(:group) }
    let!(:group2) { FactoryBot.create(:group) }
    let!(:user_group1) { FactoryBot.create(:user_group, group: group1, user: user1) }
    let!(:user_group2) { FactoryBot.create(:user_group, group: group1, user: user3) }
    let!(:user_group3) { FactoryBot.create(:user_group, group: group2, user: user2) }
    let!(:task1) { FactoryBot.create(:task, title: 'タイトル_1', user: user1, owner: user1) }
    let!(:task2) { FactoryBot.create(:task, title: 'タイトル_2', user: user2, owner: user2) }
    let!(:task3) { FactoryBot.create(:task, title: 'タイトル_3', user: user3, owner: user3) }
    let!(:task4) { FactoryBot.create(:task, title: 'タイトル_4', user: user4, owner: user4) }

    it '自分の所属グループのタスクが取得されること' do
      expect(Task.with_group(user1.group).pluck(:title)).to match_array [task1.title, task3.title]
    end
  end

  describe '#editable?' do
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }
    let!(:user3) { FactoryBot.create(:user) }
    let!(:user4) { FactoryBot.create(:user) }
    let!(:admin_user) { FactoryBot.create(:user, :admin) }
    let!(:group1) { FactoryBot.create(:group) }
    let!(:group2) { FactoryBot.create(:group) }
    let!(:user_group1) { FactoryBot.create(:user_group, group: group1, user: user1) }
    let!(:user_group2) { FactoryBot.create(:user_group, group: group1, user: user3) }
    let!(:user_group3) { FactoryBot.create(:user_group, group: group2, user: user2) }
    let!(:task1) { FactoryBot.create(:task, title: 'タイトル_1', user: user1, owner: user1) }
    let!(:task2) { FactoryBot.create(:task, title: 'タイトル_2', user: user2, owner: user2) }
    let!(:task3) { FactoryBot.create(:task, title: 'タイトル_3', user: user3, owner: user3) }
    let!(:task4) { FactoryBot.create(:task, title: 'タイトル_4', user: user4, owner: user4) }

    context '紐づくユーザーが管理者の場合' do
      it 'すべてのタスクが編集可能なこと' do
        expect(task1.editable?(admin_user)).to eq true
        expect(task2.editable?(admin_user)).to eq true
        expect(task3.editable?(admin_user)).to eq true
        expect(task4.editable?(admin_user)).to eq true
      end
    end

    context '紐づくユーザーがグループに属している場合' do
      it '同じグループのタスクが編集出来ること' do
        expect(task1.editable?(user1)).to eq true
        expect(task3.editable?(user1)).to eq true
      end
      it '違うグループのタスクが編集出来ないこと' do
        expect(task2.editable?(user1)).to eq false
      end
    end

    context '紐づくユーザーがグループに所属していない場合' do
      it '自分のタスクが編集出来ること' do
        expect(task4.editable?(user4)).to eq true
      end
      it '他者のタスクが編集出来ないこと' do
        expect(task1.editable?(user4)).to eq false
      end
    end
  end
end
