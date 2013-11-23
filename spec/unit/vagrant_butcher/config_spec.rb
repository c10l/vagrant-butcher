require 'spec_helper.rb'

describe Vagrant::Butcher::Config do
  subject { described_class.new }

  it "does not have the option to set knife.rb path" do
    subject.should_not respond_to(:knife_config_file)
  end

  it "has the option to set guest chef client pem path" do
    subject.should respond_to(:guest_key_path)
  end

  it "has the option to set cache dir path" do
    subject.should respond_to(:cache_dir)
  end

  it "sets guest chef client pem default path" do
    subject.finalize!
    subject.guest_key_path.should eql('/etc/chef/client.pem')
  end

  it "sets cache dir default path" do
    subject.finalize!
    subject.cache_dir.should eql(File.expand_path(".vagrant/butcher"))
  end
end
