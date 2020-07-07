module MatchHelper
 include CustomMethods
  def ageOptions()
    @age_list=  []
    [20,24,30,35,40,42,48,55].each do |i|
      a = Date.tomorrow
      year = ( a.year - i ) - 1
      month = a.mon
      day = a.mday
      @age_list.push( {value:Date.new(year,month,day),name: i})
    end
    @age_list
  end

  def search_query(query)
  #for removing connected users from search
  if(query[:height_to].present? && query[:height_from].present?)
    query[:height_to]= CustomMethods.convert_to_float(query[:height_to]) 
    query[:height_from]= CustomMethods.convert_to_float(query[:height_from])
    height_check(query)
    query[:height_from]=@from
    query[:height_to]=@to
  end 
  if(query[:age_from].present? && query[:age_to].present?)
    query[:age_from]= Interest.get_dob(query[:age_from],true)
    query[:age_to]= Interest.get_dob(query[:age_to],false)
  end
  except_ids  
   User.search_partner(query,@sex,@ids)
  end

  def create_query(user)
    query=Hash.new
    partner=user.partner_preference
    selected=partner.deal_breaker
    query[:education_level]=""
    query[:name]=""
    query[:country]=selected.country? ? partner.country: ""
    query[:state]=selected.state? ? partner.state: ""
    query[:from]=1
    query[:marital_status]=selected.marital_status? ? partner.marital_status: ""
    query[:have_children]=selected.have_children? ? partner.have_children: ""
    query[:community]=selected.community? ? partner.community: ""
    if selected.age
      query[:age_from]=Interest.get_dob(partner.age_from,true)
      query[:age_to]= Interest.get_dob(partner.age_to,false)
    end
    if selected.height
      query[:height_to]= partner.height_to  
      query[:height_from]= partner.height_from
      height_check(query)
     query[:height_from]=@from
     query[:height_to]=@to
    end
    except_ids
    User.search_partner(query,@sex,@ids)
  end
 
private
def height_check query
    @from=query[:height_from]-1.27
    @to= query[:height_to]+1.27
end

def except_ids
 @sex=  current_user.profile.gender=='Male' ? 'Female': 'Male'
 #seperating interest sent, received & admins/manager
 except_user_ids=  []
 except_user_ids.push(current_user.id) 
 @ids=except_user_ids.uniq{|x| x}
end

end
