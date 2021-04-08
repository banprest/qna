class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :reward_title, null: false
      t.string :image, null: false
      t.belongs_to :question
      t.belongs_to :user, optional: true

      t.timestamps
    end
  end
end
