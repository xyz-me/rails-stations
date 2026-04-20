# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :authenticate_user!

  # 新規予約追加画面(GET)
  def new
    # dataがないとエラー
    unless params.key?(:date)
      redirect_to movies_path, alert: 'スケジュールが見つかりませんでした。'
      return
    end

    # sheet_idがないとエラー
    unless params.key?(:sheet_id)
      redirect_to movies_path, alert: 'スケジュールが見つかりませんでした。'
      return
    end

    # クエリパラメータの受け取り
    @sheet = Sheet.find(params[:sheet_id]) # シートIDを受け取る
    @date = params[:date] # 日付を受け取る(YYYY-MM-DD)
    @schedule = Schedule.find(params[:schedule_id]) # スケジュールIDを受け取る

    # スケジュールIDから映画情報を取得
    @movie = Movie.find(@schedule.movie_id)

    # 新規予約情報
    @reservation = Reservation.new

    # emailアドレス
    @email = current_user.email

    # 氏名
    @name = current_user.name
  end

  # 新規追加(POST)
  def create
    @reservation = Reservation.new(reservation_params.merge(email: current_user.email, name: current_user.name))
    @schedule =  Schedule.find(params[:reservation][:schedule_id])
    @movie = Movie.find(@schedule.movie_id)
    @sheet = Sheet.find(params[:reservation][:sheet_id])

    if @reservation.save
      redirect_to movie_path(@movie.id), status: 302
    else
      # 失敗時
      redirect_to "/movies/#{@movie.id}/reservation?schedule_id=#{params[:reservation][:schedule_id]}&date=#{params[:reservation][:date]}",
                  status: 302

      # redirect_to movie_reservations_path(
      #  @movie.id,
      #  schedule_id: params[:reservation][:schedule_id],
      #  date: params[:reservation][:date]
      # ), status: 302
    end
  end

  private

  # 検証
  def reservation_params
    params.require(:reservation).permit(:schedule_id, :sheet_id, :date)
  end
end
