

namespace :db do
    desc "Fill matrimonial database with user sample data"
    task populate: :environment do
      curren_user_count=User.all.count
      30.times do |n|
        puts "[DEBUG] creating user #{curren_user_count+n}"
        regionSelection=Region.all.select(:name)
        email = "user_#{Faker::Name.initials(2)}_#{Faker::Number.hexadecimal(3)}@ziggletech.com"
        password = "989775sA@"
        fname=Faker::Name.first_name
        lname=Faker::Name.last_name
        User.create!( first_name: fname,
                      last_name: lname,
                      region: regionSelection.sample().name,
                      email: email,
                      password: password,
                      password_confirmation: password,
                      confirmed_at: Faker::Date.between(2.year.ago, Date.today)                      
                      )
        end
      
      
         #Generating Random values for Profile
       
      
        job_select= Jobstatus.all
        mix_select=['1','2','3','4','5','6']
        values=['Integrity','Dignity','Community','Resiliency','Ingenuity']
        answers=['Yes','No']
        height_select=(170..222).to_a.map { |inch| inch.to_i}
        member_select=  Relationship.all
        marital_select=MaritalStatus.all
        education_select=Education.all
        #Generating Random values for Partner Preferences 
        agefrom_select= (20..35).to_a.map { |age| age.to_i}
        ageto_select= (35..46).to_a.map { |age| age.to_i}
        heightfrom_select=(160..170).to_a.map { |age| age.to_i}
        heightto_select=(171..230).to_a.map { |age| age.to_i}
        photo_select=(1..25).to_a.map{|p| p.to_i}
      User.last(30).each do |user|
        puts "[DEBUG] uploading profile for user #{user.id}"
           user.create_profile(
            gender: Faker::Gender.binary_type,
            about_me:  Faker::HowIMetYourMother.quote,
            facebook: 'www.facebook.com/user/profile/'+user.first_name,
            instagram:'www.instagram.com/user/profile/'+user.first_name,
            country:  Faker::Address.country,
            member_relationship: member_select.sample().name,
            marital_status: marital_select.sample().name,
            community:'brahmin',
            education_level: education_select.sample().name,
            have_children: answers.sample(),
            state: Faker::Address.state,
            city: Faker::Address.city,
            height: height_select.sample(),
            mobile_number: Faker::PhoneNumber.cell_phone,
            phone_number:Faker::PhoneNumber.phone_number,
            dob:  Faker::Date.birthday(18, 65),
            diet: "vegetarian",
            smoke: answers.sample() ,
            drink: answers.sample(),
            is_manglik: true,
            values: values.sample(),
            profile_state: 'accepted'
            )

            puts "[DEBUG] creating Photos  for #{user.id}"
           
            2.times do |p_no|
              pic_url="https://milan-staging.s3.amazonaws.com/mock_pic/#{photo_select.sample()}.jpeg"
              photo_type= (p_no % 2 ==0)? "headshot": "fullbody"
              puts photo_type
              user.photos.create({ sequence:p_no,active: true, url:pic_url,workflow_state: "accepted",photo_for:photo_type})
            end
            #Providing Role
            puts "[DEBUG] creating Role for user #{user.id}"
            user.user_roles.create({role_id:1})
            
            puts "[DEBUG] Creating Matches for User Random selection Script...."
            10.times do |p_match|
              include_ids=User.joins(:profile).where.not(id: User.joins(:user_roles).where(:user_roles=>{role_id:2}).pluck(:user_id)).where('profiles.profile_state'=>'accepted').pluck(:id)
              match_user=include_ids.sample()
              if(match_user==user.id)
              ProfileMatch.create({user_id: user.id, match_user_id: User.all.sample().id, match_sent_on: Time.now})
              else 
              ProfileMatch.create({user_id: user.id, match_user_id: match_user, match_sent_on: Time.now})
            end
          end
            puts "[DEBUG] creating  partner preference for user #{user.id}"
             preference= user.create_partner_preference(
                age_from: agefrom_select.sample(),
                age_to:ageto_select.sample(),
                height_from:heightfrom_select.sample(),
                height_to:heightto_select.sample(),
                marital_status:marital_select.sample().name,
                have_children: 'No',
                community:'brahmins')
            puts "[DEBUG] creating Deal Breaker for partner preference  #{preference.id}"
             DealBreaker.create({age: true, partner_preference_id: preference.id, height: true, marital_status: false, have_children: false, community: false})
        end
       

#create Admin
puts "Create Admin"
4.times do |n|
  region= Region.where(:id=> n+1).limit(1).pluck(:name).first
  email="atul@ziggletech.com"
  puts "User: #{email}"
  user=User.create!(email: email,first_name:Faker::Name.first_name,last_name:Faker::Name.last_name,region: region, password: "989775sA@",state: 'active')
 
  puts "Profile Creation for emailID: #{email}"
  user.create_profile({ 
    gender: Faker::Gender.binary_type,
    about_me:  Faker::HowIMetYourMother.quote,
  facebook: 'www.facebook.com/user/profile/'+user.first_name,
  instagram:'www.instagram.com/user/profile/'+user.first_name,
  country:  Faker::Address.country,
  member_relationship: member_select.sample().name,
  marital_status: marital_select.sample().name,
  community:'brahmin',
  education_level: education_select.sample().name,
  have_children: answers.sample(),
  state: Faker::Address.state,
  city: Faker::Address.city,
  height: height_select.sample(),
  mobile_number: Faker::PhoneNumber.cell_phone,
  phone_number:Faker::PhoneNumber.phone_number,
  dob:  Faker::Date.birthday(18, 65),
  diet: "vegetarian",
  smoke: answers.sample(),
  drink: answers.sample(),
  is_manglik: true,
  values: values.sample(),
  profile_state: 'accepted'
  })
 puts "Assigning Manager Role to email: #{email}"
   user.user_roles.create({role_id:1})
   user.user_roles.create({role_id:2})
 end

      end 

    end
  
  