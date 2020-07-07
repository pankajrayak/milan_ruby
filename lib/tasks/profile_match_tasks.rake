desc 'add profile match'
task add_profile_match: :environment do
    # file directory
    directory = "./public/file"
  
    #Profile Match Search Criteria 
    #Deal Breaker
    #PartnerPreference
    #Not in Interest Table
    #except his id
    d="==========================Creating New Match For Users #{Time.now.to_date}============================= \n"
    User.where.not(id: User.manager_and_admin_ids).find_in_batches do |group|
        group.each do |person|
            puts person.first_name
            count_entry= ProfileMatch.create_matches(person.id,[])
            d+="id: #{person.id} || email:  #{person.email} || Bulk Entries: #{count_entry.size} || Time: #{Time.now.strftime("%I:%M %p")} \n"
        end
        File.open(File.join(directory, 'file.txt'), "a+"){|f| f << d }
    end
   
 
end