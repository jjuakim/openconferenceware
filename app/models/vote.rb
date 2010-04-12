class Vote < ActiveRecord::Base
  establish_connection :votes

  belongs_to :proposal
end
