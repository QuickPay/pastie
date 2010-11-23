require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe "Paste Model" do
  let(:paste) { Paste.new }
  it 'can be created' do
    paste.should_not be_nil
  end
end
