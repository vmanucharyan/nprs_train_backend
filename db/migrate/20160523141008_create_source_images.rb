class CreateSourceImages < ActiveRecord::Migration
  def change
    create_table :source_images do |t|
      t.timestamps null: false
    end
  end
end
