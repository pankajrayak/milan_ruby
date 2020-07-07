# # # # This file should contain all the record creation needed to seed the database with its default values.
# # # # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
 


# # CONSTANT DATA:
#   jobstatuses = Jobstatus.create([{name:'Employed'},{name:'Self-employed'},{name:'Student'}])
#   relationships = Relationship.create([{name: 'Self'},{name: 'Son'},{name: 'Sister'},{name: 'Brother'},{name: 'Friend'},{name: 'Relative'},{name: 'Daughter'}])
 

# regions= Region.create([
#         {name: 'US - Northeast', continent: 'North America'},
#         {name: 'US - Southeast',continent: 'North America'},
#         {name: 'US - Southwest',continent: 'North America'},
#         {name: 'US - Midwest',continent: 'North America'},
#         {name: 'US - West',continent: 'North America'},
#         {name: 'Canada',continent: 'North America'},
#         {name: 'Central America',continent: 'North America'},
#         {name: 'Islands of North America',continent: 'North America'},


#         {name: 'South America',continent: 'South America'},

#         {name: 'Northern Europe',continent: 'Europe'},
#         {name: 'Eastern Europe',continent: 'Europe'},
#         {name: 'Southern Europe',continent: 'Europe'},
#         {name: 'Western Europe',continent: 'Europe'},

#         {name: 'Central Asia',continent: 'Asia'},
#         {name: 'South Asia',continent: 'Asia'},
#         {name: 'Southeast Asia',continent: 'Asia'},
#         {name: 'Eastern',continent: 'Asia'},
#         {name: 'Western Asia',continent: 'Asia'},


#         {name: 'Australia',continent: 'Australia'},

#         {name: 'Africa',continent: 'Africa'},

#         {name: 'Antarctica',continent: 'Antarctica'}
#         ])

    
#   marital_statuses= MaritalStatus.create([{name:"Never Married"},{name:"Widowed"},{name:"Divorced"},{name:"Awaiting Divorce"},{name:"Annulled"}])

  
#   # education_lists=[]
#   # 20.times do |n|
#   #   education_lists.push(name:Faker::Educator.course)
#   # end

#   # Education.create(education_lists)

#   # roles=Role.create([{role:'MEMBER',description:'customers'},{role:'RGN',description:'It handles all the user profiles of associated region'},{role:'GBL',description:'Covers super admin priviliges'}])

#   Education.create([{name:'Doctorate'},{name:'Masters'},{name:'Bachelors'},{name:'Associates Degree'},{name:'Diploma'},{name:'Highschool'},{name:'Less than highschool'},{name:'Trade School'},{name:'No education'}])
  
 
  # communityList=['Sindhi - Bhanusali',
  # 'Sindhi - Bhatia',
  # 'Sindhi - Chhapru',
  # 'Sindhi - Dadu',
  # 'Sindhi - Hyderabadi',
  # 'Sindhi - Larai',
  # 'Sindhi - Lohana',
  # 'Sindhi - Rohiri',
  # 'Sindhi - Sehwani',
  # 'Sindhi - Thatai',
  # 'Sindhi - Amil',
  # 'Sindhi - Baiband',
  # 'Sindhi - Larkana',
  # 'Sindhi - Sahiti',
  # 'Sindhi - Sakkhar',
  # 'Sindhi - Shikarpuri',
  # 'Sindhi - Other']
  # communityList.each do |n|
  #   Community.create(name:n)
  # end

#   Value.create([{name:'Conservative'},{name:'Moderate'},{name:'Liberal'}])

#  Diet.create([{name:'Vegetarian' },{name:'Occasionally non-veg' },{name:'Non-vegetarian'}])

#   Income.create([{name:'Up to 40K' },
#     {name:'USD 40K to 60K' },
#     {name:'USD 60K to 80K' },
#     {name:'USD 80K to 100K' },
#     {name:'USD 100K to 125K' },
#     {name:'USD 125K to 150K' },
#     {name:'USD 150K to 200K' },
#     {name:'USD 200K to 250K' },
#     {name:'USD 250K+' },
#     {name:'Does not wish to specify'}])

#  education_concentration = EducationConcentration.create([{name:'Advertising/Marketing' },
# {name:'Administrative Services' },
# {name:'Architecture' },
# {name:'Agriculture' },
# {name:'Armed Forces' },
# {name:'Arts' },
# {name:'Commerce' },
# {name:'Computers/IT' },
# {name:'Culinary Arts' },
# {name:'Education' },
# {name:'Engineering' },
# {name:'Finance' },
# {name:'Fine Arts' },
# {name:'Fashion' },
# {name:'Hospitality' },
# {name:'Home Science' },
# {name:'Law' },
# {name:'Management' },
# {name:'Medicine' },
# {name:'Nursing' },
# {name:'Healthcare' },
# {name:'Science' },
# {name:'Not listed/Other/Not Applicable'}])


