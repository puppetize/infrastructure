require 'net/http'

require 'spec_helper'

shared_examples "OpenStack cloud controller behavior" do

  describe "OpenStack Dashboard" do

    it "presents login screen at /horizon" do
      fragment = '<title>Login - OpenStack Dashboard</title>'
      Net::HTTP.get('localhost', '/horizon', 8080).should include(fragment)
    end

  end

end

describe "Vagrant box 'cloud'", :slow => true do

  def vagrant(command)
    output = nil
    workdir = File.expand_path("../../../boxes/cloud", __FILE__)
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

    include_examples "OpenStack cloud controller behavior"

  end

  context %{when started}, :thorough => false do

    before :all do
      vagrant "up"
    end

    include_examples "OpenStack cloud controller behavior"

  end

end
