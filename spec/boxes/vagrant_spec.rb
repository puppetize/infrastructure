require 'spec_helper'

describe_vagrant_box "vagrant" do

  it "has a Vagrant 1.0.x executable in PATH" do
    regexp = /^Vagrant version 1\.0\.\d+\n$/
    vagrant("ssh -c 'vagrant -v'").should match(regexp)
  end

  it %{has a "vagrant basebox" command (VeeWee)} do
    regexp = /^\s+basebox$/m
    vagrant("ssh -c 'vagrant -h'").should match(regexp)
  end

end
