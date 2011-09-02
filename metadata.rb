maintainer       "Mudbug Media, Inc."
maintainer_email "info@mudbugmedia.com"
license          "Apache 2.0"
description      "Installs/Configures jungledisk"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.2"
supports 'ubuntu'
recipe "jungledisk::default", "Download and install JungleDiskServer package, and configure the license xml"
attribute 'jungledisk/serial',
  :display_name => "Serial Number",
  :description => "Serial number provided by jungledisk.com control panel",
  :required => "required"
