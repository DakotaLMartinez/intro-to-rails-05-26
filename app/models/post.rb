class Post < ApplicationRecord
  belongs_to :user

  def to_param
    "#{id}-#{slug}"
  end

  def slug 
    ActiveSupport::Inflector.parameterize(title)
  end
end
