class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']

    session[:sort_by] = params[:sort_by]
    session[:ratings] = params[:ratings]
    
    if(params[:ratings])
      ratings = params[:ratings].keys
    else
      ratings = @all_ratings
    end
    
    @movies = Movie.where(rating: ratings)
    
    if(params[:sort_by] == 'title')
      @movies = @movies.order('title')
      @title_hilite = 'hilite'
    end
    
    if(params[:sort_by] == 'date')
      @movies = @movies.order('release_date')
      @release_hilite = 'hilite'
    end
    
    if session[:ratings] != params[:ratings] || session[:sort] != params[:sort]
      flash.keep
      redirect_to movies_path(ratings: session[:ratings], sort: session[:sort])
    end
    
  end
  

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
