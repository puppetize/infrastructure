#!/usr/bin/env ruby

module Bacula
end

class Bacula::Console
  END_OF_COMMAND = '@# end of command'

  def initialize(cmd='bconsole -n')
    # Run the Bacula console process in the backround.
    @pipe = IO.popen(cmd, 'r+')

    # Discard the initial output from the console.
    @pipe.puts END_OF_COMMAND
    while line = @pipe.gets.chomp
      break if line == END_OF_COMMAND
    end
  end

  # Return the list of defined clients.
  def clients
    command('.clients').split("\n")
  end

  # Return the list of defined job names.
  def jobs
    command('.jobs').split("\n")
  end

  # Run a backup job and return the job id.
  def run(job)
    resp = command %{run job="#{job}" yes}
    expr = /^Job queued. JobId=(\d+)$/
    if resp =~ expr
      $1.to_i
    else
      raise "Command error:" + \
            " expected #{expr.inspect}," + \
            " got #{resp.inspect}"
    end
  end

  # Wait for the specified job and return a one-letter status code.
  def wait(jobid)
    resp = command %{wait jobid="#{jobid}"}
    expr = /^JobStatus=.*\((.)\)$/
    if resp =~ expr
      $1
    else
      raise "Command error:" + \
            " expected #{expr.inspect}," + \
            " got #{resp.inspect}"
    end
  end

  # Execute a Bacula console command and return the command's
  # response as a string.
  def command(cmdline)
    @pipe.puts cmdline
    if (line = @pipe.gets.chomp) != cmdline
      raise "Communication error:" + \
            " expected #{cmdline.inspect}," + \
            " got #{line.inspect}"
    end

    response = ''
    @pipe.puts END_OF_COMMAND
    while line = @pipe.gets
      if line.chomp.end_with?(END_OF_COMMAND)
        response << line.chomp.chomp(END_OF_COMMAND)
        break
      else
        response << line
      end
    end

    response
  end
end

if $0 == __FILE__
  require 'irb'

  IRB.start
end
