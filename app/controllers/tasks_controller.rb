class TasksController < ApplicationController
  before_action :require_login

  TASKS_DISPLAY_PER_PAGE = 10

  def index
    prepare_search_attr
    @tasks = Task.all
                 .order(order_string)
                 .includes(:user)
                 .page(params[:page])
                 .per(TASKS_DISPLAY_PER_PAGE)
  end

  def search
    prepare_search_attr
    @tasks = Task.search(@search_attr)
                 .order(order_string)
                 .includes(:user)
                 .page(params[:page])
                 .per(TASKS_DISPLAY_PER_PAGE)
    render :index
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: message('task', 'create')
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to @task, notice: message('task', 'update')
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: message('task', 'destroy')
  end

  private

  def order_string
    return 'created_at DESC' unless params.key?(:order)
    order_params.to_h.map { |key, val| "#{key} #{val.upcase}" }.join(',')
  end

  def prepare_search_attr
    @search_attr = { title: '' }
    @search_attr = task_params.delete_if { |_key, val| val.blank? } if params.key?(:task)
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :deadline, :user_id)
  end

  def order_params
    params.require(:order).permit(:deadline, :priority)
  end
end
