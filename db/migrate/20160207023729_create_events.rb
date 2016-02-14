class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.time :date
      t.string :user
      t.string :action
      t.string :otheruser

      t.timestamps null: false
    end
  end
end
