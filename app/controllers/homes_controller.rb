class HomesController < ApplicationController
  before_action :authenticate_user!

  # 予約情報取得
  def index
    @reservations = Reservation.includes(schedule: %i[movie screen])
                               .where(email: current_user.email)
                               .where(movies: { is_showing: true })
                               .references(:movies)

    @name = current_user.name

    # 統計情報を取得（30日間の映画人気ランキング）
    before_30_day = Date.today - 31.day
    today = Date.today
    @reservations_ranking = Ranking.where(date: before_30_day...today)
                                   .joins(:movie)
                                   .group(:movie_id)
                                   .select('movie_id, SUM(rankings.count) as total_count')
                                   .order('total_count DESC')
  end
end
