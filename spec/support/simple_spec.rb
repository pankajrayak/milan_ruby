class Simple
    attr_accessor :message
    def initialize()
        puts 'crate a simple message\n'
        @message = "how dud"
    end

    def update_message(new_message)
        @message = new_message
    end
end

describe 'simple class' do
    before (:each) do
        @simpleClass = Simple.new
    end

    it "should show message" do
        expect(@simpleClass).to_not be_nil
    end

    it "should update message" do
        @simpleClass.update_message('hello')
        expect(@simpleClass.message).to_not be "how dud"      
    end
end