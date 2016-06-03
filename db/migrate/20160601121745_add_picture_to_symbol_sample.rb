class AddPictureToSymbolSample < ActiveRecord::Migration
  def up
    add_attachment :symbol_samples, :picture
  end

  def down
    remove_attachment :symbol_samples, :picture
  end
end
