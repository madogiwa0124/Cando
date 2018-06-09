class Admin::GroupsController < ApplicationController
  before_action :require_login
  before_action :only_admin_user

  GROUP_DISPLAY_PER_PAGE = 10

  def index
    @groups = Group.all.order(:id).page(params[:page]).per(GROUP_DISPLAY_PER_PAGE)
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to admin_group_path(@group), notice: message('group', 'create')
    else
      render :new
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to admin_group_path(@group), notice: message('group', 'update')
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_groups_url, notice: message('group', 'destroy')
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
