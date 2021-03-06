require 'net/http'

require 'spec_helper'

describe_vagrant_box "cloud", :basebox_filter => /^quantal/ do

  context "running OpenStack Dashboard" do

    let(:base) { "http://localhost:8080/horizon" }

    def get(path)
      uri = URI.parse(base)
      tries = 50
      begin
        Net::HTTP.get(uri.host, uri.path + path, uri.port)
      rescue Errno::ECONNRESET
        tries -= 1
        if tries > 0
          sleep 0.2
          retry
        end
        raise
      end
    end

    it "presents a login screen" do
      get('/').should include('<title>Login - OpenStack Dashboard</title>')
    end

  end

end
