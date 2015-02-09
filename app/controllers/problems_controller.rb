class ProblemsController < ApplicationController
  before_action :require_login!, except: [ :index, :show ]

  def index
    @problems = Problem.order('updated_at DESC').page(page)
    @problems = @problems.where(difficulty_level: params[:level]) if params[:level]
  end

  def show
    @problem = Problem.friendly.find(params[:id])
    @solutions = @problem.solutions.includes(:user)
  end

  def new
    @problem = Problem.new
  end

  def create
    @problem = current_user.problems.new(problem_params)
    if @problem.save
      redirect_to @problem, notice: I18n.t('problems.create.success')
    else
      flash.now[:alert] = I18n.t("problems.create.error")
      render :new
    end
  end

  private

  def problem_params
    params.require(:problem).permit(:difficulty_level, :judge_id, :url, :title, :number, { category_ids: [ ]})
  end
end
