RSpec.describe 'Testing Class' do           #
  it "success" do
       # test code
      class CSWebsite

        # Constructor to initialize
        # the class with a name
        # instance variable
        def initialize(website)
          @website = website
        end

        # Classical get method
        def website
          @website
        end

        # Classical set method
        def website=(website)
        @website = website
        end
      end

       # Creating an object of the class
      gfg = CSWebsite.new "www.geeksforgeeks.org"
      puts gfg.website
      gfg.website = "xalatu.club"
       puts gfg.website


  end

end


