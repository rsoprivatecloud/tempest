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


#
# Setup the image and users
#

# set the package component so we know what version of openstack we are installing
if not node['package_component'].nil?
  release = node['package_component']
else
  release = "folsom"
end

ks_admin_endpoint = get_access_endpoint("keystone-api", "keystone", "admin-api")
ks_service_endpoint = get_access_endpoint("keystone-api", "keystone", "service-api")
keystone = get_settings_by_role("keystone", "keystone")
glance_api = get_access_endpoint("glance-api", "glance","api")

# Register tempest tenant for user#1
keystone_tenant "Register tempest tenant#1" do
  auth_host ks_admin_endpoint["host"]
  auth_port ks_admin_endpoint["port"]
  auth_protocol ks_admin_endpoint["scheme"]
  api_ver ks_admin_endpoint["path"]
  auth_token keystone["admin_token"]
  tenant_name node["tempest"]["user1_tenant"]
  tenant_description "Tempest Monitoring Tenant #1"
  tenant_enabled "true" # Not required as this is the default
  action :create
end

# Register tempest user#1
keystone_user "Register tempest user #1" do
  auth_host ks_admin_endpoint["host"]
  auth_port ks_admin_endpoint["port"]
  auth_protocol ks_admin_endpoint["scheme"]
  api_ver ks_admin_endpoint["path"]
  auth_token keystone["admin_token"]
  tenant_name node["tempest"]["user1_tenant"]
  user_name node["tempest"]["user1"]
  user_pass node["tempest"]["user1_pass"]
  user_enabled "true" # Not required as this is the default
  action :create
end

## Grant Member role to Tempest user#1 for tempest tenant
keystone_role "Grant 'member' Role to tempest user for tempest tenant#1" do
  auth_host ks_admin_endpoint["host"]
  auth_port ks_admin_endpoint["port"]
  auth_protocol ks_admin_endpoint["scheme"]
  api_ver ks_admin_endpoint["path"]
  auth_token keystone["admin_token"]
  tenant_name node["tempest"]["user1_tenant"]
  user_name node["tempest"]["user1"]
  role_name "Member"
  action :grant
end

if release == "grizzly"
  # Register tempest tenant for user#2
  keystone_tenant "Register tempest tenant#2" do
    auth_host ks_admin_endpoint["host"]
    auth_port ks_admin_endpoint["port"]
    auth_protocol ks_admin_endpoint["scheme"]
    api_ver ks_admin_endpoint["path"]
    auth_token keystone["admin_token"]
    tenant_name node["tempest"]["user2_tenant"]
    tenant_description "Tempest Monitoring Tenant #2"
    tenant_enabled "true" # Not required as this is the default
    action :create
  end

  # Register tempest user#2
  keystone_user "Register tempest user#2" do
    auth_host ks_admin_endpoint["host"]
    auth_port ks_admin_endpoint["port"]
    auth_protocol ks_admin_endpoint["scheme"]
    api_ver ks_admin_endpoint["path"]
    auth_token keystone["admin_token"]
    tenant_name node["tempest"]["user2_tenant"]
    user_name node["tempest"]["user2"]
    user_pass node["tempest"]["user2_pass"]
    user_enabled "true" # Not required as this is the default
    action :create
  end

  ## Grant Member role to Tempest user#2 for tempest tenant
  keystone_role "Grant 'member' Role to tempest user#2 for tempest tenant#2" do
    auth_host ks_admin_endpoint["host"]
    auth_port ks_admin_endpoint["port"]
    auth_protocol ks_admin_endpoint["scheme"]
    api_ver ks_admin_endpoint["path"]
    auth_token keystone["admin_token"]
    tenant_name node["tempest"]["user2_tenant"]
    user_name node["tempest"]["user2"]
    role_name "Member"
    action :grant
  end
end

# need to check that this is running on a node where glance is.  presumably
# this would be on a infra node
#
# if you don't want glance to upload images then set your own image id
#
if node["tempest"]["test_img1"]["id"].nil?
  Chef::Log.info "tempest/default: test_img1::id was nil so we are going to upload an image for you"
  glance_image "Image setup for cirros-tempest-test" do
    image_url node["tempest"]["test_img1"]["url"]
    image_name "cirros-#{node['tempest']['user1_tenant']}"
    keystone_user node["tempest"]["user1"]
    keystone_pass node["tempest"]["user1_pass"]
    keystone_tenant node["tempest"]["user1_tenant"]
    keystone_uri ks_admin_endpoint["uri"]
    action :upload
  end
else
  Chef::Log.info "tempest/default Using image UUID #{node["tempest"]["test_img1"]["id"]} for tempest tests"
end
