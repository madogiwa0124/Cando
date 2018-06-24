class TasksController < ApplicationController
  before_action :require_login
  before_action :only_same_group_editable, only: %i[edit update destroy]

  TASKS_DISPLAY_PER_PAGE = 10

  def index
    prepare_search_attr
    @expired_tasks = Task.expired.where(user_id: current_user.id)
    @tasks = Kaminari.paginate_array(prepare_tasks)
                     .page(params[:page]).per(TASKS_DISPLAY_PER_PAGE)
  end

  def search
    prepare_search_attr
    @expired_tasks = Task.expired.where(user_id: current_user.id)
    @tasks = Task.search(@search_attr)
                 .order(order_string)
                 .includes(:labels, user: :group)
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
    @task = Task.new(task_params_with_out_label_list)
    @task.owner = current_user
    @task.label_list.add(prepare_params[:label_list], parse: true)
    if @task.save
      redirect_to @task, notice: message('task', 'create')
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    prepare_update_task
    if @task.save
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

  def prepare_tasks
    if current_user.group.present?
      Task.with_group(current_user.group)
    else
      current_user.tasks
    end.order(order_string).includes(:labels)
  end

  def prepare_update_task
    @task.attributes = task_params_with_out_label_list
    @task.label_list.add(prepare_params[:label_list], parse: true)
    @task.file.attach(params[:task][:file])
  end

  def order_string
    return 'tasks.created_at DESC' unless params.key?(:order)
    order_params.to_h.map { |key, val| "#{key} #{val.upcase}" }.join(',')
  end

  def prepare_params
    tasks_params = task_params.to_h.delete_if { |_key, val| val.blank? }
    tasks_params[:label_list] = task_params[:label_list].split(',') if task_params[:label_list].present?
    tasks_params
  end

  def prepare_search_attr
    @search_attr = { title: '', label_list: [] }
    @search_attr = prepare_params if params.key? :task
    @search_attr
  end

  def only_same_group_editable
    redirect_to tasks_path unless Task.find(params[:id]).editable?(current_user)
  end

  def task_params_with_out_label_list
    params.require(:task).permit(:title, :description, :status, :priority, :deadline, :user_id, :file)
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :deadline, :user_id, :label_list, :file)
  end

  def order_params
    params.require(:order).permit(:deadline, :priority)
  end
end
