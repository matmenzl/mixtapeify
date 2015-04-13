class Status < ActiveRecord::Base
	belongs_to :user
  acts_as_commentable
  acts_as_votable

  default_scope { order(:cached_weighted_score => :desc) }
end