# Occupation.create([
#     {title:'Accounting, Banking, & Finance',name:'Banking Professional' },
#     {title:'Accounting, Banking, & Finance',name:'Chartered Accountant' },
#     {title:'Accounting, Banking, & Finance',name:'Company Secretary' },
#     {title:'Accounting, Banking, & Finance',name:'Finance Professional' },
#     {title:'Accounting, Banking, & Finance',name:'Investment Professional' },
#     {title:'Accounting, Banking, & Finance',name:'Acounting Professional' },
#     {title:'Administration & HR',name:'Administrative Professional' },
#     {title:'Administration & HR',name:'Human Resources Professional' },
#     {title:'Advertising, Media & Entertainment',name:'Actor' },
#     {title:'Advertising, Media & Entertainment',name:'Advertising Professional' },
#     {title:'Advertising, Media & Entertainment',name:'Entertainment Professional' },
#     {title:'Advertising, Media & Entertainment',name:'Event Manager' },
#     {title:'Advertising, Media & Entertainment',name:'Journalist' },
#     {title:'Advertising, Media & Entertainment',name:'Media Professional' },
#     {title:'Advertising, Media & Entertainment',name:'Public Relations Professional' },
#     {title:'Agriculture',name:'Farming' },
#     {title:'Agriculture',name:'Agricultural Processional' },
#     {title:'Airline & Aviation',name:'Flight Attendant' },
#     {title:'Airline & Aviation',name:'Pilot/Co-Pilot' },
#     {title:'Airline & Aviation',name:'Other Airline Professional' },
#     {title:'Architecture & Design',name:'Architect ' },
#     {title:'Architecture & Design',name:'Interior Designer ' },
#     {title:'Architecture & Design',name:'Landscape Architect ' },
#     {title:'Artists, Animators & Web Designers',name:'Animator' },
#     {title:'Artists, Animators & Web Designers',name:'Commercial Artist' },
#     {title:'Artists, Animators & Web Designers',name:'Web/UX Designers' },
#     {title:'Artists, Animators & Web Designers',name:'Artists (Others)' },
#     {title:'Beauty, Fashion, & Jewelry Designers',name:'Beautician ' },
#     {title:'Beauty, Fashion, & Jewelry Designers',name:'Fashions Designer ' },
#     {title:'Beauty, Fashion, & Jewelry Designers',name:'Hairstylist ' },
#     {title:'Beauty, Fashion, & Jewelry Designers',name:'Jewelry Designer ' },
#     {title:'Beauty, Fashion, & Jewelry Designers',name:'Designer ' },
#     {title:'Civil Services/Law Enforcement',name:'Defense' },
#     {title:'Civil Services/Law Enforcement',name:'Air force' },
#     {title:'Civil Services/Law Enforcement',name:'Army' },
#     {title:'Civil Services/Law Enforcement',name:'Navy' },
#     {title:'Education & Training',name:'Lecturer' },
#     {title:'Education & Training',name:'Professor' },
#     {title:'Education & Training',name:'Research Assistant' },
#     {title:'Education & Training',name:'Research Scholar' },
#     {title:'Education & Training',name:'Teacher' },
#     {title:'Engineering ',name:'Civil Engineer' },
#     {title:'Engineering ',name:'Non-IT Engineer' },
#     {title:'Engineering ',name:'Electronics/Telecom Engineer' },
#     {title:'Engineering ',name:'Mechanical/Production Engineer' },
#     {title:'Hotel & Hospitality',name:'Chef' },
#     {title:'Hotel & Hospitality',name:'Catering Professional' },
#     {title:'Hotel & Hospitality',name:'Hotel & Hospitality Professional' },
#     {title:'IT & Software Engineering',name:'Software Developer' },
#     {title:'IT & Software Engineering',name:'Software Consultant' },
#     {title:'IT & Software Engineering',name:'Hardware & Networking Professional' },
#     {title:'IT & Software Engineering',name:'Software Professional' },
#     {title:'Legal',name:'Lawyer' },
#     {title:'Legal',name:'Legal Assistant' },
#     {title:'Legal',name:'Legal Professional' },
#     {title:'Medical & Healthcare',name:'Dentist' },
#     {title:'Medical & Healthcare',name:'Doctor' },
#     {title:'Medical & Healthcare',name:'Nurse' },
#     {title:'Medical & Healthcare',name:'Pharmacist' },
#     {title:'Medical & Healthcare',name:'Physicians Assistant' },
#     {title:'Medical & Healthcare',name:'Physiotherapist' },
#     {title:'Medical & Healthcare',name:'Psychologist' },
#     {title:'Medical & Healthcare',name:'Veterinary Doctor' },
#     {title:'Medical & Healthcare',name:'Therapist' },
#     {title:'Medical & Healthcare',name:'Surgeon' },
#     {title:'Medical & Healthcare',name:'Medical Transportation Specialist' },
#     {title:'Medical & Healthcare',name:'Surgeon' },
#     {title:'Medical & Healthcare',name:'Healthcare Administration' },
#     {title:'Medical & Healthcare',name:'Healthcare Sales' },
#     {title:'Sales & Marketing',name:'Marketing Professional' },
#     {title:'Sales & Marketing',name:'Sales Professional' },
#     {title:'Science',name:'Biologist/Botanist' },
#     {title:'Science',name:'Science Professional' },
#     {title:'Corporate Professional',name:'CxO' },
#     {title:'Corporate Professional',name:'VP/AVP/GM/DGM' },
#     {title:'Corporate Professional',name:'Sr. Manager/Manager' },
#     {title:'Corporate Professional',name:'Consultant/Supervisor' },
#     {title:'Corporate Professional',name:'Team Member/Staff' },
#     {title:'Others ',name:'Agent/Broker/Trader' },
#     {title:'Others ',name:'Business Owner/Entrepreneur' },
#     {title:'Others ',name:'Politician' },
#     {title:'Others ',name:'Social/Volunteer' },
#     {title:'Others ',name:'Sportsman' },
#     {title:'Others ',name:'Travel & Transportation' },
#     {title:'Others ',name:'Writer' },
#     {title:'Non Working',name:'Student' },
#     {title:'Non Working',name:'Retired' },
#     {title:'Non Working',name:'Not Working' },
# ])
  
