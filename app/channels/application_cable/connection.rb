module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
 
    def connect
      self.current_user = find_verified_user
    end
 
    private
      def find_verified_user
        puts request.params[:'access-token']
        puts request.params[:client]
        puts request.params[:email_id]
        access_token = request.params[:'access-token']
        email_id = request.params[:email_id]
        client=request.params[:client]
        verified_user = User.find_by(email: email_id)
        if verified_user && verified_user.valid_token?(access_token, client)
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
