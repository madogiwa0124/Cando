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
        task.deadline = Time.current.ago(1.second)
        is_expected.to eq false
      end
    end
  end
end
