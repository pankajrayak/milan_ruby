module CustomMethods
  
    def self.convert_to_float(height)
        @height_in_cm=''
                if(height!=nil && height!='')
                    if(height.to_s.split("'")[1].nil?)
                            @height_in_cm=height.to_i*30.48
                    return @height_in_cm.to_f
                    else
                            @height_in_cm=height.to_s.split("'")[0].to_f*30.48 + height.to_s.split("'")[1].to_f*2.54
                    return @height_in_cm.to_f
                    end
                end
            end
        
        
        def self.convert_to_feet(height=0.0)
            
            @height_in_feet=''
            if(height!=nil && height!='')
                @height_in_feet= (height/30.48).to_i.to_s
                unless ((height%30.48).round(2)==30.48)
                @height_in_feet=@height_in_feet.concat("'").concat(((height%30.48).round(2)/2.54).to_f.round.to_s)
                end
                return @height_in_feet
            end
        end

        def self.format_conversation(messages,conversation,current_user,type)
            messages_list=[]
            messages.each do |message|
                
                item=Hash.new
                item[:sender_id]=message.sender_id
                item[:current_id]=current_user.id
                item[:message]=message.body
                item[:conv_id]=conversation.id
                item[:user_type]=type
                item[:subject]=conversation.subject
                item[:time]=message.created_at
               # item[:mailbox_type]=conversation.receipts.where(:receiver_id => current_user.id).first.mailbox_type
                item[:receiver_name]=conversation.receipts.reject { |p| p.receiver.id == current_user.id }.collect {|p| ("#{p.receiver.first_name} #{p.receiver.last_name }")}.uniq.join(" ,")
                if message.sender_id==current_user.id
                    item[:sender_name]="#{current_user.first_name} #{current_user.last_name}"
                    messages_list.push(item)
                else
                begin
                    user = User.find(message.sender_id)
                    item[:sender_name]="#{user.first_name} #{user.last_name}"
                    messages_list.push(item)
                rescue => exception
                    
                end
                    
                    
                end
               
              end
              
              messages_list

        end

        def self.standard_date(age,value) #for handling date's => 1986-01-01 to 1996-12-31
            year= Date.today.year - age.to_i
            result= value ?  year : Date.new(year-1, 12, 31).to_s 
          end



        def self.convert_to_age(birthday)
            now = Time.now.utc.to_date
            now.year - birthday.to_date.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
        end

            #seperated Values
        def self.array_seperator(list)
            list.select(&:present?).join(',')
        end

        def self.manager_statement(state,user, link)
            message=''
            name=user.first_name
            case state 
            when 'accepted'   
            message=I18n.t('mailboxer.manager.accepted',name: name)      
            when 'rejected'
                message=I18n.t('mailboxer.manager.rejected',name: name)
            when 'need_more_info'
                message=I18n.t('mailboxer.manager.need_more_info',name: name ,link: link)
            end
            message
        end


        def self.member_statement(state,user, link)
            message=''
            name=user.first_name
            sex= CustomMethods.find_gender(user.profile.gender)
            case state 
            when 'new'   
            message=I18n.t('mailboxer.member.new', name: name, link: link, sex: sex)      
            when 'rejected'
            message=I18n.t('mailboxer.member.rejected',name: name ,link: link, sex: sex) 
            when 'being_reviewed'
            message=I18n.t('mailboxer.member.being_reviewed',name: name ,link: link, sex: sex)
            end
            message
        end

        def self.find_gender(gender)
            his_or_her=('Male'.downcase.eql?gender.downcase)? 'his' : 'her'
        end
        
        def self.admin_statement(state,user, link)
            message=''
            first_name=user.first_name
            case state 
            when 'accepted'   
            message=I18n.t('mailboxer.admin.accepted', name: first_name)      
            when 'rejected'
                message=I18n.t('mailboxer.admin.rejected',name: first_name )
            when 'need_more_info'
                message=I18n.t('mailboxer.admin.need_more_info',name: first_name ,link: link)
            end
            message
        end
 
end