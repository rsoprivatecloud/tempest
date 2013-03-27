default["tempest"]["branch"] = nil                           # node_attribute
default["tempest"]["use_ssl"] = false                        # node_attribute
default["tempest"]["tenant_isolation"] = true                # node_attribute
default["tempest"]["tenant_reuse"] = true                    # node_attribute
default["tempest"]["alt_ssh_user"] = "cirros"                # node_attribute
default["tempest"]["ssh_user"] = "cirros"                    # node_attribute
default["tempest"]["user1"] = "tempest_monitor_user1"        # node_attribute
default["tempest"]["user1_pass"] = "monpass"                 # node_attribute
default["tempest"]["user1_tenant"] = "tempest_monitor_tenant1" # node_attribute
default["tempest"]["user2"] = "tempest_monitor_user2"        # node_attribute
default["tempest"]["user2_pass"] = "monpass"                 # node_attribute
default["tempest"]["user2_tenant"] = "tempest_monitor_tenant2" # node_attribute
default["tempest"]["test_img1"]["id"] = nil                        # node_attribute
default["tempest"]["test_img1"]["url"] = "https://launchpadlibrarian.net/83305348/cirros-0.3.0-x86_64-disk.img"
default["tempest"]["test_img2"] = "12123"                    # node_attribute
default["tempest"]["img1_flavor"] = "1"                      # node_attribute
default["tempest"]["img2_flavor"] = "2"                      # node_attribute
default["tempest"]["admin"] = "admin"                        # node_attribute
default["tempest"]["admin_pass"] = "secrete"                 # node_attribute
default["tempest"]["admin_tenant"] = "admin"                 # node_attribute
default["tempest"]["runlist"]["grizzly"] = ["tempest.tests.compute.images.test_images_oneserver",
                                            "tempest.tests.image.v2.test_images"]
default["tempest"]["runlist"]["folsom"] = ["tempest.tests.compute.test_create_server.py:ServersTestJSON.test_list_servers_with_detail",
                                           "tempest.tests.compute.images.test_images.py:ImagesTestJSON.test_create_delete_image"]
default["tempest"]["runlist"]["essex-final"] = nil
# how often the tests are run. This is in minutes
default["tempest"]["interval"] = "5"                         # node_attribute
default["tempest"]["use_cron"] = false                       # node_attribute
