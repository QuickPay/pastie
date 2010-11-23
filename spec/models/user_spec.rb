require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe "User Model" do
  let(:user) { User.new }
  it 'can be created' do
    user.should_not be_nil
  end
end
