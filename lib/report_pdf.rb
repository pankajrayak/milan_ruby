class ReportPdf < Prawn::Document
    def initialize(user_record)
      super()
      @user_data = user_record
      header
      text_content
      table_content
    end
  
    def header
      #This inserts an image in the pdf file and sets the size of the image
      image "#{Rails.root}/app/assets/images/logo.png", width: 90, height: 50
    end
  
    def text_content
      # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
      y_position = cursor - 50
  
      # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
      bounding_box([0, y_position], :width => 520, :height => 300) do
        text "Lorem ipsum", size: 15, style: :bold
        text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse interdum semper placerat. Aenean mattis fringilla risus ut fermentum. Fusce posuere dictum venenatis. Aliquam id tincidunt ante, eu pretium eros. Sed eget risus a nisl aliquet scelerisque sit amet id nisi. Praesent porta molestie ipsum, ac commodo erat hendrerit nec. Nullam interdum ipsum a quam euismod, at consequat libero bibendum. Nam at nulla fermentum, congue lectus ut, pulvinar nisl. Curabitur consectetur quis libero id laoreet. Fusce dictum metus et orci pretium, vel imperdiet est viverra. Morbi vitae libero in tortor mattis commodo. Ut sodales libero erat, at gravida enim rhoncus ut."
      end
  
      # bounding_box([300, y_position], :width => 270, :height => 300) do
      #   text "Duis vel", size: 15, style: :bold
      #   text "Duis vel tortor elementum, ultrices tortor vel, accumsan dui. Nullam in dolor rutrum, gravida turpis eu, vestibulum lectus. Pellentesque aliquet dignissim justo ut fringilla. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut venenatis massa non eros venenatis aliquet. Suspendisse potenti. Mauris sed tincidunt mauris, et vulputate risus. Aliquam eget nibh at erat dignissim aliquam non et risus. Fusce mattis neque id diam pulvinar, fermentum luctus enim porttitor. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
      # end
  
    end
  
    def table_content
     
      pad_top(20) { text "User Info", size: 15, style: :bold  }
      stroke_horizontal_rule
      move_down 30
      table user_rows do
        row(0).font_style = :bold
        self.header = true
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.cell_style = { size: 6 }
        self.column_widths = [20,100, 100, 100,100]
        #self.width=720
      end

      pad_top(20) { text "Profile Info", size: 15, style: :bold }
      stroke_horizontal_rule
      move_down 30

      table profile_rows do
        row(0).font_style = :bold
        self.header = true
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.cell_style = { size: 6 }
        self.column_widths = [20,60,60,60,40,60,40,50,60,50]
        #self.width=640
      end

      pad_top(20) { text "Image Info", size: 15, style: :bold }
      stroke_horizontal_rule
      move_down 30
      table image_rows do
        row(0).font_style = :bold
        self.header = true
        self.cell_style = { size: 6 }
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [20,60, 140,80]
      end

    end


  
    def user_rows
      [['#', "Email", "First Name", "Last Name", "Region"]] + 
      [[1, @user_data.email, @user_data.first_name,  @user_data.last_name, @user_data.region]]
    end

    def profile_rows
      [['#',"Facebook","Instagram","Linkedin","Community","Country","State","City","Mobile Number","Phone Number","DOB"]] + 
      [[1, @user_data.profile.facebook, @user_data.profile.instagram,@user_data.profile.linkedin,@user_data.profile.community,@user_data.profile.country,@user_data.profile.state,@user_data.profile.city,@user_data.profile.mobile_number,@user_data.profile.phone_number,@user_data.profile.dob]]
      
    end
    def image_rows
      [['#', 'Photo Type', 'Url',"Uploaded On"]] + 
        @user_data.photos.map.with_index do |product,index|
        [index+1, product.photo_for, product.url, product.updated_at.to_s]
      end
    end
  end