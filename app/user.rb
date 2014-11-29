class User < Courier::Base
  conflict_policy :overwrite_local

  has_many :posts, as: :posts, on_delete: :cascade, inverse_name: :user

  property :id, Integer32, required: true, key: true
  property :full_name, String

  self.json_to_local = {
    :id => :id,
    :name => :full_name,
  }
  self.collection_path = "users"
  self.individual_path = "users/:id"
end
