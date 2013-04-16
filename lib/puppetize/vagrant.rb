module Puppetize
  module Vagrant

    class Box

      def initialize(name, basebox = nil)
        @workdir = "#{Puppetize::Vagrant.boxesdir}/#{name}"
        @basebox = basebox
      end

      def run(command)
        command = "vagrant #{command}"

        if @basebox
          command = "env BASEBOX=#{@basebox} #{command}"
        end

        output = nil

        Dir.chdir(@workdir) { output = `#{command} 2>&1` }
        unless $?.success?
          fail %{"#{command}" failed in #{@workdir}:\n#{output}}
        end

        output
      end

      def up?
        run('status') =~ /VM is running/ ? true : false
      end

    end

    def self.box(name, basebox = nil)
      Box.new(name, basebox)
    end

    def self.boxesdir
      File.expand_path '../../../boxes', __FILE__
    end

    def self.baseboxes
      Dir.glob("#{boxesdir}/base/definitions/*/definition.rb").map { |file|
        File.basename File.dirname(file)
      }
    end

    def self.basebox_word_size(basebox)
      basebox.end_with?("64") ? 64 : 32
    end

    def self.host_word_size
      ['a'].pack('P').length > 4 ? 64 : 32
    end

    def self.baseboxes_for_host
      baseboxes.select { |basebox| basebox_word_size(basebox) == host_word_size }
    end
  end
end
