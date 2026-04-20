class HomesController < ApplicationController
  before_action :authenticate_user!

  # 予約情報取得
  def index
    @reservations = Reservation.includes(schedule: [:movie, :screen])
                           .where(email: current_user.email)
                           .where(movies: { is_showing: true })
                           .references(:movies)

    @name = current_user.name
  end
end
