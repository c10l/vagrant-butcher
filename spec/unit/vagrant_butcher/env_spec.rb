require 'spec_helper.rb'

describe Vagrant::Butcher::Env do
  subject { described_class.new }

  it "is a valid Vagrant UI object" do
    subject.ui.should be_a Vagrant::UI::BasicScope
  end
end
