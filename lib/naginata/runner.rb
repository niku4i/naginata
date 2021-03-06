require 'naginata/configuration'
require 'naginata/configuration/filter'
require 'sshkit/coordinator'

module Naginata
  class Runner
    def self.run(&block)
      nagios_servers = Configuration.env.filter(Configuration.env.nagios_servers)
      services = Configuration.env.filter_service(Configuration.env.services)
      user = Configuration.env.fetch(:nagios_server_options)[:run_command_as]

      run_backend(nagios_servers) do |nagios_server|
        svcs = Configuration::Filter.new(:nagios_server, nagios_server).filter_service(services)
        if user
          as(user) { yield self, nagios_server, svcs }
        else
          yield self, nagios_server, svcs
        end
      end
    end

    def self.run_locally(&block)
      nagios_servers = Configuration.env.filter(Configuration.env.nagios_servers)
      services = Configuration.env.filter_service(Configuration.env.services)
      nagios_servers.each do  |nagios_server|
        svcs = Configuration::Filter.new(:nagios_server, nagios_server).filter_service(services)
        yield nagios_server, svcs
      end
    end

    private

    def self.run_backend(nagios_servers, options = {}, &block)
      SSHKit::Coordinator.new(nagios_servers).each(options, &block)
    end
  end
end
 
