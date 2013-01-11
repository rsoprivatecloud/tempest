#
# Cookbook Name:: tempest
# Recipe:: default
#
# Copyright 2012, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# this recipe installs the openstack api test suite 'tempest'


%w{git python-unittest2 python-nose python-httplib2 python-paramiko}.each do |pkg|
  package pkg do
    action :install
  end
end

execute "git clone https://github.com/openstack/tempest" do
  command "git clone https://github.com/openstack/tempest"
  cwd "/opt"
  user "root"
  not_if do File.exists?("/opt/tempest") end
end

execute "checkout tempest branch" do
  command "git checkout #{node['tempest']['branch']}"
  cwd "/opt/tempest"
  user "root"
end

kStoneAccess = get_access_endpoint("keystone", "keystone","service-api")["host"]
kStonePort = get_access_endpoint("keystone", "keystone","service-api")["port"]
gAccess = get_access_endpoint("glance-api", "glance","api")["host"]
gPort = get_access_endpoint("glance-api", "glance","api")["port"]

template "/opt/tempest/monitoring.sh" do
  source "monitoring.sh.erb"
  owner "root"
  group "root"
  mode "0555"
  variables(
           "test_list" => node["tempest"]["runlist"]
  )
end

template "/opt/tempest/etc/tempest.conf" do
  source "tempest.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
            "tempest_use_ssl" => node["tempest"]["use_ssl"],
            "keystone_access_point" => kStoneAccess,
            "keystone_port" => kStonePort,
            "tempest_tenant_isolation" => node["tempest"]["tenant_isolation"],
            "tempest_tenant_reuse" => node["tempest"]["tenant_reuse"],
            "tempest_user1" => node["tempest"]["user1"],
            "tempest_user1_pass" => node["tempest"]["user1_pass"],
            "tempest_user1_tenant" => node["tempest"]["user1_tenant"],
            "tempest_img_ref1" => node["tempest"]["test_img1"],
            "tempest_img_ref2" => node["tempest"]["test_img2"],
            "tempest_img_flavor1" => node["tempest"]["img1_flavor"],
            "tempest_img_flavor2" => node["tempest"]["img2_flavor"],
            "glance_endpoint" => gAccess,
            "glance_port" => gPort,
            "tempest_admin" => node["tempest"]["admin"],
            "tempest_admin_tenant" => node["tempest"]["admin_tenant"],
            "tempest_admin_pass" => node["tempest"]["admin_pass"]
            })
end

# This should only be needed until tempest corrects bug# 1046870
execute "Activate tests" do
  command "sed -i 's/raise nose.SkipTest(\"Until Bug 1046870 is fixed\")/#raise nose.SkipTest(\"Until Bug 1046870 is fixed\")/' test_images.py"
  cwd "/opt/tempest/tempest/tests/compute/images"
  user "root"
end


template "/etc/cron.d/tempest" do
  source "tempest.cron.erb"
  owner "root"
  group "root"
  mode "0555"
  variables(
           "test_interval" => node["tempest"]["interval"]
  )
end
