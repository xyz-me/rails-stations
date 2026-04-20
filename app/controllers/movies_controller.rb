# frozen_string_literal: true

class MoviesController < ApplicationController
  def index
    # パラメータを取得
    @keyword = params[:keyword]
    @is_public = params[:is_showing]

    # is_publicが"true"または"false"であるか？（未指定またはその他）
    public = if @is_public == '1'
               1 # 公開あり
             elsif @is_public == '0'
               0 # 　公開あり
             else
               -1 # 未指定
             end

    # パラメータに文字列があるかを判定
    @movies = if !@keyword.nil? && !@keyword.empty?
                if public != -1
                  Movie.where('name LIKE ?',
                              "%#{@keyword}%").or(Movie.where('description LIKE ?',
                                                              "%#{@keyword}%")).where(is_showing: public)
                else
                  Movie.where('name LIKE ?',
                              "%#{@keyword}%").or(Movie.where('description LIKE ?', "%#{@keyword}%"))
                end
              elsif public != -1
                Movie.where(is_showing: public)
              else
                Movie.all
              end
  end

  def show
    @movie = Movie.find(params[:id])
    @schedules = Schedule.where(movie_id: params[:id]).order(:start_time)

    # 1週間のリストを作成
    @today = Date.today
    @one_week_list = []

    (0..6).each do |num|
      target = @today + num.day
      @one_week_list.push([target.strftime('%Y-%m-%d'), target.strftime('%Y-%m-%d %H:%M:%S')])
    end

    @reservation = Reservation.new
  end

  def reservation
    # パラメータがない場合は遷移（302エラー）
    unless params.key?(:date)
      redirect_to movies_path, alert: 'スケジュールが見つかりませんでした。'
      return
    end

    # dataパラメータのフォーマットチェック
    @date_input = params[:date] # 日付を受け取る(YYYY-MM-DD HH:MM)
    unless @date_input&.match?(/\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\z/)
      redirect_to movies_path, alert: 'スケジュールが見つかりませんでした。'
      return
    end

    @date = Time.parse(@date_input).strftime('%Y-%m-%d')
    @movie =  Movie.find(params[:id])
    @schedule = Schedule.find_by(id: params[:schedule_id])
    if @schedule.nil?
      redirect_to movies_path, alert: 'スケジュールが見つかりませんでした。'
    else
      @schedule_id = @schedule.id
    end

    @sheets = Sheet.all
    @reservations = Reservation.where(date: @date, schedule_id: @schedule_id)

    # 配列に変換
    @sheets_array = [] # 最終結果
    tmp_array = [] # 一時保存
    @sheets_has_reservation = []
    tmp_sheets_has_reservation = []

    @sheets.each_with_index do |_sheet, i|
      if i.positive? && @sheets[i - 1]['row'] != @sheets[i]['row']
        # rowが変わるタイミングでtmp_arrayをsheets_arrayに挿入
        @sheets_array.push(tmp_array)
        tmp_array = []
        @sheets_has_reservation.push(tmp_sheets_has_reservation)
        tmp_sheets_has_reservation = []
      end
      tmp_array.push(@sheets[i])

      if @reservations.any? { |reservation| reservation[:sheet_id] == @sheets[i].id }
        tmp_sheets_has_reservation.push(true)
      else
        tmp_sheets_has_reservation.push(false)
      end
    end

    return if tmp_array.empty?

    @sheets_array.push(tmp_array)
    @sheets_has_reservation.push(tmp_sheets_has_reservation)
  end

  def new
    @movie =  Movie.find(params[:movie_id])
    @schedule = Movie.find(params[:schedule_id])
  end
end
