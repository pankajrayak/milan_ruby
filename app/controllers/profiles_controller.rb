class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:check_email,:profile_photos]
  
  include CustomMethods

    def user_info
      render :json =>{:user=>current_user,:photo=>current_user.photos}
    end
    
   def create
    profile=Profile.new(profile_params)
    profile.height=CustomMethods.convert_to_float(profile_params[:height])
    if profile.save
      render :json => profile
    else
      render :json => { :errors => profile.errors.full_messages }, :status => 422
    end
  end


  def regional_managers
    user_model=current_user
    if params[:user_id].present?
      user_model=User.find_by(params[:user_id])
    end
  # manager_list=User.includes(:profile,:photos).where(id: User.manager_ids,region:user_model.region)
    manager_list=User.get_user_manager(user_model.region)
    if !manager_list.present? || user_model.region=="Default"
      #manager_list=User.get_user_manager("Default")
      manager_list=User.get_admin()
    end
    render :json => manager_list
  end
  
   def request_export
      memberObj=  current_user.member
      if( memberObj.present? && memberObj.show_export)
      memberObj.export_request_on=Time.now
      #memberObj.export_data=true
      memberObj.save
      current_user.send_message(current_user.get_admin_and_manager,(I18n.t 'milan.msg.export_request',name: current_user.first_name+current_user.last_name) , I18n.t('milan.subject.export_sub'))
      render json: {status: 200,message: "Request sent!"}
      else
      render json: {status: "error", code: 422, message: 'Member not exist'}
      end
     
   end
 
   def interest
    if params[:type].present?
      type=params[:type] #sent,received,accepted
      @interest_list=Interest.remove_expired
      case type
      when "sent"
         @interest_list=@interest_list.where(user_id:current_user.id)
      when "received"
        @interest_list=@interest_list.where(user_to:current_user.id, :state=>"awaiting_response")
      when "accepted"
        @interest_list=@interest_list.where("(user_id= ? OR user_to = ?) AND  state= ? ",current_user.id,current_user.id, "accepted")    
      # when "all"
      #   @interest_list=Interest.where(:user_id=>current_user.id).
      end
    end
    list=[]
    if !@interest_list.blank?
         @interest_list.each do |item|
           interest_object=Hash.new
           user_info={}
        if(item.user_id!=current_user.id)
          user_info=User.find_by_id item.user_id
        else
          user_info=User.find_by_id item.user_to
        end
        interest_object[:profile]= user_info.profile
        interest_object[:user]= user_info
        interest_object[:photo]= user_info.photos
        interest_object[:interest]=item
        interest_object[:partner_preference]=user_info.partner_preference
        interest_object[:deal_breaker]=user_info.partner_preference.deal_breaker
        list.push(interest_object)
     end
  end
      render json: {:list =>  list}
   end

   def interest_count
    subject=I18n.t('conversations.index.connect_invite')
    sent_invitations=current_user.mailbox.sentbox.where(:subject => subject).where.not(:subject => "Need more information")
    sent_list=[];
    recevied_list=[];
    others_list=[];
    sent_invitations.each do |i|
      interest = Interest.find_by_conv_id(i.id)
        if interest.present?
          if (interest.state=='awaiting_response') && i.participants.size>1
            sent_list.push(i) 
          end
        end
    end

    received_invitations=current_user.mailbox.inbox.where(:subject => subject)
    received_invitations.each do |i|
      received_interest = Interest.find_by_conv_id(i.id)
        if received_interest.present?
          if (received_interest.state=='awaiting_response') && i.participants.size>1
            recevied_list.push(i) 
          end
        end
    end
    
    connections=Interest.remove_expired.where("(user_id= ? OR user_to = ?) AND  state= ? ",current_user.id,current_user.id, "accepted").size
    others=current_user.mailbox.inbox.where.not(:subject => "Need more information").where.not(:subject => "Not defined").or(current_user.mailbox.sentbox.where.not(:subject => "Not defined"))
    others.each do |i|
      if i.participants.size>1
        others_list.push(i) 
      end
    end
    render json: {received: recevied_list.size, others: others_list.size, sent: sent_list.size, accepted: connections}
   end



    def check_email #if email exist then response msg will be true
      email = ""
      if user_params[:email]!=nil
        email = user_params[:email]
      end
      #free users set paid_user= true 
      paid_user =  EarlyBirdRegistration.is_paid(email)

      if User.email_exist(email)
      render json: {
                status: 200,
                message: true,
                paid_user:paid_user
             }.to_json
      else
            render json: {
          status: 200,
          message: false,
          paid_user:paid_user
             }.to_json
      end
    end

    def profile_photos
      user = User.find params[:user_id]
      if user.present?
        if params[:head]!= "null"
          Photo.upload_image(params[:head],"headshot",user.id,user.profile.photo)
        end
        if params[:full_length] != "null" 
          Photo.upload_image(params[:full_length],"fullbody",user.id,user.profile.photo)
        end  
        User.update_elastic(User.find params[:user_id])
      end
     
      render:json=>{data:true}
    end


  # GET /profiles/1
  # GET /profiles/1.json
  def profile_info
  u_id= params[:user_id].present? ? params[:user_id].to_i : current_user.id
  @profile= Profile.find_by_user_id u_id
  export_btn=false
  if !@profile.present?
    response = {
      status: 'error',
      type: 'custom'
    }
    message = "User not found"
    render json: {status: "error", code: 422, message: message}
  
  else
    is_user_confirm = @profile.user.confirmed?
    request_button=false;
    edit_rights=false
    if current_user.member.present?
    export_btn=  current_user.member.show_export
    end
    if u_id!=current_user.id
      edit_rights=UserRole.my_regional_admin(current_user,@profile.user.region)
    else
      edit_rights=true
    end

    if (!request_button)
      @photo = Photo.where(:user_id => @profile.user_id,:active=>true) 
    else
      @photo = Photo.where(:user_id => @profile.user_id,:active=>true) #,:private_pic=>false
    end
  
    @partner_preferences = PartnerPreference.find_by_user_id u_id 
    if @partner_preferences.present?
      @deal_breaker = DealBreaker.find_by_partner_preference_id @partner_preferences.id 
      else
        @partner_preferences = PartnerPreference.new
        @deal_breaker = DealBreaker.new
    end
      @interest = Interest.select(Arel.star).where(
        Interest.arel_table[:user_id].eq(u_id).and(Interest.arel_table[:user_to].eq(current_user.id)).or(
          Interest.arel_table[:user_id].eq(current_user.id).and(Interest.arel_table[:user_to].eq(u_id))
        )
      )
  
      render json: {
        status: 200,
        message: true,
        profile:@profile,
        photo:@photo,
        user:@profile.user,
        partner_preferences:@partner_preferences,
        deal_breakers:@deal_breaker,
        request_button:request_button,
        edit_rights: edit_rights,
        interest:  @interest.first, 
        export_feature: export_btn,
        is_user_confirm: is_user_confirm
    }.to_json
  end
   #MANAGING MEMBER PROFILE FOR ADMIN
  #  @optionbtn=false
  #      if Profile.privilige(current_user,@profile.user)
  #        @optionbtn=true
  #         if(@profile.profile_state=='awaiting_review')
  #          @profile.review!
  #         end
  #     else
  #       @optionbtn=false
  #      end
  end



