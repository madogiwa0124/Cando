require 'rails_helper'
RSpec.describe 'グループの登録・更新・削除', type: :feature, js: true do
  let!(:current_user) { FactoryBot.create(:user, :admin) }

  before do
    visit login_path
    fill_in User.human_attribute_name(:email),    with: current_user.email
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('user_sessions.new.submit')
  end

  describe '登録' do
    let(:group) { FactoryBot.build(:group) }
    context '正常な入力値で登録した場合' do
      before { visit new_admin_group_path }

      it '登録されること' do
        fill_in Group.human_attribute_name(:name), with: group.name
        expect { click_button I18n.t('common.save') }.to change(Group, :count).by(1)
      end
    end

    context '異常な入力値で登録した場合' do
      before { visit new_admin_user_path }

      it '登録されないこと' do
        fill_in Group.human_attribute_name(:name), with: ''
        expect { click_button I18n.t('common.save') }.to change(Group, :count).by(0)
      end
    end
  end

  describe '更新' do
    let!(:group) { FactoryBot.create(:group) }
    context '正常な入力値で更新した場合' do
      before do
        visit edit_admin_group_path(group)
        fill_in Group.human_attribute_name(:name), with: 'edited'
        click_button I18n.t('common.save')
      end

      it '更新されること' do
        expect(Group.find(group.id).name).to eq 'edited'
      end
    end

    context '異常な入力値で更新した場合' do
      before do
        visit edit_admin_group_path(group)
        fill_in Group.human_attribute_name(:name), with: ''
        click_button I18n.t('common.save')
      end

      it '更新されないこと' do
        expect(Group.find(group.id).name).to eq group.name
      end
    end
  end

  describe '削除' do
    let!(:group) { FactoryBot.create(:group) }
    before { visit admin_groups_path }

    it '削除されること' do
      expect { first('tbody tr').click_link I18n.t('common.destroy') }.to change(Group, :count).by(-1)
    end
  end
end
