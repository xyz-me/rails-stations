class Admin::SchedulesController < ApplicationController
  def index
    @movies = Movie.includes(:schedules).order(:id)
  end

  def show
    @schedule = Schedule.find(params[:id])
    @movie = Movie.find(@schedule.movie_id)
  end

 # 新規追加（スケジュール）
  def new
    @schedule = Schedule.new
    @movie = Movie.find(params[:movie_id])
  end

  def create
    @schedule = Schedule.new(schedule_params)
    begin 
      if @schedule.save
        redirect_to admin_movies_path
      else
        render :new, status: :unprocessable_entity
      end
    rescue => e # 例外オブジェクトを代入した変数。
      render :new, status: :unprocessable_entity
    end
  end

  def update
    logger.info "debug update"

    @schedule = Schedule.find(params[:id])
    begin 
      if @schedule.update(schedule_params)
        redirect_to admin_schedules_path
      else
        render :edit, status: :unprocessable_entity
      end
    rescue => e # 例外オブジェクトを代入した変数。
      logger.info e.message
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @schedule = Schedule.find(params[:id])
    @schedule.destroy
    redirect_to admin_schedules_path
  end

  private
    # 検証
    def schedule_params
      params.require(:schedule).permit(:movie_id ,:start_time, :end_time)
    end
end
