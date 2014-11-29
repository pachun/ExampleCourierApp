class Post < Courier::Base
  belongs_to :user, as: :user, on_delete: :nullify, inverse_name: :posts

  property :id, Integer32, required: true, key: true
  property :title, String
  property :body, String

  self.json_to_local = {
    :id => :id,
    :title => :title,
    :body => :body,
  }
  self.collection_path = "posts"
  self.individual_path = "posts/:id"
end
