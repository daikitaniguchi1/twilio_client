class Call < ActiveRecord::Base
  validates_presence_of :to
  validates_presence_of :message
end
