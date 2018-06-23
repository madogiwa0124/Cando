require 'rails_helper'
RSpec.describe 'ユーザーの登録・更新・削除', type: :feature, js: true do
  let!(:current_user) { FactoryBot.create(:user, :admin) }

  before do
    visit login_path
    fill_in User.human_attribute_name(:email),    with: current_user.email
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('user_sessions.new.submit')
  end

  describe '登録' do
    let(:user) { FactoryBot.build(:user) }
    let!(:group) { FactoryBot.create(:group) }
    context '正常な入力値で登録した場合' do
      before do
        visit new_admin_user_path
        fill_in User.human_attribute_name(:email),       with: user.email
        fill_in User.human_attribute_name(:name),        with: user.name
        select  Role.find_by(code: :admin).name,         from: User.human_attribute_name(:role)
        select  group.name,                              from: User.human_attribute_name(:group)
        fill_in User.human_attribute_name(:password),    with: user.password
        fill_in User.human_attribute_name(:password_confirmation), with: user.password_confirmation
      end

      it '登録されること' do
        expect { click_button I18n.t('common.save') }.to change(User, :count).by(1)
      end
    end

    context '異常な入力値で登録した場合' do
      before do
        visit new_admin_user_path
        fill_in User.human_attribute_name(:email),       with: user.email
        fill_in User.human_attribute_name(:name),        with: ''
        fill_in User.human_attribute_name(:password),    with: user.password
        select  Role.find_by(code: :admin).name,         from: User.human_attribute_name(:role)
        select  group.name,                              from: User.human_attribute_name(:group)
        fill_in User.human_attribute_name(:password_confirmation), with: user.password_confirmation
      end

      it '登録されないこと' do
        expect { click_button I18n.t('common.save') }.to change(User, :count).by(0)
      end
    end
  end

  describe '更新' do
    let!(:user) { FactoryBot.create(:user) }
    context '正常な入力値で更新した場合' do
      before do
        visit edit_admin_user_path(user)
        fill_in User.human_attribute_name(:name), with: 'edited'
        click_button I18n.t('common.save')
      end

      it '更新されること' do
        expect(User.find(user.id).name).to eq 'edited'
      end
    end

    context '異常な入力値で更新した場合' do
      before do
        visit edit_admin_user_path(user)
        fill_in User.human_attribute_name(:name), with: ''
        click_button I18n.t('common.save')
      end

      it '更新されないこと' do
        expect(User.find(user.id).name).to eq user.name
      end
    end
  end

  describe '削除' do
    let!(:user) { FactoryBot.create(:user) }
    before { visit admin_users_path }

    it '削除されること' do
      expect { first('tbody tr').click_link I18n.t('common.destroy') }.to change(User, :count).by(-1)
    end
  end
end
