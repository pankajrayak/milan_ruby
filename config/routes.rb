Rails.application.routes.draw do
  
  mount_devise_token_auth_for 'User', at: 'auth',
  controllers:{
    registrations: 'registrations',
    confirmations: 'confirmations',
    sessions: 'sessions'
  }


  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/  do
  resources :match do
    collection do
  get 'index', to: "match#index"
  post 'requests', to: "match#requests"
  get 'search', to: "match#search"
  get 'search_user' , to: "match#search_user"
  get 'match_list(/:user_id)' , to: "match#match_list"
  get 'search_result' , to: "match#search_result"
  
        end
      end
  # resources :guest, :only=>[:create, :new]
 
  get 'regional/index'
  get 'regional/show'
  devise_scope :user do
  get 'registrations/select_options'
  get 'registrations/get_states'
  get 'registrations/get_cities'
  get 'registrations/contact_info'
  get 'registrations/get_country_region'
  post 'registrations/contact_us'
  post 'registrations/resend_email'
  end

  resources :profiles do
    collection do
      get 'profile_info(/:user_id)', to:'profiles#profile_info'
      get 'interest_count', to:'profiles#interest_count'
      get 'interests(/:user_id)/:type', to:'profiles#interest'
      get 'profile_status(/:user_id)', to:'profiles#profile_status'
      get 'user_info', to:'profiles#user_info'
      get :regional_managers, param: :user_id
      post :check_email
      post :profile_photos
      get :get_roles
      post :request_export
     end
  end
 
  
  resources :interests do
    collection do
      post :send_request  #, params: :user_id
      post :respond
      post :send_reminder
      get :all_interests
    end
  end
  resources :photos do
    collection do
      get :show_photos
    end
  end
  resources :admin do 
    collection do
      get :request_count, param: :state
      get :request_state , param: :state
      get :get_regional_managers
      get :portal_members
      get :getprofile
      get :inbox
      get :inbox_count
      get :conversation
      post :update_profile_workflow
      post :workflow_action
      get :region_selection
      post :manager_regions
      get :generate_report
      get :export_user_list
      post :create_manager
    end
  end 
 
  get 'admin/manager',to: "admin#show", as: "manager" 
  get 'connections', to: "profiles#connections"
  get 'connectionprofile', to: "profiles#connection_profile"
  get 'conversations/receiveuser', to: "conversations#receiveuser"
  post 'conversations/destroy_conversation', to: "conversations#destroy_conversation"
  get 'conversations/get_conversations', to: "conversations#get_conversations"
  get 'conversations/get_workflow_history', to: "conversations#get_workflow_history"
  get 'regional/my_assignments', to: "regional#my_assignments"
  get 'regional/getprofile', to: "regional#getprofile"
  post 'regional/update_profile_workflow', to: "regional#update_profile_workflow"
  get 'regional/inbox', to: "regional#inbox"
  get 'regional/conversation', to: "regional#conversation"
  get 'conversations/messages_count', to: "conversations#messages_count"
  delete 'delete_user',to: "admin#delete_user"
  delete 'delete_active_user',to: "regional#delete_active_user"
  resources :photos do
    collection do
      post :request_photo
      post :approve_photo
    end
  end
  post 'admin/add' #=> 'script#index'
  get 'conversations/index/:message_box', to: "conversations#index"
  get 'conversations'=> redirect("/conversations/index")
  get 'conversations/show'
  get 'conversations/sent'
  
  resources :payment do
    collection do
    post :create_card
  end
  end

  resources :conversations, only: [:index, :show, :destroy] do
    member do
      post :reply
      post :workflow_reply
      post :restore
      post :mark_as_read
    end
    collection do
      delete :empty_trash
      post :send_message
    end
  end

end

  mount ActionCable.server => '/cable'
end
