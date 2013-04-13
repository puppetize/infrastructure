require 'spec_helper'

shared_examples "'vagrant' box behavior" do

  it "has a Vagrant 1.0.x executable in PATH" do
    regexp = /^Vagrant version 1\.0\.\d+\n$/
    vagrant("ssh -c 'vagrant -v'").should match(regexp)
  end

  it %{has a "vagrant basebox" command} do
    regexp = /^\s+basebox$/m
    vagrant("ssh -c 'vagrant -h'").should match(regexp)
  end

end

describe "Vagrant box 'vagrant'", :slow => true do

  def vagrant(command)
    output = nil
    workdir = File.expand_path("../../../../boxes/vagrant", __FILE__)
    Dir.chdir(workdir) { output = `vagrant #{command} 2>&1` }
    unless $?.success?
      fail %{"vagrant #{command}" failed in #{workdir}:\n#{output}}
    end
    output
  end

  context "when recreated from scratch", :thorough => true do

    before :all do
      ["destroy -f", "up"].each { |command| vagrant command }
    end

    after :all do
      vagrant "destroy -f"
    end

    include_examples "'vagrant' box behavior"

  end

  context %{when started}, :thorough => false do

    before :all do
      vagrant "up"
    end

    include_examples "'vagrant' box behavior"

  end

end
