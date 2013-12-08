# Need this to have the right IP address for accessing Moniker via API
require "moniker/api/version"
require 'nokogiri'
require 'open-uri'

class NokogiriWrap
  def get(loc); Nokogiri::HTML.parse(open('http://www.google.com/search?q=sparklemotion')); end
end

module Moniker
  module Api
    def initialize(token, password)
      @token = token
      @password = password
      @domains  = nil
      if(ENV["ssh_host")
        @agent = ProxySSH.new(ENV["ssh_host"], ENV["ssh_user"], ENV["ssh_password"])
      else
        @agent = NokogiriWrap.new
      end
    end
    
    def agent; @agent; end
    def domains
      agent.get("http://api.moniker.com/pub/ExternalApi?cmd=domainsearch&account=#{@token}&password=#{@password}&client-ref=myrefnumber&action=all")
      agent.parser.xpath('//domain').collect { |e| { :name => e.text.downcase,
                                                    :ns1 => e.attribute('ns1').value,
                                                    :ns2 => e.attribute('ns2').value,
                                                    :ns3 => e.attribute('ns3').value,
                                                    :ns4 => e.attribute('ns4').value,
                                                    :ns5 => e.attribute('ns5').value,
                                                    :ns6 => e.attribute('ns6').value  } }
    end
    def register_domain(domain, nameservers, nic)
      dom_string = "#{domain}:1" # For multiple: test1.com:1;test2.com:1 -- 1 = years to reg for
      # nic = # 129879
      res = agent.get("http://api.moniker.com/pub/ExternalApi?cmd=domainregister&account=#{@token}&password=#{@password}&client-ref=myrefnumber&Lock_Req=YES&Agree=YES&domains=#{dom_string}&Admin_Nic=#{nic}&Bill_Nic=#{nic}&Tech_Nic=#{nic}&Reg_Nic=#{nic}&Primary_NS=#{nameservers.first}&Secondary_NS=#{nameservers[1]}&category=RightDomainer.com")
      raise "Domain Unavailable" if res.text =~ /All Domains Unavailable/
    end
    def update_domain(domain, nameservers)
      dom_string = "#{domain}"
      res = agent.get("http://api.moniker.com/pub/ExternalApi?cmd=domainupdate&account=#{@token}&password=#{@password}&client-ref=myrefnumber&Agree=YES&domains=#{dom_string}&Primary_NS=#{nameservers.first}&Secondary_NS=#{nameservers[1]}&Tertiary_NS=&Quaternary_NS=&Quintenary_NS=&Sextenary_NS=")
      puts res
      raise "Domain not updated" unless res.text =~ /Success/
    end
    def domain_details(domain)
      dom_string = "#{domain}"
      agent.get("http://api.moniker.com/pub/ExternalApi?cmd=domaininfo&account=#{@token}&password=#{@password}&client-ref=myrefnumber&domain=#{dom_string}")
    end
    def domain_available?(domain)
      agent.get("http://api.moniker.com/pub/ExternalApi?cmd=domaincheck&account=#{@token}&password=#{@password}&client-ref=myrefnumber&domains=#{dom_string}")
      agent.page.body !~ /Domain Unavailable/
    end
  end
end
