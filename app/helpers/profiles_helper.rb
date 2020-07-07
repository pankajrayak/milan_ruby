module ProfilesHelper
    def partner_options
        s = ''
        Partner.all.each do |item|
          s << "<option value='#{item.name}'>#{item.name}</option>"
        end
        s.html_safe
      end
    def jobstatus_options
        s=''
     Jobstatus.all.each do |item|
        s << "<option value='#{item.name}'>#{item.name}</option>"
      end
      s.html_safe
    end
    def relationship_options
        s=''
     Relationship.all.each do |item|
        s << "<option value='#{item.name}'>#{item.name}</option>"
      end
      s.html_safe
    end
    def interest_options
        s=''
    ['Acting','Baking','Calligraphy','Creative writing','Crossword','Dance','Ice skating','Gun Smithing','Gaming']
     .each do |item|
        s << "<option value='#{item}'>#{item}</option>"
      end
      s.html_safe
    end
end
