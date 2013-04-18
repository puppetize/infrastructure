require 'puppetize/vagrant'

RSpec.configure do |config|
  unless config.filter.has_key? :basebox
    case excluded_basebox = config.exclusion_filter[:basebox]
    when '', nil
      # No exclusion filter specified; exclude non-default baseboxes.
      config.filter_run_excluding :basebox => lambda { |v| v != :default }
    when 'default'
      # Default basebox excluded; specific baseboxes are not excluded.
    else
      # Sepcific basebox excluded; also exclude the default basebox.
      config.exclusion_filter.delete :basebox
      config.filter_run_excluding :basebox => lambda { |v|
        [:default, excluded_basebox].include? v
      }
    end
  end
end

def describe_vagrant_box(box, options = {}, &block)
  baseboxes = Puppetize::Vagrant.baseboxes_for_host.select { |basebox|
    case options[:basebox_filter]
    when Regexp
      basebox.match options[:basebox_filter]
    when String
      basebox == options[:basebox_filter]
    when NilClass
      true
    else
      raise ArgumentError, "invalid basebox_filter: " +
        options[:basebox_filter].inspect
    end
  }

  describe "Vagrant box '#{box}'", :slow => true do

    define_method(:vagrant) do |command, basebox = nil|
      Puppetize::Vagrant.box(box, basebox).run command
    end

    define_method(:vagrant_box_exists?) do
      Puppetize::Vagrant.box(box).exists?
    end

    define_method(:vagrant_box_is_up?) do
      Puppetize::Vagrant.box(box).up?
    end

    context "with any basebox", :basebox => :default do

      before :all do
        if vagrant_box_is_up?
          @vagrant_box_was_up = true
        elsif vagrant_box_exists?
          @vagrant_box_was_up = false
          vagrant "up --no-provision"
        else
          @vagrant_box_was_up = false
          vagrant "up"
        end
      end

      after :all do
        vagrant "halt" unless @vagrant_box_was_up
      end

      module_eval(&block)

    end

    baseboxes.each do |basebox|

      context("with basebox #{basebox}", :basebox => basebox) do

        before :all do
          vagrant 'destroy -f'
          vagrant 'up', basebox
        end

        after :all do
          vagrant "destroy -f"
        end

        module_eval(&block)

      end

    end
  end
end
