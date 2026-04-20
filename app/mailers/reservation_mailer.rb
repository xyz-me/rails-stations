class ReservationMailer < ApplicationMailer

  def send_reservation(reservation)
    @reservation =Reservation.includes(schedule: [:movie, :screen])
                           .where(id: reservation.id)
                           .where(movies: { is_showing: true })
                           .references(:movies).first
    mail(to: @reservation.email, subject: "【テスト環境】映画の予約が完了しました")
  end
end
