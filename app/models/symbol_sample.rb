class SymbolSample < ActiveRecord::Base
  include Paperclip::Glue
  include Grape::Entity::DSL

  belongs_to :source_image

  has_attached_file :picture
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  after_commit :create_cropped_image, :if => Proc.new { |record|
    record.previous_changes.key?(:source_image_id)
  }

  entity do
    expose :source_image_id
    expose :picture, if: lambda { |s, st| s.picture.present? } do |s, st|
      s.picture.url
    end
    expose :bounds do
      expose :x
      expose :y
      expose :width
      expose :height
    end
    expose :threshold
    expose :cser_light_features, if: lambda { |s, st|
      s.cser_light_features.present?
    }
    expose :cser_heavy_features, if: lambda { |s, st|
      s.cser_heavy_features.present?
    }
  end

  private
    def create_cropped_image
      CropSymbolSampleWorker.perform_async(self.id)
    end

end
