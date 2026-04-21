module Admin
  class RoomsController < ApplicationController
    # 部屋一覧表示
    def index
      @site = Site.find(params[:site_id])
      @rooms = Room.where(site_id: params[:site_id])
    end

    # 部屋追加
    def new
      @site = Site.find(params[:site_id])
      @room = Room.new
    end

    def create
      @site = Site.find(params[:site_id])
      @room = Room.new(room_params.merge(site_id: params[:site_id]))

      if @room.save
        redirect_to admin_site_rooms_path(params[:site_id]), status: 302
      else
        # 失敗時
        render :new, status: :bad_request
      end
    end

    def show
      @site = Site.find(params[:site_id])
      @room = Room.find(params[:id])
    end

    def update
      @site = Site.find(params[:site_id])
      @room = Room.find(params[:id])
      begin
        if @room.update(room_params.merge(site_id: params[:site_id]))
          redirect_to admin_site_rooms_path(params[:site_id]), status: 302
        else
          render :edit, status: :unprocessable_entity
        end
      rescue StandardError
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      ActiveRecord::Base.transaction do
        @room = Room.find(params[:id])

        Reservation.joins(schedule: :screen)
                   .where(screens: { room_id: @room.id })
                   .destroy_all
        Schedule.joins(:screen)
                .where(screens: { room_id: @room.id })
                .destroy_all
        Screen.where(room_id: @room.id).destroy_all
        @room.destroy!
      end

      redirect_to admin_site_rooms_path(params[:site_id]), notice: '削除しました'
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end

    private

    # 検証
    def room_params
      params.require(:room).permit(:screen_number)
    end
  end
end
