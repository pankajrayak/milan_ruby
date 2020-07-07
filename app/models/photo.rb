class Photo < ApplicationRecord
  belongs_to :user
  include Workflow
  # workflow_column :state
  workflow do
    state :new do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :accepted
    state :rejected
  end
mount_uploader :photo, PhotoUploader
validates :user_id,presence: true
validates :photo, 
:presence => true, 
:file_size => { 
  :maximum => 10.megabytes.to_i 
} 
before_save :update_photo_attributes

  def self.upload_image(user_photo,type,user_id,private_pic)
    set_inactive=Photo.where(user_id:user_id,photo_for:type).first
    #set_inactive.destroy_all()  if set_inactive.present?
    if set_inactive.present?
      @photo = set_inactive.update(:photo => user_photo,:photo_for => type,user_id:user_id,:private_pic=>private_pic) 
      set_inactive.url =set_inactive.photo.thumb.url
      set_inactive.save
    else
      @photo = Photo.create!(:photo => user_photo,:photo_for => type,user_id:user_id,:private_pic=>private_pic) 
      @photo.url = @photo.photo.thumb.url
      @photo.save
    end
   
   
  end


  def self.show_images(user_id)
    Photo.where("user_id = ? and active = ?",user_id,true)
  end

private
def update_photo_attributes
  if photo.present? && photo_changed?
    self.photo_type = photo.file.content_type
    @count = Photo.where(user_id: self.user_id).count
    self.sequence = @count + 1
  end
end

end
