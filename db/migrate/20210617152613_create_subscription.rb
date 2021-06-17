class CreateSubscription < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.boolean :notification, default: true
      t.belongs_to :question
      t.belongs_to :user

      t.timestamps
    end
  end
end
