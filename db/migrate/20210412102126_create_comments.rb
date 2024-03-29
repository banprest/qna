class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :body, null: false
      t.belongs_to :user
      t.belongs_to :commentable, polymorphic: true

      t.timestamps
    end
  end
end
