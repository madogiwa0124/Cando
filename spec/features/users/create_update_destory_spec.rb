require 'rails_helper'
RSpec.describe 'ユーザーの登録・更新・削除', type: :feature, js: true do
  let!(:current_user) { FactoryBot.create(:user) }

  before do
    visit login_path
    fill_in User.human_attribute_name(:email),    with: current_user.email
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('user_sessions.new.submit')
  end

  describe '更新' do
    context '自分自身を更新する場合' do
      context '正常な入力値で更新した場合' do
        before do
          visit edit_user_path(current_user)
          fill_in User.human_attribute_name(:name), with: 'edited'
          click_button I18n.t('common.save')
        end

        it '更新されること' do
          expect(User.find(current_user.id).name).to eq 'edited'
        end
      end

      context '異常な入力値で更新した場合' do
        before do
          visit edit_user_path(current_user)
          fill_in User.human_attribute_name(:name), with: ''
          click_button I18n.t('common.save')
        end

        it '更新されないこと' do
          expect(User.find(current_user.id).name).to eq current_user.name
        end
      end
    end

    context '自分以外のユーザーを更新する場合' do
      let!(:user) { FactoryBot.create(:user) }
      before { visit edit_user_path(user) }

      it '詳細画面に遷移すること' do
        expect(current_path).to eq user_path(user)
      end
    end
  end
end
