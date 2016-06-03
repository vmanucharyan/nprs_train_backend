class AddTraceToSourceImage < ActiveRecord::Migration
  def up
    add_attachment :source_images, :trace
  end

  def down
    remove_attachment :source_images, :trace
  end
end
