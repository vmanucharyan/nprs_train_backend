class AddPictureToSourceImage < ActiveRecord::Migration
  def up
    add_attachment :source_images, :picture
  end

  def down
    remove_attachment :source_images, :picture
  end
end
