class Admin::MoviesController < ApplicationController
  # 表示
  def index
    @movies = Movie.all
  end

  # 表示
  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new

    # render status: :found 
  end

  # 新規追加
  def create
    @movie = Movie.new(movie_params)
    begin 
      if @movie.save
        redirect_to admin_movies_path
      else
        render :new, status: :unprocessable_entity
      end
    rescue => e # 例外オブジェクトを代入した変数。
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    begin 
      if @movie.update(movie_params)
        redirect_to admin_movies_path
      else
        render :edit, status: :unprocessable_entity
      end
    rescue => e # 例外オブジェクトを代入した変数。
      render :new, status: :unprocessable_entity
    end
  end

  # 削除
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to admin_movies_path
  end
    

  private
    # 検証
    def movie_params
      params.require(:movie).permit(:name,:year, :description, :image_url, :is_showing)
    end
end