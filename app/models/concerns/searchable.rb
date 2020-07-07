module Searchable
  extend ActiveSupport::Concern
 
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
   
    
    settings index: { number_of_shards: 5 } do
    mapping dynamic: false do

    indexes :first_name, type: :text
    indexes :last_name, type: :text
    indexes :expiration_date, type: :date
    indexes :id, type: :integer
    indexes :profile, type: 'nested' , include_in_parent: true do
      indexes :gender, type: :text
      indexes :height, type: :float
      indexes :education_level, type: :text
      indexes :marital_status, type: :text
      indexes :dob, type: :date
      indexes :have_children, type: :text
      indexes :country, type: :text,analyzer: :keyword
      indexes :state, type: :text,analyzer: :keyword
      indexes :profile_state, type: :text
    end
    indexes :user_roles, type: 'nested' , include_in_parent: true do
      indexes :role_id, type: :integer
    end
    # indexes :partner_preference, type: 'nested', include_in_parent: true do
    #   indexes :deal_breaker, type: 'nested', include_in_parent: true
    # end
    # indexes :profile, type: 'nested' , include_in_parent: true do
    # indexes :gender, type: :text
    # indexes :height, type: :float
    # indexes :member_relationship, type: :text
    # end
      
    end
  end
 
  def self.pagination_panel(size,page)
      
    from=(size*(page-1))
  end

  def self.assignment_filter(query)
    min_count=1 
    %i(  status  gender name ).all?{|key|  min_count= query[key].present? ?  min_count+1 : min_count }
      if(query[:age_from].present? && query[:age_to].present?)
        min_count=min_count+1
      end
    min_count= (query[:region] !=0) ? min_count+1 : min_count
    sex=query[:sex]
    self.search({
       query: {
           bool:{
            "should":[
                {
                "match":{"profile.gender":sex}
                },
                {
                  "match":{"first_name":query[:name]}
                },
                {
                  "match":{"region":query['region'].to_i} 
                },
                {
                  "match":{"profile.profile_state":query['status']}
                },
                {  "range": {
                      "profile.dob":{
                      "gte":query['age_to'],
                      "lt":query['age_from'],
                      "format":"yyyy-MM-dd||yyyy"
                                     }
                            }
                }
              ],
              "minimum_should_match": min_count
            }
        }
    })
  end

#working for Partner Search
    def self.search_partner(query,sex,id)
      min_count=0
      size=10
    
      from= User.pagination_panel(size,query[:from].to_i)
      %i(marital_status have_children education_level name community ).all?{|key|  min_count= query[key].present? ?  min_count+1 : min_count }
      
      country_query={match:{"profile.country": ""}}
      state_query={match:{"profile.state":""}}
      if query[:country].present?
          country_arr=query[:country].split(",")
            if country_arr.length>1
            country_query={"terms":{
                "profile.country": country_arr
              }}
            else
              country_query={match:{"profile.country": country_arr[0]}}
            end
            min_count+=1
        end
        if query[:state].present?
            state_arr=query[:state].split(",")
            if state_arr.length>1
            state_query={"terms":{
                "profile.state": state_arr
              }}
            else
            state_query={match:{"profile.state": state_arr[0]}}
            end
            min_count+=1
        end
      self.search({
        "from": from,
        "size": size,
         query: {
             bool:{
              "filter": {
                "bool": {
                  "should": [
                    {
                      "range": {
                        "profile.dob": {
                          "gte":query[:age_to].present? ?  query[:age_to]: nil ,
                          "lte":query[:age_from].present? ? query[:age_from]:nil,
                          "format": "yyyy-MM-dd||yyyy"
                        }
                      }
                    },
                    {
                      "range": {
                        "profile.height": {
                          gte:query[:height_from].present? ?  query[:height_from].to_f : nil,
                          lte:query[:height_to].present? ? query[:height_to].to_f : nil
                        
                        }
                      }
                    }
                  ],
                   "minimum_should_match": 2
                }
              },
              
              "must":[
                  {
                    "match":{"profile.gender":sex}
                  },
                  {
                    "match":{"profile.profile_state":"accepted"}
                  },{
                    "range": {
                      "expiration_date": {
                        "gte": "now"
                      }
                    }
                  }
                ],
                "must_not":[{"terms":
                  {"user_roles.role_id": [2,3]}
                  },{
                  "terms":{"id":id}
                }],
                "should":[
                  country_query,
                  state_query,
                {
                  "match":{"profile.marital_status":query[:marital_status]}
                },
                {
                  "match":{"profile.education_level":query[:education_level]}
                },
                {
                  "match":{"profile.have_children":query[:have_children]}
                },
                { "multi_match": {
                  "query":query[:name], 
                  "fields": ["first_name","last_name"]}
                },
                {
                  "match":{"profile.community":query[:community]}
                }
                ],
                "minimum_should_match": min_count
              }
          }
      })
    end


   

     def self.partner_match(query,sex)
      
        self.search({
          "min_score": 1,
            query: {
               bool:{
                 filter:{
                     range:{
                       height:{
                         gte:query[:height_to].present? ?  query['height_to'] : 80,
                         lte:query[:height_from].present? ?   query['height_from'] :180
                           }
                          }
                       },
                "must":[
                    {
                      "match":{"gender":sex}
                    },
                    {
                      "match":{"marital_status":query['marital_status']}
                    },
                    {
                      "match":{"have_children":query['have_children']}
                    },
                    {
                      "match":{"community":query['community']}
                    },
                   
                   {  "range": {
                      "dob":{
                          "gte":query['age_from'],
                          "lt":query['age_to'],
                          "format":"dd/MM/yyyy||yyyy"
                         }
                       }
                     }
                  
                ]
          
               }
          }
        
      })
    end

  
  end
end