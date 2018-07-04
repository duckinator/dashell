#!/usr/bin/env ruby

require "shell"
require "shellwords"

class Dashell < Shell
  def initialize
    Shell.verbose = false # Why does Shell default to verbose?
    super()
    at_exit { finish_all_jobs }
    rehash
  end

  def run
    loop { handle_line }
  end

  def rehash
    super()
    Shell.install_system_commands()
    nil
  end

  def handle_line
    print "#{cwd}$ "

    input = $stdin.gets
    exit if input.nil? # Ctrl-D.

    command, *args = Shellwords.split(input)
    return if command.nil?

    command = "sys_#{command}" if respond_to?("sys_#{command}")

    puts send(command, *args)
  rescue Interrupt # Ctrl-C.
    puts
  rescue => e
    puts "#{e.class}: #{e.message}"
  end
end

Dashell.new.run if $0 == __FILE__
