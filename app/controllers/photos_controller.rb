class PhotosController < ApplicationController
    before_action :authenticate_user!
    before_action :all_user_photos, only: [:show_photos]
    def request_photo
        message= Photo.create_request(request_params,current_user)
        current_user.send_message(beta, request_params[:comment],I18n.t('photos.request'))
       render json: message
    end

    def approve_photo
       approve_request= Request.find_by(id: request_params[:id])
       approve_request.accept!
       render json: "Approved"
    end

    def show_photos
        render json: @photos
    end

private
def all_user_photos
   if params[:id].present?
        @photos=Photo.where(user_id: params[:id])
    else
        @photos=current_user.photos
   end
end

def request_params
params.require(:request_photo).permit(:id,:comment)
end

end