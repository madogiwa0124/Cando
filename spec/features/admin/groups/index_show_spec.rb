require 'rails_helper'
RSpec.describe 'グループ 一覧・詳細', type: :feature, js: true do
  let!(:group1) { FactoryBot.create(:group, name: 'test_group_1') }
  let!(:group2) { FactoryBot.create(:group, name: 'test_group_2') }
  let!(:group3) { FactoryBot.create(:group, name: 'test_group_3') }
  let!(:current_user) { FactoryBot.create(:user, :admin) }

  before do
    visit login_path
    fill_in User.human_attribute_name(:email),    with: current_user.email
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('user_sessions.new.submit')
  end

  describe '一覧' do
    before { visit admin_groups_path }

    it '表示されること' do
      expect(page).to have_content group1.name
      expect(page).to have_content group2.name
      expect(page).to have_content group3.name
    end
  end

  describe '詳細' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:user_group) { FactoryBot.create(:user_group, group: group1, user: user) }
    before { visit admin_group_path(group1) }

    it '詳細が表示されること' do
      expect(page).to have_content group1.name
    end

    it '紐づくユーザーが表示されること' do
      expect(page).to have_content user.name
    end
  end
end
