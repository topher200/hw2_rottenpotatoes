class Movie < ActiveRecord::Base
  def self.movies_with_ratings(ratings)
    if ratings
      self.where(:rating => ratings.keys)
    else
      self.all
    end
  end
end