def profile_status
  u_id= params[:user_id].present? ? params[:user_id]: current_user.id
  profile= Profile.find_by_user_id u_id
  render json: profile.profile_state
end



  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    @profile = Profile.find_by_id(params[:id])
    @updateFor = params[:type]
    @message = "Update successfully..."
    if @updateFor=="ProfileInformation"
      @profile_update=profile_params
      @profile_update[:dob] = Date.strptime(@profile_update[:dob], '%m/%d/%Y')
      
      @profile_update[:height] = CustomMethods.convert_to_float(@profile_update[:height])
      user_type=current_user.position
        if user_type != "Member" && @profile.gender !=    @profile_update[:gender]
          ProfileMatch.delete_other_user_matches(current_user.id)
          ProfileMatch.delete_matches(current_user.user_id)
        end
      #@profile_update[:height]= convert_to_float(profile_params[:height],params[:height_inch])
      if @profile.update(@profile_update)
        
        @profile.user.first_name=user_params["first_name"]
        @profile.user.last_name=user_params["last_name"]
        @profile.user.region=user_params["region"]
        photos=   @profile.user.photos
        if photos.present?
          photos.update_all(:private_pic=>@profile.photo)
        end
        @profile.user.save     
      #after updation report admin
      role=UserRole.get_roles(current_user)
     else
        @message = "Something went wrong"
      end
    elsif @updateFor=="OnlyProfile"
      @profile_update=profile_params
      if @profile.update(@profile_update)   
         puts 'updated profile'
      else
        @message = "Something went wrong"
      end
    elsif @updateFor=="OnlyRegion"
      @profile.user.region=user_params["region"]
      @profile.user.save  
    elsif @updateFor == "PartnerPreferences"
      @partner_preferences = PartnerPreference.find_by_user_id @profile.user_id
      @partner_preferences_update=partner_preferences_params
      @partner_preferences_update[:height_from] = CustomMethods.convert_to_float(@partner_preferences_update[:height_from])
      @partner_preferences_update[:height_to] = CustomMethods.convert_to_float(@partner_preferences_update[:height_to])
      if !@partner_preferences.present?
        @partner_preferences = PartnerPreference.new(@partner_preferences_update)
        @partner_preferences.user_id = @profile.user_id
        @deal_breaker = DealBreaker.new
        if @partner_preferences.save
          @deal_breaker.partner_preference_id = @partner_preferences.id
          @deal_breaker.save
        end
      end
      @partner_preferences = PartnerPreference.find_by_user_id @profile.user_id
      if @partner_preferences.update(@partner_preferences_update)
        @deal_breaker = DealBreaker.find_by_partner_preference_id @partner_preferences.id 
        if @deal_breaker.present?
          @deal_breaker.update(deal_breaker_params)
        end
      end   
    end
    @profile=Profile.find_by(id: @profile.id)
    User.update_elastic(@profile.user)
      render json: {
        status: 200,
        message: @message,
        profile:@profile
     }.to_json
 end



def get_roles
  roles= UserRole.get_roles(current_user)
  render json: {roles:roles}
end


  private
# Never trust parameters from the scary internet, only allow the white list through.
   
    def profile_params
      params.require(:profile).permit(:religion,:gender,:city_of_birth,:country_of_birth,:state_of_birth,:income,:education_concentration,:interest,:is_manglik,:time_of_birth,:nakshatra,:marital_status,:diet,:smoke,:drink,:community,:education_level, :dob,:height,:feet, :inches,:phone_number,:mobile_number,:state,:city,:have_children, :about_me,:photo, :instagram, :facebook,:linkedin , :partner_preferences,:country_raised, :country,:values, :member_relationship,:occupation)
    end
    def user_params
        params.require(:user).permit(:region,:first_name,:last_name,:email) 
    end
    def deal_breaker_params
      params.require(:deal_breakers).permit(:age,:country,:state,:height,:marital_status,:have_children,:region,:community) 
  end
    def contact_params
      params.permit(contact_details:[:contact, :contact_type])
    end
    def partner_preferences_params
      params.require(:partnerPreferences).permit(:age_from,:country,:state, :age_to,:height_from,:height_to,:marital_status,:have_children,:community)
    end
  
end
