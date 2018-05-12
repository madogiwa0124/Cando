require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User Modeling' do
    let(:user) { FactoryBot.build(:user) }
    subject { user.valid? }

    context 'エラーとならない場合' do
      it '正常な値が設定' do
        is_expected.to eq true
      end
    end

    context 'エラーとなる場合' do
      it 'メールアドレスが未設定' do
        user.email = nil
        is_expected.to eq false
      end

      it 'メールアドレスが文字数超過' do
        user.email = 'a' * 255 + '@test.com'
        is_expected.to eq false
      end

      it 'メールアドレスが不正' do
        user.email = '@test.com'
        is_expected.to eq false
        user.email = 'aaaaaaa'
        is_expected.to eq false
      end

      it 'メールアドレスが重複' do
        user.save
        invalid_user = FactoryBot.build(:user, email: user.email)
        expect(invalid_user.valid?).to eq false
      end

      it '名前が未設定' do
        user.name = nil
        is_expected.to eq false
      end

      it '名前が文字数超過' do
        user.name = 'a' * 256
        is_expected.to eq false
      end
    end

    context "アソシエーション" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:task) { FactoryBot.create(:task, user: user) }
      it '紐づくタスクが取得出来ること' do
        expect(user.tasks).not_to be_blank
      end
    end
  end
end
