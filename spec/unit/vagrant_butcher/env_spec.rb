require 'spec_helper.rb'

describe Vagrant::Butcher::Env do

  subject { described_class.new }

  it "is a valid Vagrant 1.5+ UI object" do
    subject.ui.should be_a(Vagrant::UI::Colored)
  end

end
