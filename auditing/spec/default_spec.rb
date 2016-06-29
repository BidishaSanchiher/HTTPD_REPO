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
# Spec:: default_spec
#
require 'chefspec'
require 'spec_helper'

describe 'auditing::audit_rhel' do
  # Creating chef_run instance
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  context 'load the default recipe' do
    it 'converges successfully' do
      chef_run
    end
  end

  it 'installs audit package' do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/etc/init.d/auditd').and_return(false)
    expect(chef_run).to install_package('audit')
  end

  context '/etc/audit/auditd.conf does not exist' do
    it 'creates auditd.conf file if missing' do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/etc/audit/auditd.conf').and_return(false)
      expect(chef_run).to create_template('/etc/audit/auditd.conf').with(
        path: '/etc/audit/auditd.conf',
        source: 'auditd.conf.erb',
        owner: 'root',
        group: 'root',
        mode: '0640'
      )
    end

    it 'notifies the auditd service for a restart' do
      resource = chef_run.template('/etc/audit/auditd.conf')
      expect(resource).to notify('service[auditd]').to(:restart).delayed
    end
  end

  context '/etc/audit/audit.rules does not exist' do
    it 'creates audit.rules file if missing' do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/etc/audit/audit.rules').and_return(false)
      expect(chef_run).to create_template('/etc/audit/audit.rules').with(
        path: '/etc/audit/audit.rules',
        source: 'audit.rules.erb',
        owner: 'root',
        group: 'root',
        mode: '0640'
      )
    end

    it 'notifies the auditd service for a restart' do
      resource = chef_run.template('/etc/audit/audit.rules')
      expect(resource).to notify('service[auditd]').to(:restart).delayed
    end
  end
end
