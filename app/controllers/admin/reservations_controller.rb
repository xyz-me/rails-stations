# frozen_string_literal: true

class Admin
  class ReservationsController < ApplicationController
    def index
      @reservations = Reservation.joins(schedule: :movie).where(movies: { is_showing: true }).includes(:schedule)
    end

    def new
      @schedules = Schedule.joins(:movie)
      @reservation = Reservation.new
      @sheets = Sheet.all

      @schedules_data = []
      @schedules.each_with_index do |_schedule, i|
        @schedules_data.push(["#{@schedules[i].movie.name} | #{@schedules[i].view_time}", @schedules[i].id])
      end
    end

    def create
      @reservation = Reservation.new(reservation_params)
      @schedule =  Schedule.find(params[:reservation][:schedule_id])
      @movie = Movie.find(@schedule.movie_id)
      @sheet = Sheet.find(params[:reservation][:sheet_id])
      @email = params[:reservation][:email]
      @date =  params[:reservation][:date]

      @schedules = Schedule.joins(:movie)
      @schedules_data = []
      @schedules.each_with_index do |_schedule, i|
        @schedules_data.push(["#{@schedules[i].movie.name} | #{@schedules[i].view_time}", @schedules[i].id])
      end
      @sheets = Sheet.all

      if @reservation.save
        redirect_to admin_reservations_path, status: 302
      else
        # 失敗時
        render :new, status: :bad_request
      end
    end

    def show
      @reservation = Reservation.find(params[:id])

      @schedules = Schedule.joins(:movie)
      @schedules_data = []
      @schedules.each_with_index do |_schedule, i|
        @schedules_data.push(["#{@schedules[i].movie.name} | #{@schedules[i].view_time}", @schedules[i].id])
      end
      @sheets = Sheet.all
    end

    def update
      @reservation = Reservation.find(params[:id])
      begin
        if @reservation.update(reservation_params)
          redirect_to admin_reservations_path
        else
          render :edit, status: :unprocessable_entity
        end
      rescue StandardError # 例外オブジェクトを代入した変数。
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @reservation = Reservation.find(params[:id])
      @reservation.destroy
      redirect_to admin_reservations_path
    end

    private

    # 検証
    def reservation_params
      params.require(:reservation).permit(:schedule_id, :sheet_id, :date, :name, :email)
    end
  end
end
