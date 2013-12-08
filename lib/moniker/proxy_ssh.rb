#!/usr/bin/env ruby
require 'rubygems'
require 'net/ssh'
require 'escape'

module Moniker
  class ProxySSH
    def initialize(host, user, pass)
      @host, @user, @pass = [host, user, pass]
      @page = nil
    end
    def check
      results = ""
      Net::SSH.start( @host, @user, :password => @pass ) do|ssh|
        results = ssh.exec!('ls')
      end
      results != ""
    end
    def get(loc)
      stdout = ""
      Net::SSH.start( @host, @user, :password => @pass ) do|ssh|
        # Warning! So not safe this is. OK... with Escape maybe better?
        ssh.exec!(Escape.shell_command(["curl", loc]).to_s) do |channel, stream, data|
          stdout << data if stream == :stdout
        end
        @parser = Nokogiri::XML.parse(stdout, nil, nil)
      end
      @parser
    end
    attr_reader :parser
  end
end
