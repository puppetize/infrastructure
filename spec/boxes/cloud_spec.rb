require 'net/http'

require 'spec_helper'

describe_vagrant_box "cloud", :basebox_filter => /^quantal/ do

  context "with OpenStack Dashboard" do

    let(:base) { "http://localhost:8080/horizon" }

    def get(path)
      uri = URI.parse(base)
      Net::HTTP.get(uri.host, uri.path + path, uri.port)
    end

    it "presents a login screen" do
      get('/').should include('<title>Login - OpenStack Dashboard</title>')
    end

  end

end
