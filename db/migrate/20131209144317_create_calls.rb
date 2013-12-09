class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :message
      t.string :to

      t.timestamps
    end
  end
end
