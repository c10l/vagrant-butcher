require 'spec_helper.rb'

describe Vagrant::Butcher::Config do
  subject { described_class.new }
  
  it "has the option to set knife.rb path" do
    subject.should respond_to(:knife_config_path)
  end
  
  it "sets knife.rb default path" do
    subject.finalize!.should eql(File.expand_path("#{ENV['HOME']}/.chef/knife.rb"))
  end
  
  describe "#validate" do
    let(:env)     { double('env') }
    let(:config)  { double('config', butcher: subject) }
    let(:machine) { double('machine', config: config, env: env) }
    let(:result)  { subject.validate(machine) }
    
    context "when validations pass" do
      before(:each) do
        File.should_receive(:exists?).with(subject.knife_config_path).and_return(true)
      end

      it "contains an empty Array for the 'butcher configuration' key" do
        result["butcher configuration"].should be_a(Array)
        result["butcher configuration"].should be_empty
      end
    end
    
    context "when validations fail" do
      before(:each) do
        File.should_receive(:exists?).with(subject.knife_config_path).and_return(false)
      end

      it "contains an empty Array for the 'butcher configuration' key" do
        result["butcher configuration"].should be_a(Array)
        result["butcher configuration"].should_not be_empty
      end
    end
  end
end
