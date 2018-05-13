require 'rails_helper'
RSpec.describe 'ユーザー 一覧・詳細', type: :feature, js: true do
  let!(:user1) { FactoryBot.create(:user, name: 'test_user_1') }
  let!(:user2) { FactoryBot.create(:user, name: 'test_user_2') }
  let!(:user3) { FactoryBot.create(:user, name: 'test_user_3') }
  let!(:current_user)  { FactoryBot.create(:user) }

  before do
    visit login_path
    fill_in User.human_attribute_name(:email),    with: current_user.email 
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('user_sessions.new.submit')
  end

  describe '一覧' do
    before { visit users_path }

    it '表示されること' do
      expect(page).to have_content user1.name
      expect(page).to have_content user2.name
      expect(page).to have_content user3.name
    end
  end

  describe '詳細' do
    let!(:task) { FactoryBot.create(:task, user: user1) }
    before { visit user_path(user1) }

    it '詳細が表示されること' do
      expect(page).to have_content user1.name
    end

    it '紐づくタスクの情報が表示されること' do
      expect(page).to have_content task.title
    end
  end
end
