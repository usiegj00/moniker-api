#!/usr/bin/env ruby
require 'rubygems'
require 'net/ssh'
require 'escape'

class ProxySSH
  def initialize(host, user, pass)
    @host, @user, @pass = [host, user, pass]
    @page = nil
  end
  def check
    results = ""
    Net::SSH.start( HOST, USER, :password => PASS ) do|ssh|
      result = ssh.exec!('ls')
      # puts result
      # forward connections on local port 1234 to port 80 of www.capify.org
      #ssh.forward.local(1234, "www.capify.org", 80)
      #ssh.loop { true }
    end
    resuts != ""
  end
  def get(loc)
    stdout = ""
    Net::SSH.start( @host, @user, :password => @pass ) do|ssh|
      # Warning! So not safe this is. OK... with Escape maybe better?
      ssh.exec!(Escape.shell_command(["curl", loc]).to_s) do |channel, stream, data|
        stdout << data if stream == :stdout
      end
      @parser = Nokogiri::HTML.parse(stdout, nil, nil)
    end
    @parser
  end
  attr_reader :parser
end
