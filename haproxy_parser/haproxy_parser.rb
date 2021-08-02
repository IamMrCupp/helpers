#!/usr/bin/env ruby
#
# ruby parser for haproxy backends
# -- we spit out puppet classes for building nagios checks
# 
# Aaron Cupp <mrcupp@mrcupp.com>
#
# version 1.0
# updated: 2016.11.19
#
# classes we need to import here
require 'optparse'
require 'open-uri'
require 'ostruct'
require 'csv'


# options from the command line;  one is required
options = {:type => nil}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: haproxy_parser.rb [options]"
  opts.on('-t', '--type TYPE', 'Type of HAProxy (TYPE = sites|services|tools)') do |haproxy_type|
    options[:type] = haproxy_type
  end
  
  opts.on('-h', '--help', 'Display Help') do
    puts opts
    exit
  end
end

parser.parse!

if options[:type] == nil
  puts "Error!  Nothing passed into script"
  puts "For more info please run:  haproxy_parser.rb -h" 
  exit
end

# constants & variables make life nice
HAPROXY_COLUMN_NAMES = %w{pxname svname qcur qmax scur smax slim stot bin bout dreq dresp ereq econ eresp wretr wredis status weight act bck chkfail chkdown lastchg downtime qlimit pid iid sid throttle lbtot tracked type rate rate_lim rate_max check_status check_code check_duration hrsp_1xx hrsp_2xx hrsp_3xx hrsp_4xx hrsp_5xx hrsp_other hanafail req_rate req_rate_max req_tot cli_abrt srv_abrt}

# what type of proxy are we hitting today?
if options[:type] == "sites"
  hatype = "site"
elsif options[:type] == "services"
  hatype = "svc"
elsif options[:type] =="tools"
  hatype = "tools"
end

fqdomain  = "<%= @domain %>"  # this will come from a puppet fact or you can add it to the command line
hostname = "#{hatype}-proxy-1-1.#{fqdomain}"
port = 6001
output_path = "/etc/puppet/modules/checks/manifests/haproxy"

# open the file for writing
output = File.open("#{output_path}/#{options[:type]}.pp","w+")

# output the header for the class to the file
output.puts "class checks::haproxy::#{options[:type]} inherits checks::haproxy {"

# output all the backends we need to check with this blurb
#
new_url = ("http://#{hostname}:#{port}/;csv")  # URI to the csv file for the haproxy status

begin
  open(new_url) do |f|                           # open the file and slurp into "f"
    f.each do |line|                             # walk over the array "f" and assign data to "line"
      row = HAPROXY_COLUMN_NAMES.zip(CSV.parse(line)[0]).reduce({}) { |hash, val| hash.merge({val[0] => val[1]}) }  #slurp in data from the CSV line
      #  skip some shit we don't want or need
      next if (row['svname'] != 'BACKEND' || row['svname'] == 'FRONTEND' || row['svname'] == 'localhost' || row['svname'] == 'svname' || row['pxname'] == 'stats')
    
      proxy_backend = row['pxname']
      # this is real output now!!
      output.puts """
        monitor::plugin { 'HAProxy_#{proxy_backend}':
          plugin    => 'check_haproxy.rb',
          arguments => '-u localhost:6001 -p #{proxy_backend}',
          tool      => [ 'puppi', 'nagios' ],
        }
      """
    end
  end
rescue
  puts "Error issues:  can't hit the proxy backend.  close the file so it doesn't cause class issues."
end
  

output.puts "}" # close the .pp file out here
output.close  # close the output file

