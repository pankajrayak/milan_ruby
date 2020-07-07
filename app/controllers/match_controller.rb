class MatchController < ApplicationController
  #before_action :authenticate_user!
  #include ActionController::MimeResponds
  include CustomMethods
  require 'will_paginate/array'

  def show
    match= ProfileMatch.find_by_id params[:id]
    if(match.present?)
    profile=Profile.find_by_user_id (match.match_user_id)
    photo=Photo.find_by_user_id(match.match_user_id)
    render json: {:data => { profile:profile,photo:photo}}
   end
  end

  def match_list
    page= params[:page].present? ? params[:page].to_i : 1
    profile_list= params[:user_id].present? ? ProfileMatch.matched_user(params[:user_id]): ProfileMatch.matched_user(current_user.id)
    render json: {:profiles =>(params[:page].present? ? profile_list.paginate(:page =>  page, :per_page => 10) : profile_list),total:profile_list.count}
  end


 #searches for profile on the basis of filter


  def search_result
   query = search_params.presence && search_params
   results = query.present? ?  helpers.search_query(query) :helpers.create_query(current_user)
   render json: {:data => results, :total => results.results.total}
  end
    
  def requests
    @return_message = true
    if request_param.present?
     helpers.user_interests(request_param[:user_to].to_i,request_param[:activity],request_param[:message])
    else
      @return_message = false
    end
      render json: {:result => @return_message}
  end


 

private  
  def search_params
   params.permit([:sex,:country, :name, :state,:education_level,:community,:have_children,:marital_status,:height_from,:height_to,:age_from,:age_to,:from,:size])
  end

  def request_param
    params.require(:interest).permit([:user_to,:activity,:message])
  end

  def user_search_params
    params.require(:match).permit([:age_from,:age_to,:status,:region,:sex,:name,:from,:size])
  end
end
