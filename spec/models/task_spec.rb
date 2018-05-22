require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Task Modeling' do
    let(:task) { FactoryBot.build(:task) }
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
    end

    context 'アソシエーション' do
      let!(:user) { FactoryBot.create(:user) }
      let(:task) { FactoryBot.build(:task, user: user) }
      it '紐づくユーザーが取得出来ること' do
        expect(task.user).not_to be_blank
      end
    end
  end

  describe 'label' do
    let!(:task) { FactoryBot.create(:task, :with_label) }

    it 'ラベルが設定出来ること' do
      expect { task.label_list.add('label') }.to change(task.label_list, :length).by(1)
    end

    it '設定されたラベルが取得出来ること' do
      expect(task.label_list.present?).to eq true
    end
  end

  describe '.search' do
    let!(:task1) { FactoryBot.create(:task, :with_label, title: 'タイトル_1') }
    let!(:task2) { FactoryBot.create(:task, title: 'タイトル_10', status: Task.statuses[:done]) }
    let!(:task3) { FactoryBot.create(:task, title: 'タイトル_2') }
    let!(:task4) { FactoryBot.create(:task, :with_label, title: 'タイトル_11') }

    it '正しい検索結果となること※title like param AND status=param' do
      attr = { title: task1.title, status: task1.status, label_list: task1.label_list }
      expect(Task.search(attr).pluck(:title)).to match_array [task4.title, task1.title]
    end
  end
end
