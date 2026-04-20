# frozen_string_literal: true

module Admin
  class SchedulesController < ApplicationController
    def index
      @movies = Movie.includes(schedules: :screen).order(:id)
    end

    def show
      @schedule = Schedule.find(params[:id])
      @movie = Movie.find(@schedule.movie_id)
      @screen_numbers = [1, 2, 3]
      select_screen_number_result = Screen.where(schedule_id: @schedule.id).limit(1)
      @select_screen_number = if select_screen_number_result.empty?
                                1
                              else
                                select_screen_number_result.first.screen_number
                              end
    end

    # 新規追加（スケジュール）
    def new
      @schedule = Schedule.new
      @movie = Movie.find(params[:movie_id])
      @screen_numbers = [1, 2, 3]
    end

    def create
      # @schedule = Schedule.new(schedule_params)
      # @screen = Screen.new(scene_params)

      # トランザクション処理
      ActiveRecord::Base.transaction do
        @schedule = Schedule.create!(schedule_params)
        @screen = Screen.create!(scene_params.merge(schedule_id: @schedule.id))
      end
      redirect_to admin_movies_path

      # ロールバック
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end

    def update
      # トランザクション処理
      ActiveRecord::Base.transaction do
        @schedule = Schedule.find(params[:id])
        @screen = Screen.where(schedule_id: @schedule.id).limit(1)

        @schedule.update!(schedule_params)
        if @screen.length.positive?
          @screen.update!(scene_params.merge(schedule_id: @schedule.id))
        else
          # データの不整合が発生していた場合は新規作成
          @screen = Screen.create!(scene_params.merge(schedule_id: @schedule.id))
        end
      end
      redirect_to admin_schedules_path

      # ロールバック
    rescue ActiveRecord::RecordInvalid
      render :edit, status: :unprocessable_entity
    end

    def destroy
      # トランザクション処理
      ActiveRecord::Base.transaction do
        @schedule = Schedule.find(params[:id])
        @screen = Screen.where(schedule_id: @schedule.id).limit(1)
        @screen.first.destroy if @screen.length.positive?
        @schedule.destroy
      end
      redirect_to admin_schedules_path

      # ロールバック
    rescue ActiveRecord::RecordInvalid
      render :edit, status: :unprocessable_entity
    end

    private

    # 検証
    def schedule_params
      params.require(:schedule).require(:schedule).permit(:movie_id, :start_time, :end_time)
    end

    def scene_params
      params.require(:schedule).require(:screen).permit(:screen_number)
    end
  end
end
