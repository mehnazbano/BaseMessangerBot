class BlogpostsController < ApplicationController
  before_action :authenticate_user!
  def new
    @blogpost = Blogpost.new
  end

  def create
  	@blogpost = Blogpost.create(params.require(:blogpost).permit(:title, :description, :tags, :location))
  	@blogpost.save
  	redirect_to @blogpost
  end

  def index
  	@blogposts = Blogpost.all
  end

  def delete_content
    p "indise"
    respond_to do |format|
      format.js
    end 
  end

  def show
  	@blogpost = Blogpost.where(id: params[:id]).first
  end

  def get_locations
    sql_like_query = "%#{params[:search]}%"
    @locations = Location.where({:name.matches => sql_like_query})
  end

  def get_location_code
    location_id = params[:location].to_i
    data = Location.where(id: location_id).first
    render json: data
  end
end
