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
end
