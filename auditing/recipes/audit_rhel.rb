# =================================================================
# Licensed Materials - Property of IBM
#
# (c) Copyright IBM Corp. 2016 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================
#
# Cookbook Name:: policy_linux_auditd
# Recipe:: default
#

os_platform = node['platform_family']
os_version = node['platform_version'][0]
AUDIT_CONFIG = '/etc/audit/auditd.conf'
AUDIT_RULE_FILE = '/etc/audit/audit.rules'
AUDIT_LOG_FILE = '/var/log/audit/audit.log'
AUDIT_D = '/etc/init.d/auditd'

# FUNCTION DEFINITION: Checks whether a given file exists or not and creates it,
# if not present
def create_or_update(audit_file, source_file)
  template audit_file do
    path audit_file
    source "#{source_file}.erb"
    mode '0640'
    owner 'root'
    group 'root'
    only_if { !File.exist?(audit_file) || File.zero?(audit_file) }
    # Notify the 'auditd' to reload the new rules and configuration
    notifies :restart, 'service[auditd]', :delayed
  end
end

# Check if operating platform is as per requirement
if os_platform == 'rhel' && os_version.to_f >= 5
  # Check if the audit package is installed, install if not present
  package 'audit' do
    action :install
    timeout 60
    # Placing a guard on install
    not_if { File.exist?(AUDIT_D) }
  end

  # Check if the audit.conf file and the audit.rule files are present,
  # create if not present
  [AUDIT_CONFIG, AUDIT_RULE_FILE].each do |audit_file|
    template_name = ::File.basename(audit_file)
    create_or_update(audit_file, template_name)
  end

  # Reload the config settings and restart the service
  service 'auditd' do
    supports :restart => true
    action [:enable, :start]
    restart_command 'service auditd restart'
  end

  # Check if audit.log is present and create if missing
  file 'create audit log file' do
    path AUDIT_LOG_FILE
    action :create_if_missing
    # Note: The permission on audit.log can only be 0600 or 0640
    mode '0640'
    owner 'root'
    group 'root'
  end
else
  puts 'Operating platform not applicable.'
end
