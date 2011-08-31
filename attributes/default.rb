# Preferablly set this value in your node attributes
node.default[:jungledisk][:serial] = "get this value from jungledisk.com controlpanel and update the node attributes or cookbooks/jungledisk/attributes/default.rb"

# Default: disabled
node.default[:jungledisk][:proxy] = {
  :enabled => 0, # Fixnum
  :server => '',
  :username => '',
  :password => '',
  :type => 0
}
