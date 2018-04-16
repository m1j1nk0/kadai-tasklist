class TasksController < ApplicationController
  
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  
  
  def index
    if logged_in?
      @tasks = current_user.tasks.order("created_at DESC")
    end
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def new
    @task = current_user.tasks.build
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = "タスクが正常に登録されました"
      redirect_to @task
    else
      flash.now[:danger] = "タスクが正常に登録されませんでした"
      render :new
    end
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = "タスクが正常に更新されました"
      redirect_to @task
    else
      flash.now[:danger] = "タスクが正常に更新されませんでした"
      render :edit
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    
    flash[:success] = "削除されました"
    redirect_to tasks_url
  end
  
  
  private
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      flash[:danger] = "不正なアクセスです"
      redirect_to login_path
    end
  end
  
end
