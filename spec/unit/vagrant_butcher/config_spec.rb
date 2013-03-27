require 'spec_helper.rb'

describe Vagrant::Butcher::Config do
  subject { described_class.new }
  
  it "has the option to set knife.rb path" do
    subject.should respond_to(:knife_config_path)
  end
  
  it "sets knife.rb default path" do
    subject.finalize!.should eql(File.expand_path("#{ENV['HOME']}/.chef/knife.rb"))
  end
end
