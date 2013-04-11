# Utility functions for Rake tasks

# Run a shell command as root, using "sudo" iff necessary.
def sudo(cmdline, &block)
  cmdline = "sudo #{cmdline}"unless Process.uid == 0
  sh cmdline, &block
end

# Find an executable in PATH and return the absolute path.
def which(command)
  if File.basename(command) != command
    File.executable?(command) ? command : nil
  else
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      if File.executable? File.join(path, command)
        return File.join(path, command)
      end
    end
    nil
  end
end
