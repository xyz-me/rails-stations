class MoviesController < ApplicationController
  def index
    # パラメータを取得
    @keyword = params[:keyword]
    @is_public = params[:is_showing]

    # is_publicが"true"または"false"であるか？（未指定またはその他）
    $public = -1
    if @is_public == "1"
      $public = 1 # 公開あり
    elsif  @is_public == "0"
      $public = 0 #　公開あり
    else
      $public = -1 # 未指定
    end

    # パラメータに文字列があるかを判定
    if @keyword != nil && !@keyword.empty?
      if $public != -1
        @movies = Movie.where("name LIKE ?", "%" + @keyword +  "%").or(Movie.where("description LIKE ?", "%" + @keyword +  "%")). where(is_showing: $public)
      else
         @movies = Movie.where("name LIKE ?", "%" + @keyword +  "%").or(Movie.where("description LIKE ?", "%" + @keyword +  "%"))
      end
    else
      if $public != -1
        @movies = Movie.where(is_showing: $public)
      else
        @movies = Movie.all
      end
    end
  end

  def show
    @movie = Movie.find(params[:id])
    @schedules = Schedule.where(movie_id: params[:id]).order(:start_time)

    # 1週間のリストを作成
    @today = Date.today
    @one_week_list = []

    for num in 0..6 do
      target = @today + num.day
      @one_week_list.push([target.strftime("%Y-%m-%d"), target.strftime("%Y-%m-%d %H:%M:%S")])
    end

    @reservation = Reservation.new
  end

  def reservation
    # パラメータがない場合は遷移（302エラー）
    if !params.has_key?(:date)
      redirect_to movies_path, alert: "スケジュールが見つかりませんでした。"
      return 
    end

    @date_input = params[:date] # 日付を受け取る(YYYY-MM-DD HH:MM)
    unless @date_input&.match?(/\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\z/) 
      # redirect_to movies_path,  alert: "日付がない"
    end

    @movie =  Movie.find(params[:id])
    

    @date = Time.parse(@date_input).strftime("%Y-%m-%d")

    @schedule = Schedule.find_by(id: params[:schedule_id])
    if @schedule.nil?
      redirect_to movies_path, alert: "スケジュールが見つかりませんでした。"
    else
      @schedule_id = @schedule.id
    end

    #@schedule = Schedule.find(params[:schedule_id])
    

    @sheets = Sheet.all

    # 配列に変換
    @sheets_array = [] # 最終結果
    $tmp_array = [] # 一時保存
    
    @sheets.each_with_index do |sheet, i|
      if i > 0 && @sheets[i - 1]["row"] != @sheets[i]["row"]
        # rowが変わるタイミングで$tmp_arrayをsheets_arrayに挿入
        @sheets_array.push($tmp_array)
        $tmp_array = []
      end
      $tmp_array.push(@sheets[i])
    end

    if $tmp_array.length != 0
      @sheets_array.push($tmp_array)
    end
  end

  def new
    @movie =  Movie.find(params[:movie_id])
    @schedule =  Movie.find(params[:schedule_id])
  end
end