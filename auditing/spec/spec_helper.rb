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
# Spec_helper
#

# Added by ChefSpec
require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  # Specify the path for Chef Solo to find cookbooks
  config.cookbook_path = '..'

  # Specify the Chef log_level (default: :warn)
  config.log_level = :error

  # Specify the path to a local JSON file with Ohai data
  # config.path = 'ohai.json'

  # Specify the operating platform to mock Ohai data from
  config.platform = 'redhat'

  # Specify the operating version to mock Ohai data from
  config.version = '6.6'
end
