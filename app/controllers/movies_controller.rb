class MoviesController < ApplicationController
  helper_method :sort_column, :selected_ratings

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if (params.nil? || !params.has_key?(:ratings)) && !session[:remembered_params].nil? && session[:remembered_params].has_key?(:ratings)
      redirect_to movies_path(@movie, session[:remembered_params])
    end
    # logger.info params.has_key?(:ratings) ? "true" : "false";
    # logger.info params.has_key?(:sort) ? "true" : "false";
    # logger.info "SPLIT"
    # logger.info session[:remembered_params].has_key?(:ratings) ? "true" : "false";
    # logger.info session[:remembered_params].has_key?(:sort) ? "true" : "false";
    # logger.info session[:remembered_params]
    session[:remembered_params] = params
    @movies = Movie.
      where(:rating => selected_ratings).
      order(sort_column)
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  private
  
  def sort_column
    # Movie's 'title' is default sort column
    Movie.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end
  
  def selected_ratings
    chosen_ratings = []
    if params[:ratings].nil?
      chosen_ratings = Movie.all_ratings
    else
      params[:ratings].each do |a| 
        chosen_ratings << a[0]
      end
    end
    chosen_ratings
  end

end
