module Admin
  class SitesController < ApplicationController

    # サイト一覧表示
    def index
      @sites = Site.all
    end

    # サイト追加
    def new
      @site = Site.new
    end

    def create
      @site = Site.new(site_params)

      if @site.save
        redirect_to admin_sites_path, status: 302
      else
        # 失敗時
        render :new, status: :bad_request
      end
    end

    def show
      @site = Site.find(params[:id])
    end

    def update
      @site = Site.find(params[:id])
      begin
        if @site.update(site_params)
          redirect_to admin_sites_path
        else
          render :edit, status: :unprocessable_entity
        end
      rescue StandardError
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      ActiveRecord::Base.transaction do
        @site = Site.find(params[:id])
        Reservation.joins(schedule: { screen: :room })
                  .where(rooms: { site_id: @site.id })
                  .destroy_all
        Schedule.joins(screen: :room)
                .where(rooms: { site_id: @site.id })
                .destroy_all
        Screen.joins(:room)
              .where(rooms: { site_id: @site.id })
              .destroy_all
        Room.where(site_id: @site.id).destroy_all
        @site.destroy!
      end
      
      redirect_to admin_sites_path, notice: "削除しました"

    rescue ActiveRecord::RecordInvalid => e
      render :new, status: :unprocessable_entity
    end


    private

    # 検証
    def site_params
      params.require(:site).permit(:name)
    end
    
  end
end
