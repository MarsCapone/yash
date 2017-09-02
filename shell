#!/usr/bin/env ruby

require 'pp'
require 'readline'
require 'parslet'
require_relative 'parser'

def main
  prompt = '> '
  loop do
    cmdline = Readline.readline(prompt, true)
    if cmdline == 'exit' then break end
    begin
      tree = parse_cmdline(cmdline)
      pids = tree.execute($stdin.fileno, $stdout.fileno)
      pids.each do |pid|
        Process.wait(pid)
      end
    rescue ArgumentError # exited the shell
      break
    rescue Errno::ENOENT # command doesn't exist
      puts 'That command does not exist: ' + cmdline
    rescue Parslet::ParseFailed # blank line or something
    end
  end
end

def parse_cmdline(cmdline)
  raw_tree = Parser.new.parse(cmdline)
  Transform.new.apply(raw_tree)
end

main
