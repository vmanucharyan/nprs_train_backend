class AddLockedAndLockIdToSourceImage < ActiveRecord::Migration
  def change
    add_column :source_images, :locked, :boolean, null: false, default: false
    add_column :source_images, :lock_id, :string, null: true
    add_column :source_images, :locked_at, :datetime, null: true
  end
end
