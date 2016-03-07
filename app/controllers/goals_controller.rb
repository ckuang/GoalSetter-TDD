class GoalsController < ApplicationController

  before_action :require_signed_in

  def new

  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id
    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def index
    @goals = Goal.all
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    render :index
  end

  private
  def goal_params
    params.require(:goal).permit(:title, :description, :visibility)
  end


end
