class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def search
    prepare_search_attr
    @tasks = Task.where(@search_attr)
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
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  private

  def prepare_search_attr
    @search_attr = task_params
    # 未指定の場合は検索条件から削除
    @search_attr.delete_if {|_key, val| val.blank? }
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :deadline)
  end
end
