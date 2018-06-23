require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'Modeling' do
    let(:group) { FactoryBot.create(:group) }
    subject { group.valid? }

    context 'エラーとならない場合' do
      it '正常な値が設定' do
        is_expected.to eq true
      end
    end

    context 'エラーとなる場合' do
      it '名前が未設定' do
        group.name = nil
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーション' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:group) { FactoryBot.create(:group) }
    let!(:user_group) { FactoryBot.create(:user_group, group: group, user: user) }

    it '紐づくUserが取得出来ること' do
      expect(group.users.first).to eq user
    end
  end
end
