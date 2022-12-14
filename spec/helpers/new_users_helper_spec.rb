require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the NewUsersHelper. For example:
#
# describe NewUsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe NewUsersHelper, type: :helper do
  it "does something" do
    expect(3).to eq(3)
  end
end