# Nakshatra.create([
#     {name:'Don\'t know/Does not wish to specify' },
#     {name:'Ashwini' },
#     {name:'Bharani' },
#     {name:'Krittika' },
#     {name:'Rohini' },
#     {name:'Mrigasira' },
#     {name:'Ardra' },
#     {name:'Punarvasu' },
#     {name:'Pusya' },
#     {name:'Aslesa' },
#     {name:'Magha' },
#     {name:'Purva Phalguni' },
#     {name:'Uttara Phalguni' },
#     {name:'Hasta' },
#     {name:'Chitra' },
#     {name:'Swati' },
#     {name:'Vishakha' },
#     {name:'Anuradha' },
#     {name:'Jyestha' },
#     {name:'Mula' },
#     {name:'Purva Ashadha' },
#     {name:'Uttara Ashadha' },
#     {name:'Shravana' },
#     {name:'Dhanistha' },
#     {name:'Shatabhishak' },
#     {name:'Purva Bhadrapada' },
#     {name:'Uttara Bhadrapada' },
#     {name:'Revati' }
# ])

# def insert_countries_states_cities
#      connection = ActiveRecord::Base.connection
    # statement  = File.read('db//data/cities.sql')
    # connection.execute(statement)
    # statement  = File.read('db//data/states.sql')
    # connection.execute(statement)
    # statement  = File.read('db//data/countries.sql')
    # connection.execute(statement)
    
  #   statement  = File.read('db//data/countries_by_region.sql')
  #   connection.execute(statement)
  #   statement  = File.read('db//data/states_by_region.sql')
  #   connection.execute(statement)
  # end
  # insert_countries_states_cities



