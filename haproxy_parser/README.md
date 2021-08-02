# HAProxy Parser

**Purpose:**  output some puppet classes for doing haproxy checks

Makes use of the following puppet modules
  * [monitor][1]  by [example42][3]  
  * [nagios][2]   by [example42][3]  

[1]: http://github.com/example42/puppet-monitor
[2]: http://github.com/example42/puppet-nagios
[3]: http://github.com/example42/


#####Usage:  
>haproxy_parser.rb [options]  
>-t, --type TYPE                  Type of HAProxy (TYPE = sites|services|tools)  
>-h, --help                       Display Help  

#####Example:  
>######Creates sites.pp  
>  * haproxy_parser.rb --type sites
