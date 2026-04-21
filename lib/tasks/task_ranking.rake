namespace :task_ranking do
  task yesterday_day_reservation: :environment do
    # 前日のみ
    yesterday = Date.today - 1.day
    reservations = Reservation.includes(schedule: %i[movie screen])
                              .where(date: yesterday)
                              .references(:movies)
                              .group('movie_id')
                              .count
    reservations.each do |movie_id, reservation_count|
      ranking_d = Ranking.find_or_create_by(date: yesterday, movie_id: movie_id)
      ranking_d.update(count: reservation_count)
    end
  end

  task monthly_day_reservation: :environment do
    # 1ヶ月のみ
    (1..31).each do |i|
      target_day = Date.today - i.day
      reservations = Reservation.includes(schedule: %i[movie screen])
                                .where(date: target_day)
                                .references(:movies)
                                .group('movie_id')
                                .count

      reservations.each do |movie_id, reservation_count|
        ranking_d = Ranking.find_or_create_by(date: target_day, movie_id: movie_id)
        ranking_d.update(count: reservation_count)
      end
    end
  end
end
