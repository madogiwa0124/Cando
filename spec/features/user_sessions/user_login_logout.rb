require 'rails_helper'
RSpec.describe 'ユーザーログイン・ログアウト', type: :feature, js: true do
  let!(:current_user) { FactoryBot.create(:user) }

  describe 'ログイン' do
    before { visit login_path }

    context '正常な値が入力された場合' do
      it '成功すること' do
        fill_in User.human_attribute_name(:email),    with: current_user.email
        fill_in User.human_attribute_name(:password), with: 'password'
        click_button I18n.t('user_sessions.new.submit')
        expect(page).to have_content I18n.t('message.login.success')
      end
    end

    context '異常な値が入力された場合' do
      it '失敗すること' do
        fill_in User.human_attribute_name(:email),    with: current_user.email
        fill_in User.human_attribute_name(:password), with: 'wrong_password'
        click_button I18n.t('user_sessions.new.submit')
        expect(page).to have_content I18n.t('message.login.failed')
      end
    end
  end

  describe 'ログアウト' do
    before do
      visit login_path
      fill_in User.human_attribute_name(:email),    with: current_user.email
      fill_in User.human_attribute_name(:password), with: 'password'
      click_button I18n.t('user_sessions.new.submit')
    end

    it '正常終了すること' do
      click_link I18n.t('user_sessions.destroy.link')
      expect(page).to have_content I18n.t('message.logout.success')
    end
  end
end
