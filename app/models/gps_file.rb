class GpsFile < ActiveRecord::Base
  has_attached_file :image, :styles => { :big => '800x800', :thumb => '200x200'}
  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png)

  has_and_belongs_to_many :tags

  scope :tag, -> (tag = false){
    includes(:tags).where(tags: { id: tag }) if tag
  }

  def self.statistics(time_frame)
    {
        distance: addition("length",self.where(:start => time_frame).where(:statistic => true)),
        duration: addition("duration",self.where(:start => time_frame).where(:statistic => true)),
    }

  end

  def self.addition(typ,files)
    files.inject(0) {|sum, number| sum + number.send(typ)}
  end

  def tag_add(value)
    Tag.find_or_create_by(name: value).tap do |tag|
      #TODO maybe with self
      tags << tag
    end
  end

  def tag_remove(id)
    self.tags.delete(Tag.find id)
  end

end
