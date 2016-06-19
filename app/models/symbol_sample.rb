class SymbolSample < ActiveRecord::Base
  include Paperclip::Glue
  include Grape::Entity::DSL

  belongs_to :source_image

  validates :is_negative, presence: true
  validates :char, presence: true, if: 'is_positive?'
  validates :x, presence: true
  validates :y, presence: true
  validates :width, presence: true
  validates :height, presence: true
  validates :threshold, presence: true
  validates :source_image_id, presence: true

  has_attached_file :picture
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  after_commit :create_cropped_image, :if => Proc.new { |record|
    record.previous_changes.key?(:source_image_id)
  }

  scope :positive, -> { where is_negative: false }
  scope :negative, -> { where is_negative: true }

  entity do
    expose :id, if: lambda { |s, st| s.picture.present? && st[:fields].include?(:id) }
    expose :source_image_id, if: lambda { |s, st| s.picture.present? && st[:fields].include?(:source_image_id) }
    expose :picture, if: lambda { |s, st| s.picture.present? && st[:fields].include?(:picture) } do |s, st|
      s.picture.url
    end
    expose :bounds, if: lambda { |s, st| st[:fields].include?(:bounds) } do
      expose :x
      expose :y
      expose :width
      expose :height
    end
    expose :char, if: lambda { |s, st| st[:fields].include?(:char) }
    expose :threshold, if: lambda { |s, st| st[:fields].include?(:threshold) }
    expose :cser_light_features, if: lambda { |s, st|
      s.cser_light_features.present? && st[:fields].include?(:cser_light_features)
    }
    expose :cser_heavy_features, if: lambda { |s, st|
      s.cser_heavy_features.present? && st[:fields].include?(:cser_heavy_features)
    }
  end

  def is_positive?
    !self.is_negative
  end

  private
    def create_cropped_image
      CropSymbolSampleWorker.perform_async(self.id)
    end

end
