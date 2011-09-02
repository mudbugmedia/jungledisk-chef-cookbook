#
# Cookbook Name:: jungledisk
# Recipe:: default
#
# Copyright 2011, Mudbug Media, Inc.
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

jungledisk_package = value_for_platform(
  %w(centos redhat suse fedora) => { "default" => "junglediskserver-3160-0.#{node[:kernel][:machine].include?('64') ? "x86_64" : "i386"}.rpm" },
  %w(debian ubuntu) => { "default" => "junglediskserver_316-0_#{node[:kernel][:machine].include?('64') ? "amd64" : "i386"}.deb" },
  "default" => "junglediskserver#{node[:kernel][:machine].include?('64') == "i386" ? "64-" : ""}3160.tar.gz"
)

remote_file "/usr/src/#{jungledisk_package}" do
  source "https://downloads.jungledisk.com/jungledisk/#{jungledisk_package}"
  mode "0644"
  action :create_if_missing
end

package "junglediskserver" do
  source "/usr/src/#{jungledisk_package}"
  case node[:platform]
  when "debian","ubuntu"
    provider Chef::Provider::Package::Dpkg
  when "centos", "redhat", "suse", "fedora"
    provider Chef::Provider::Package::Rpm
  end
end

template "/etc/jungledisk/junglediskserver-license.xml" do
  source "junglediskserver-license.xml.erb"
  owner "root"
  group "root"
  mode "0400"
  notifies :restart, "service[junglediskserver]", :delayed
end

service "junglediskserver" do
  action [:enable, :start]
  
  supports :restart => true
  # JungleDisk's init script does not have a #!, which causes ruby to error with `Errno::ENOEXEC: Exec format error - /etc/init.d/junglediskserver`
  start_command "/bin/sh /etc/init.d/junglediskserver start"
  stop_command "/bin/sh /etc/init.d/junglediskserver start"
  restart_command "/bin/sh /etc/init.d/junglediskserver restart"
  status_command "/bin/sh /etc/init.d/junglediskserver status"
end