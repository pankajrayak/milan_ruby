class RegistrationsController < DeviseTokenAuth::RegistrationsController
	include CustomMethods
   
    def create
      super do |resource|

       if resource.save

        @user=resource
        @profile_insert=profile_params
        @profile = Profile.new(@profile_insert)
        @partner_preference = PartnerPreference.new(partner_preference)
        @deal_breakers=DealBreaker.new(deal_breakers_params)
        @billing_address=BillingAddress.new(billing_address_params)
        @billing_address.user_id=@user.id
        @partner_preference.user=@user
        @profile.user=@user
        @profile.height= CustomMethods.convert_to_float(profile_params[:height])
        #free users set paid_user= true 
        paid_user =  EarlyBirdRegistration.is_paid(@user.email)
        if paid_user
          @message={}
          User.extend_date( @user,1)
        else
          @data, @message =  Charge.create_card(@user,params[:payment][:nonce])
        end

        if @message[:error].present?
          resource_data= @user
          @user.destroy
          response = {
            status: 'error',
            data:   resource_data,
            type: 'custom'
          }
          #byebug
          message = @message[:error]
          #message={email: ["has already been taken"], full_messages: [@message[:error]]}
         return render_error(422, message, response)
        else 
          if @profile.save
            @user_role = UserRole.new(:role_id => 1,:user_id=>resource.id)
            @user_role.save
            @partner_preference.height_from=CustomMethods.convert_to_float(partner_preference[:height_from])
            @partner_preference.height_to=CustomMethods.convert_to_float(partner_preference[:height_to])
            if @partner_preference.save
              @deal_breakers=DealBreaker.new(deal_breakers_params)
              @deal_breakers.partner_preference_id = @partner_preference.id
              @deal_breakers.save
              session[:milan_user]=resource 
              helpers.states_handling(@profile,@profile.profile_state,"")
            end
            Member.create(user_id:@user.id,terms_accepted_on:capture_terms_params[:terms_accepted_on])
            @billing_address.save
            #con = @user.mailbox.sentbox.last.move_to_trash(@user)
           end
        end

       end

      end

    end
  
    # def update
    #   super
    # end
   
    def select_options
      marital_status=MaritalStatus.all.select(:id,:name)
      relationship=Relationship.all.select(:id,:name)
      education=Education.all.select(:id,:name)
      region=Region.all.select(:id,:name,:continent).order("id")
      diet=Diet.all.select(:id,:name)
      nakshatra=Nakshatra.all.select(:id,:name)
      value=Value.all.select(:id,:name)
      income=Income.all.select(:id,:name)
      occupation=Occupation.all.select(:id,:name,:title)
      education_concentration=EducationConcentration.all.select(:id,:name)
      community=Community.all.select(:id,:name)
      country= CountryByRegion.all.map{|x|{id:x.id,name:x.country}}
      admins=User.get_admin()
      render:json=>{data:{countryOption:country,nakshatraOption:nakshatra,
        regionOption:region,occupationOption:occupation,
        incomeOption:income,educationConcentrationOption:education_concentration,
        maritalOption:marital_status,relationOption:relationship,
        educationOption:education,valueOption:value,
        admins:admins,communityOption:community,
        dietOption:diet}}
    
    end

    def get_states
      countries = params[:value];
      states=[]
      if countries.present? && countries != ''
        countries_arr = countries.split(',')
        countries_arr.each do |country|
          sql = 'select * from states where  country_id in(select id from countries where name = \'' << country << '\')'
          list=ActiveRecord::Base.connection.execute(sql)
          states = states + list.to_a
        end
      end
      render:json=>{data:{states:states}}
    end
    def get_cities
      render:json=>{data:{id:1}}
    end

    def contact_info
      if params[:region].present?
        region=params[:region]   
      else
        region=Region.all.pluck(:name).first   
      end
     #manager= User.joins(:user_roles).where('users.region= ? and user_roles.role_id=?',region,2).select(:first_name , :last_name,:email,:id).first
    manager =  ActiveRecord::Base.connection.execute("select u.id,u.region,u.first_name,u.last_name,u.email from users u join user_roles ur on ur.user_id=u.id where ur.role_id=2  and '" << region <<"'=ANY (regexp_split_to_array(u.region, '\,'))")
     render:json=> manager
    end

  def get_country_region
    country = params[:country]
    state = params[:state]
    region = ""
    country_region = CountryByRegion.find_by('lower(country)=?',country.downcase)
    if country_region.present?
      if country_region.region == 'See separate chart'
        state_region = StateByRegion.find_by('lower(state)=?',state.downcase)
        if state_region.present?
        region = state_region.region
        end
      else
        region = country_region.region
      end
    end
    render:json=>{data:region}
  end

  def resend_email
    email = params[:email]
    user = User.find_by_email(email)
    if user.present?
      user_type=user.position
      if(user_type=="Admin")
        MilanMailer.email_confirmations(user,"admin").deliver_later 
      elsif (user_type=='Manager')
        MilanMailer.email_confirmations(user,"regional manger").deliver_later 
      else
        user.send_confirmation_instructions
      end
     
      render:json=>{success:true}
    else
      render:json=>{data:"Unable to find user with email '#{email}'."}
    end
  end
    def contact_us
      
      if(contact_us_params.present?)
        name=""
      #   user=User.find_by email: contact_us_params[:to]
      #  if user.present?
      #   name=user.first_name + " " + user.last_name
      #  end
      ContactMailer.contact_email(name,contact_us_params).deliver
      render :json => "sent successfully"
      else
      render :json => "Invalid entry"
      end

    end
    
    # def email_check
    #   @user = User.search(params[:email])
    #   respond_to do |format|
    #     format.json {render :json => {email_exists: @user.present?}}
    #   end
    # end

    private
    def contact_us_params
      params.require(:contact).permit(:from,:to,:message, :name)
    end
      def profile_params
        params.require(:profile).permit(:gender,:education_concentration,:diet,:member_relationship,:city_of_birth,:country_of_birth,:state_of_birth,
          :is_manglik,:linkedin,:height,:phone_number,:mobile_number,
          :country,:country_raised,:drink,:smoke,:state,:city,:marital_status,
          :have_children,:community,:education_level,:facebook,
          :instagram,:religion,:about_me,:dob,:time_of_birth,:nakshatra,:photo,:values,:income,:occupation)
      end
      def sign_up_params
        params.require(:user).permit(:email, :password,  :first_name, :last_name, :region)
      end
      def photo_params
        params.require(:photos).permit(:head,:full_length)
      end
      def partner_preference
        params.require(:partner_preference).permit(:age_from,:country,:state,:age_to,:height_from,:height_to,:marital_status,:have_children,:community) 
      end
      def deal_breakers_params
        params.require(:deal_breakers).permit(:age,:country,:state ,:height,  :marital_status, :have_children,  :community)
      end
      
      def payment_params
        params.require(:payment).permit(:nonce)
      end
      def billing_address_params
        params.require(:billing_address).permit(:first_name,:last_name,:email,:zipcode,:address_line_one,
          :address_two_one,
          :country,:state,:phone,:city)
      end
      def capture_terms_params
        params.require(:member).permit(:terms_accepted_on)
      end
  end 