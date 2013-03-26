require 'spec_helper.rb'

describe Vagrant::Butcher::Config do
  subject { described_class.new }
  
  it "sets knife_config to ~/.chef/knife.rb by default" do
    subject.knife_config.should eql("#{ENV['HOME']}/.chef/knife.rb")
  end
end
