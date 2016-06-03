class AddProcessedToSourceImage < ActiveRecord::Migration
  def change
    add_column :source_images, :processed, :boolean, null: false, default: false
  end
end
