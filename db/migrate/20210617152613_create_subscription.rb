class CreateSubscription < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :question
      t.belongs_to :user

      t.timestamps
    end
  end
end
