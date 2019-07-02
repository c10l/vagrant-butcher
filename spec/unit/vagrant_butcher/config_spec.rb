require 'spec_helper.rb'

describe Vagrant::Butcher::Config do
  subject { described_class.new }

  it "permits the user to (en|dis)able the plugin" do
    expect(subject).to respond_to(:enabled=)
  end

  it "has the option to set guest chef client pem path" do
    expect(subject).to respond_to(:guest_key_path=)
  end

  it "has the option to verify SSL certs" do
    expect(subject).to respond_to(:verify_ssl=)
  end

  it "allows the user to configure a proxy" do
    expect(subject).to respond_to(:proxy=)
  end

  it "has an option to set a custom client_name" do
    expect(subject).to respond_to(:client_name=)
  end

  it "has an option to point to a local client key" do
    expect(subject).to respond_to(:client_key=)
  end

  it "does not have the option to set knife.rb path" do
    expect(subject).to_not respond_to(:knife_config_file=)
  end

  it "does not have the option to set cache dir path" do
    expect(subject).to_not respond_to(:cache_dir=)
  end

  it "sets guest chef client pem default path" do
    subject.finalize!
    expect(subject.guest_key_path).to eql(:DEFAULT)
  end

  it "sets cache dir path" do
    subject.finalize!
    expect(subject.cache_dir).to eql(".vagrant/butcher")
  end
end