#    EarlyBirdRegistration.create([
#     {first_name:'Ricky',last_name:'Babani',gender:'Male',email:'godbless67@icloud.com'},
#     {first_name:'Priya',last_name:'Dasani',gender:'Female',email:'dasaniwater@hotmail.com'},
#     {first_name:'Natasha',last_name:'Pohuja',gender:'Female',email:'natashapohuja@gmail.com'},
#     {first_name:'Sonal',last_name:'Samtani',gender:'Female',email:'sonalsamtani@gmail.com'},
#     {first_name:'Viju',last_name:'Sidhwani',gender:'Male',email:'vijusidhwani@gmail.com'},
#     {first_name:'Savita',last_name:'Narsinghani',gender:'Female',email:'savita.narsinghani@gmail.com'},
#     {first_name:'Dinesh',last_name:'Narsinghani',gender:'Male',email:'dinesh.narsinghani@gmail.com'},
#     {first_name:'Madhavi',last_name:'Gehani',gender:'Female',email:'aratimads@yahoo.com'},
#     {first_name:'Jyoti',last_name:'Wadhwani',gender:'Female',email:'julala1506@gmail.com'},
#     {first_name:'Deepika',last_name:'Rupchandani',gender:'Female',email:'rupchandani@gmail.com'},
#     {first_name:'Michelle',last_name:'Chandnani',gender:'Female',email:'mcani85@gmail.com'},
#     {first_name:'Sapna',last_name:'Motwani',gender:'Female',email:'sapnamotwani@gmail.com'},
#     {first_name:'Alka',last_name:'Sippy',gender:'Female',email:'alka.sippy@gmail.com'},
#     {first_name:'Kishore',last_name:'Hemrajani',gender:'Male',email:'kh@cuttermillmailroom.com'},
#     {first_name:'Alicia',last_name:'Raisinghani',gender:'Female',email:'alicia.raisinghani@gmail.com'},
#     {first_name:'Raj',last_name:'Rupani',gender:'Male',email:'raj.rupani@gmail.com'},
#     {first_name:'Neil',last_name:'Butani',gender:'Male',email:'butanimd@gmail.com'},
#     {first_name:'Anjali',last_name:'Butani',gender:'Female',email:'anjalibutani@gmail.com'},
#     {first_name:'Monica',last_name:'Idnani',gender:'Female',email:'mvidnani@gmail.com'},
#     {first_name:'Renu',last_name:'Kirpalani',gender:'Female',email:'renujaan@hotmail.com'},
#     {first_name:'Anuradha',last_name:'Kirpalani',gender:'Female',email:'Akirp87@gmail.com'},
#     {first_name:'Gaurav',last_name:'Aurora',gender:'Male',email:'gauravmi2@gmail.com'},
#     {first_name:'Purvi',last_name:'Parwani',gender:'Female',email:'drpurviparwani@gmail.com'},
#     {first_name:'Ameet',last_name:'Nainani',gender:'Male',email:'ameet.nainani@gmail.com'},
#     {first_name:'Varsha',last_name:'Sabharwal',gender:'Female',email:'sakshi75@gmail.com'},
#     {first_name:'Chanchal',last_name:'Sabharwal',gender:'Female',email:'jharnasab@gmail.com'},
#     {first_name:'Mala',last_name:'Nichani',gender:'Female',email:'mala.nichani@gmail.com'},
#     {first_name:'Pooja',last_name:'Morani',gender:'Female',email:'pooja.morani@gmail.com'},
#     {first_name:'Rashmi',last_name:'Morani',gender:'Female',email:'rcmorani@gmail.com'},
#     {first_name:'Vishal',last_name:'Hemnani',gender:'Male',email:'vishal.hemnani11@gmail.com'},
#     {first_name:'Varun',last_name:'Rijhwani',gender:'Male',email:'vross29@gmail.com'},
#     {first_name:'Rashmi',last_name:'Gajra',gender:'Female',email:'r_gajra@yahoo.com'},
#     {first_name:'Deeya',last_name:'Utamsing',gender:'Female',email:'mutamsing@gmail.com'},
#     {first_name:'Vinita',last_name:'Israni',gender:'Female',email:'viju.israni@sanmina.com'},
#     {first_name:'Kiran',last_name:'Bijlani',gender:'Female',email:'kiranbijlani@gmail.com'},
#     {first_name:'Karishma',last_name:'Gajra',gender:'Female',email:'karishmagajra@hotmail.com'},
#     {first_name:'Hema',last_name:'Kanchandani',gender:'Female',email:'hema.4k@gmail.com'},
#     {first_name:'Manit',last_name:'Motwani',gender:'Male',email:'usasf20@gmail.com'},
#     {first_name:'Pooja',last_name:'Nagpal',gender:'Female',email:'dpsj_nagpal@sbcglobal.net'},
#     {first_name:'Divya',last_name:'Nagpal',gender:'Female',email:'dpsj_nagpal@sbcglobal.net'},
#     {first_name:'Reshma',last_name:'Kriplani ',gender:'Female',email:'reshma416@gmail.com'},
#     {first_name:'Tina ',last_name:'Rupani',gender:'Female',email:'tsrupani@gmail.com'},
#     {first_name:'Gaurav',last_name:'Sachdev',gender:'Male',email:'gms5316@gmail.com'},
#     {first_name:'Toshaan ',last_name:'Bharvani',gender:'Male',email:'matrimony@toshaan.com'},
#     {first_name:'Niraj',last_name:'Brahmkhatri',gender:'Male',email:'niraj.bkhatri@gmail.com'},
#     {first_name:'Amriti',last_name:'Lulla',gender:'Female',email:'amriti.lulla@gmail.com'},
#     {first_name:'Seema ',last_name:'Vaswani',gender:'Female',email:'seemav31@gmail.com'},
#     {first_name:'Dheera',last_name:'Rajpal',gender:'Female',email:'ashokrajpal@gmail.com'},
#     {first_name:'Prakash ',last_name:'Tilokani ',gender:'Male',email:'prakashtilokani08@gmail.com'},
#     {first_name:'Samarth ',last_name:'Wadhwa',gender:'Male',email:'samarth2690@gmail.com'},
#     {first_name:'Manisha',last_name:'Advani',gender:'Female',email:'manisha.m.advani@gmail.com'},
#     {first_name:'Unknown',last_name:'Unknown',gender:'Female',email:'anichani@me.com'}
#     ])