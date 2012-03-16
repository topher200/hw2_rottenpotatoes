class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    [:sort_by, :ratings].each do |param|
      if params[param] != nil
        # User set the param, save and use the new one
        session[param] = params[param]
      elsif session[param] != nil
        # User set a ratings filter before, but it didn't come through this
        # time. Add it to the URL and try again.
        redirect_to movies_path(:ratings => session[:ratings],
                                :sort_by => session[:sort_by])
      end
    end
    
    @all_ratings = ['G','PG','PG-13','R','NC-17']

    # Get all movies that match the desired ratings filter
    @checked_ratings = params[:ratings]
    @movies = Movie.movies_with_ratings(@checked_ratings)

    # Sort the movies
    sort_by = params[:sort_by]
    if ['title', 'release_date'].include?(sort_by)
      @movies = @movies.sort { |x,y| x[sort_by] <=> y[sort_by] }
    end
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

end
