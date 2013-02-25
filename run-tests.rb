#!/usr/bin/env ruby
# This program helps you testing ownCloud

# Require rubygems, vagrant,
require 'rubygems'
require 'bundler/setup'

require 'rubygems'
require 'vagrant'
require 'cocaine'
require 'mixlib/cli'

# cd to Vagrant folder
Dir.chdir File.join( File.dirname( __FILE__ ), "Vagrant" )


module RunTests
  class Options
    include Mixlib::CLI

    option :branch,
        :short => "-b BRANCH",
        :long => "--branch BRANCH",
        :description => "The branch you want to test"

    option :server,
        :short => "-s SERVER",
        :long => "--server SERVER",
        :description => "The webserver you want to test"

    option :database,
        :short => "-d DATABASE",
        :long => "--database DATABASE",
        :description => "The database"

    option :feature,
        :short => "-f FEATURE",
        :long => "--feature FEATURE",
        :description => "Test only vms with certain features"

    option :action,
        :short => "-a ACTION",
        :long => "--action ACTION",
        :description => "",
        :default => "list"

    option :help,
        :short => "-h",
        :long => "--help",
        :description => "Show this message",
        :on => :tail,
        :boolean => true,
        :show_options => true,
        :exit => 0
  end

  class App
    def initialize
      # Load vagrant
      @vagrant = Vagrant::Environment.new
      @vms = @vagrant.vms
      @vm_names = Array.new
    end

    def filter string, requirement
      requirements = requirement.split /,/

      # Return true if at least one requirement is matched
      requirements.select do |r|
        if r[0] == "!"
          string != r[1..-1]
        else
          string == r
        end
      end.length != 0
    end

    def run
      # Parse command line
      cli = Options.new
      cli.parse_options

      # Filter vms
      @vm_names = @vms.keys.map do |name|
        name =~ /^([^_]+)_on_([^_]+)_with_([^_]+)(.*)$/

        out = false
        # Filter branch, server, database
        if cli.config[:branch]
          out = true unless filter $1, cli.config[:branch]
        end
        if cli.config[:server]
          out = true unless filter $2, cli.config[:server]
        end
        if cli.config[:database]
          out = true unless filter $3, cli.config[:database]
        end

        if cli.config[:feature]
          # Features of current vm
          current_features = $4.split(/_using_/)

          # Features that match
          matching_features = current_features.select do |feature|
            filter feature, cli.config[:feature]
          end
          out = true unless matching_features.length == cli.config[:feature].split(/,/).length
        end

        if out
          nil
        else
          name
        end
      end.compact

      # Filtering complete, start working!
      @vm_names.each do |name|
        cli.config[:action].split(/,/).each do |action|
          case action
          when "list"
            puts "#{name.to_s}\t#{network name}\t#{@vms[name].state}"
          when "up"
            @vms[name].up
          when "provision"
            @vms[name].provision
          when "halt"
            @vms[name].halt
          when "suite"
            @vms[name].up
            run_cucumber name
            run_dav_tests name
            @vms[name].halt
          when "cucumber"
            run_cucumber name
          when "testdav"
            run_dav_tests name
          else
            puts "unknown action: #{action}"
          end
        end
      end
    end

    def network name
      @vms[name].config.keys[:vm].networks[0][1][0]
    end

    def run_cucumber name
      Dir.chdir ".."
      line = Cocaine::CommandLine.new("bundle", "exec cucumber -f json -o ./logs/#{name.to_s}.json -f pretty HOST=#{network name} features", :expected_outcodes => [0, 1])
      begin
        line.run
      rescue Cocaine::CommandNotFoundError => e
        puts e.message
      end
      Dir.chdir "Vagrant"
    end

    def run_dav_tests name
      line = Cocaine::CommandLine.new("litmus", "-k http://#{network name}/remote.php/webdav admin admin")
      begin
        line.run
      rescue Cocaine::CommandNotFoundError => e
        puts e.message
      end
    end
  end
end

RunTests::App.new.run
