require 'spec_helper.rb'

describe Vagrant::Butcher::Config do
  subject { described_class.new }

  it "permits the user to (en|dis)able the plugin" do
    subject.should respond_to(:enabled=)
  end

  it "has the option to set guest chef client pem path" do
    subject.should respond_to(:guest_key_path=)
  end

  it "has the option to verify SSL certs" do
    subject.should respond_to(:verify_ssl=)
  end

  it "allows the user to configure a proxy" do
    subject.should respond_to(:proxy=)
  end

  it "has an option to set a custom client_name" do
    subject.should respond_to(:client_name=)
  end

  it "has an option to point to a local client key" do
    subject.should respond_to(:client_key=)
  end

  it "does not have the option to set knife.rb path" do
    subject.should_not respond_to(:knife_config_file=)
  end

  it "does not have the option to set cache dir path" do
    subject.should_not respond_to(:cache_dir=)
  end

  it "sets guest chef client pem default path" do
    subject.finalize!
    subject.guest_key_path.should eql(:DEFAULT)
  end

  it "sets cache dir path" do
    subject.finalize!
    subject.cache_dir.should eql(".vagrant/butcher")
  end
end
