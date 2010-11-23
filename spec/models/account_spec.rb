require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe "Account Model" do
  let(:account) { Account.new }
  it 'can be created' do
    account.should_not be_nil
  end
end
