cookbook-rb-manager CHANGELOG
===============

## 5.1.0

  - Miguel Alvarez
    - [a93b7a5] Add intrusion & intrusioncp sensors
    - [b512c3b] add intrusioncp to logstash pipelines
    - [64d856c] Add intrusioncp sensor type

## 5.0.3

  - Rafael Gomez
    - [91557b9] Improve error handling for external services in PostgreSQL and MinIO configurations

## 5.0.2

  - jnavarrorb
    - [a4fa7e3] Fix empty string

## 5.0.1

  - Miguel Negrón
    - [05cccc8] New memory distribution

## 5.0.0

  - Miguel Álvarez
    - [be3af6e] Add all zk servers and kafka brokers
    - [fdd3e3e] Update cluster info to include cpu cores and remove druid realtime
    - [4cc17f5] Notify delayed restart of druid indexer if change
    - [29d0a38] Fix order of druid indexer config to allow acc to node druid-indexer-tasks
    - [dd7ae0b] Add namespaces to druid-indexer
    - [c081a5f] Add indexer and router
    - [5180361] Restart druid indexer and router if common runtime updated
    - [3719436] Add rb-druid-indexer cookbook as dependency
    - [5afd48e] use rb_druid_indexer_config
    - [6747b9c] Configure druid indexer

## 4.10.3

  - Pablo Pérez
    - [443e1ca] refactor for no usage of node
    - [1c68a80] Done saving data in node
    - [88ce85f] Created the helper and added into web

## 4.10.2

  - nilsver
    - [f1c7741] add cdomain

## 4.10.1

  - nilsver
    - [0b1c65d] remove parent_id check

## 4.10.0

  - David Vanhoucke
    - [78d4d6c] activate logstash intrusion for intrusion sensor
  - Miguel Alvarez
    - [03b0ad5] Add rules for intrusion sensor

## 4.9.0

  - Pablo Pérez
    - [7733638] align elements
    - [3118dbb] rename redborder-ai to redborder-llm

## 4.8.3

  - nilsver
    - [be38558] ensure configuration

## 4.8.2

  - nilsver
    - [d1b76b6] disable logstatter if logstash not running

## 4.8.1

  - Rafael Gomez
    - [d56908f] Update core services group

## 4.8.0

  - Miguel Alvarez
    - [729685f] Add secor cookbook rb-secor

## 4.7.5

  - Miguel Alvarez
    - [c54973b] Use CPU num

## 4.7.4

  - nilsver
    - [78005ed] add more checks2

## 4.7.3

  - Miguel Negrón
    - [46efa0c] dont pass s3_hostname con configure_certs && add_aioutliers

## 4.7.2

  - David Vanhoucke
    - [2971573] load s3_host from s3_secrets databag

## 4.7.1

  - Miguel Negrón
    - [7a34132] Fix lint

## 4.7.0

  - Miguel Negrón
    - [bc1f5b4] Always enable vault pipeline for the alarms

## 4.6.4

  - Miguel Alvarez
    - [e461f49] Always create s3cfg_initial

## 4.6.3

  - Nils
    - Add cookbook for firewall

## 4.6.2

  - Juan Soto
    - [3b4542f] Change definition of vrrp_secrets

## 4.6.1

  - Rafa Gómez
    - [b873b58] skip child proxy sensors
  - jnavarrorb
    - [b450479] fix pipelines for flow if proxy has flow sensors

## 4.6.0

  - David Vanhoucke
    - [b4abc7a] execute add_mcli before installing and registering minio

## 4.5.0

  - Miguel Negrón
    - [99f02b0] Merge pull request #226 from redBorder/bugfix/#19144_missing_nginx_confd_files
    - [917b21b] Merge branch 'development' into bugfix/#19144_missing_nginx_confd_files
  - David Vanhoucke
    - [a5e7fda] remove files if service disabled
    - [06dc4b6] Merge remote-tracking branch 'origin/development' into bugfix/#19144_missing_nginx_confd_files
  - Miguel Negron
    - [617db93] Add outliers
    - [967cdc1] Calling add nginx conf

## 4.4.7

  - Rafael Gomez
    - [a50d54f] Changing riak service to s3
    - [787d0ae] Passing hd_services_current maxsize to druid-historical
    - [55d679c] First version of harddisk_services NG

## 4.4.6

  - Miguel Álvarez
    - [7930ce6] Make same check for logstatter and logstash to configure

## 4.4.5

  - Daniel Castro
    - [77547bd] create sudoers file before redborder-monitor install

## 4.4.4

  - ptorresred
    - [80dda4a] Redmine #19198: Change vault priority default filter

## 4.4.3

  - Juan Soto
    - [da722bb] Create and pass split_intrusion variables to logstash config (#216)

## 4.4.2

  - jnavarrorb
    - [72d2b00] Fix sensors info with all sensors (proxy childs too)
    - [87628c7] Fix parent_id to real_parent_id
    - [060f5d9] Fix open kafka port for all IPS
    - [a9a3efe] check if redborder_parent_id is nil or sensor at redborder_parent_id is not a proxy

## 4.4.1

  - JuanSheba
    - [8e22478] Add creation of the logrotate file with the template
    - [77bbbfb] Create Template

## 4.4.0

  - Miguel Negrón
    - [48ee415] Merge pull request #232 from redBorder/bugfix/#18169_rename_pmacctd_to_sfacctd_service

## 4.3.0

  - Miguel Negron
    - [8c6f578] Add rb-workers to service list

## 4.2.0

  - manegron
    - [90d4ca5] fix attribute

## 4.1.0

  - Miguel Negrón
    - [cdc5848] Merge pull request #221 from redBorder/feature/#18816_Split_Filter_Incident_Priority

## 4.0.2

  - Miguel Negron
    - [fd534ba] Fix minio_config

## 4.0.1

  - Daniel Castro
    - [4b6e062] Remove `get_monitor_in_proxy` and use `get_sensor_in_proxy` from task 19032
    - [d42b496] Search for sensors in proxy and enable vault if a vault sensor found

## 4.0.0

  - Miguel Negrón
    - [fa2f5c2] Merge pull request #223 from redBorder/improvement/#18961_service_list_without_chef

## 3.1.0

  - Miguel Negrón
    - [ab45adc] Merge pull request #217 from redBorder/bugfix/#18863_license_in_settings

## 3.0.0

  - Miguel Negrón
    - [334ed51] Merge pull request #211 from redBorder/improvement/boost_installation_stage_1
    - [52a09e9] Merge pull request #212 from redBorder/feature/add_mc_tool
    - [9a90ca7] Merge pull request #203 from redBorder/development
    - [1c23569] Merge pull request #202 from redBorder/development
    - [6ffe147] Solve conflic on mini_config
    - [7b966ba] Bump version
    - [570bced] Bump version
    - [62ebf24] Update configure.rb
    - [e9d74b4] add mc tool
    - [c0a9103] Bump version
    - [334ed51] Merge pull request #211 from redBorder/improvement/boost_installation_stage_1
    - [6ffe147] Solve conflic on mini_config
    - [7b966ba] Bump version
    - [c426557] Change mini config call
    - [9e8dc4d] Call add_mcli
    - [570bced] Bump version
    - [52a09e9] Merge pull request #212 from redBorder/feature/add_mc_tool
    - [62ebf24] Update configure.rb
    - [e9d74b4] add mc tool
    - [0d0699e] Fix lint
    - [d89d6c4] Fix lint
    - [c9a66d2] Fix typo
    - [7dfbd25] Put back get_pipelines in prepare
    - [c84d789] Put back get_pipelines in prepare
    - [ca80f21] Put back get_org in prepare
    - [c1b0c05] Extend libs in configure.rb
    - [cb4bcfb] Extend libs in configure.rb
    - [e02016e] Fix typo
    - [fac7de3] fix bugs and optimize configure.rb
    - [8ed9d57] Optimize rb-manager
    - [5b975d8] Fix typo
    - [1c37ad2] Dont run check_cgroup while installing
    - [f5e72c2] Fix typo
    - [ae380d2] fix bug related with cluster_install variable on prepare_system
    - [5a3fc4a] Dont run chef-client service till cluster is installed
    - [906f2eb] Remove hadoop & samza
    - [44700e9] Bump version
    - [9e67532] Add pre and postun to clean the cookbook
    - [9a90ca7] Merge pull request #203 from redBorder/development
    - [1c23569] Merge pull request #202 from redBorder/development
    - [c0a9103] Bump version
  - david vhk
    - [0d95408] Merge branch 'master' into development
    - [57e00e8] release 2.10.1 (#206)
  - David Vanhoucke
    - [484f2e2] release 2.10.2
    - [f9d5c6b] release 2.10.1
    - [c54069a] use descrfptive name
    - [6592bd1] remove blank line
    - [8b401f1] add method to activate the split of the traffic through logstash
  - nilsver
    - [e788b6b] Bugfix/18447 open port kafka public zone (#207)
  - Miguel Álvarez
    - [66ab004] Delete keepalived from memory services (#205)
  - Juan Soto
    - [533c53c] Merge pull request #204 from redBorder/development
    - [56d3541] Merge pull request #200 from redBorder/feature/#18681_split_traffic_with_logstash
  - JuanSheba
    - [5f2cea6] Release 2.10.0
    - [291b8a1] resolve conflicts
  - Rafael Gomez
    - [27ae44a] Release 2.9.1
    - [5f10c8f] Merge branch 'master' into bug/#18544_rb_clean_segments_not_working_and_its_not_being_call
    - [a20e4f6] Merge remote-tracking branch 'origin/master' into bug/#18544_rb_clean_segments_not_working_and_its_not_being_call
  - Rafa Gómez
    - [225809a] Merge pull request #192 from redBorder/bug/#18544_rb_clean_segments_not_working_and_its_not_being_call
  - jnavarrorb
    - [d39786a] Fix path to avoid cron_d action delete

## 2.12.0

  - manegron
    - [c426557] Change mini config call
    - [9e8dc4d] Call add_mcli
    - [570bced] Bump version
    - [52a09e9] Merge pull request #212 from redBorder/feature/add_mc_tool
    - [62ebf24] Update configure.rb
    - [e9d74b4] add mc tool
    - [44700e9] Bump version
    - [9e67532] Add pre and postun to clean the cookbook
    - [9a90ca7] Merge pull request #203 from redBorder/development
    - [1c23569] Merge pull request #202 from redBorder/development
    - [c0a9103] Bump version
  - Miguel Negron
    - [570bced] Bump version
    - [62ebf24] Update configure.rb
    - [e9d74b4] add mc tool
    - [c0a9103] Bump version
  - Miguel Negrón
    - [52a09e9] Merge pull request #212 from redBorder/feature/add_mc_tool
    - [9a90ca7] Merge pull request #203 from redBorder/development
    - [1c23569] Merge pull request #202 from redBorder/development
  - david vhk
    - [0d95408] Merge branch 'master' into development
    - [57e00e8] release 2.10.1 (#206)
  - David Vanhoucke
    - [484f2e2] release 2.10.2
    - [f9d5c6b] release 2.10.1
    - [c54069a] use descrfptive name
    - [6592bd1] remove blank line
    - [8b401f1] add method to activate the split of the traffic through logstash
  - nilsver
    - [e788b6b] Bugfix/18447 open port kafka public zone (#207)
  - Miguel Álvarez
    - [66ab004] Delete keepalived from memory services (#205)
  - Juan Soto
    - [533c53c] Merge pull request #204 from redBorder/development
    - [56d3541] Merge pull request #200 from redBorder/feature/#18681_split_traffic_with_logstash
  - JuanSheba
    - [5f2cea6] Release 2.10.0
    - [291b8a1] resolve conflicts
  - Rafael Gomez
    - [27ae44a] Release 2.9.1
    - [5f10c8f] Merge branch 'master' into bug/#18544_rb_clean_segments_not_working_and_its_not_being_call
    - [a20e4f6] Merge remote-tracking branch 'origin/master' into bug/#18544_rb_clean_segments_not_working_and_its_not_being_call
  - Rafa Gómez
    - [225809a] Merge pull request #192 from redBorder/bug/#18544_rb_clean_segments_not_working_and_its_not_being_call
  - jnavarrorb
    - [d39786a] Fix path to avoid cron_d action delete

## 2.11.0

  - Miguel Negrón
    - [52a09e9] Merge pull request #212 from redBorder/feature/add_mc_tool
    - [9a90ca7] Merge pull request #203 from redBorder/development
    - [1c23569] Merge pull request #202 from redBorder/development
  - Miguel Negron
    - [62ebf24] Update configure.rb
    - [e9d74b4] add mc tool
    - [c0a9103] Bump version
  - manegron
    - [52a09e9] Merge pull request #212 from redBorder/feature/add_mc_tool
    - [62ebf24] Update configure.rb
    - [e9d74b4] add mc tool
    - [44700e9] Bump version
    - [9e67532] Add pre and postun to clean the cookbook
    - [9a90ca7] Merge pull request #203 from redBorder/development
    - [1c23569] Merge pull request #202 from redBorder/development
    - [c0a9103] Bump version
  - david vhk
    - [0d95408] Merge branch 'master' into development
    - [57e00e8] release 2.10.1 (#206)
  - David Vanhoucke
    - [484f2e2] release 2.10.2
    - [f9d5c6b] release 2.10.1
    - [c54069a] use descrfptive name
    - [6592bd1] remove blank line
    - [8b401f1] add method to activate the split of the traffic through logstash
  - nilsver
    - [e788b6b] Bugfix/18447 open port kafka public zone (#207)
  - Miguel Álvarez
    - [66ab004] Delete keepalived from memory services (#205)
  - Juan Soto
    - [533c53c] Merge pull request #204 from redBorder/development
    - [56d3541] Merge pull request #200 from redBorder/feature/#18681_split_traffic_with_logstash
  - JuanSheba
    - [5f2cea6] Release 2.10.0
    - [291b8a1] resolve conflicts
  - Rafael Gomez
    - [27ae44a] Release 2.9.1
    - [5f10c8f] Merge branch 'master' into bug/#18544_rb_clean_segments_not_working_and_its_not_being_call
    - [a20e4f6] Merge remote-tracking branch 'origin/master' into bug/#18544_rb_clean_segments_not_working_and_its_not_being_call
  - Rafa Gómez
    - [225809a] Merge pull request #192 from redBorder/bug/#18544_rb_clean_segments_not_working_and_its_not_being_call
  - jnavarrorb
    - [d39786a] Fix path to avoid cron_d action delete

## 2.10.3

  - Miguel Negrón
    - [9e67532] Add pre and postun to clean the cookbook
  - david vhk
    - [0d95408] Merge branch 'master' into development
  - David Vanhoucke
    - [484f2e2] release 2.10.2
    - [f9d5c6b] release 2.10.1
  - nilsver
    - [e788b6b] Bugfix/18447 open port kafka public zone (#207)
  - Miguel Álvarez
    - [66ab004] Delete keepalived from memory services (#205)

## 2.10.2

  - nilsver
    - [e788b6b] Bugfix/18447 open port kafka public zone (#207)

## 2.10.1

  - Miguel Álvarez
    - [66ab004] Delete keepalived from memory services (#205)

## 2.10.0

  - David Vanhoucke
    - [c54069a] use descrfptive name
    - [6592bd1] remove blank line
    - [8b401f1] add method to activate the split of the traffic through logstash

## 2.9.1
  - jnavarrorb
    - [d39786a] Fix path to avoid cron_d action delete

## 2.9.0
  - Vicente Mesa
    - Fix incident priority filter

## 2.8.0

  - Miguel Negrón
    - [83656ac] Merge pull request #195 from redBorder/feature/#18290_add_option_setup_cores_on_redborder-ai_will_use
  - Miguel Negrón
    - [ddbd865] Adapt redborder-ai
  - Pablo Pérez
    - [5702c72] Merge branch 'master' into feature/#18290_add_option_setup_cores_on_redborder-ai_will_use
    - [02fea0c] revert
    - [31334ef] condicional ternario
    - [808220d] fix
    - [b5ee662] parsing json
    - [59f513f] rename variable
    - [ee9ce9c] Modified value of allowed_cpu
    - [f8bb525] Added cpu variable of redborder-ai service

## 2.7.6

  - Miguel Negrón
    - [18d928f] Merge pull request #197 from redBorder/bugfix/#18648_dont_use_point_node_in_nginx
  - Miguel Negrón
    - [526894f] Add space
    - [1481bf1] Add node domain in etc/hosts

## 2.7.5

  - Pablo Pérez
    - [58e1061] Revert sync address assignment

## 2.7.4

  - Miguel Negrón
    - [d5fd4f7] Avoid upload cookbooks while we fix bug #18576

## 2.7.3

  - Miguel Negrón
    - [3ea1dac] Merge pull request #190 from redBorder/bugfix/18247_auth_token_not_accessible

## 2.7.2

  - Luis Blanco
    - [bf8d086] Merge remote-tracking branch 'origin/master' into feature/#16519_fix_ale_action_logic
    - [8154374] Merge remote-tracking branch 'origin/master' into feature/#16519_fix_ale_action_logic
    - [084dbd2] Merge remote-tracking branch 'origin/master' into feature/#16519_fix_ale_action_logic
    - [f2fc7eb] manage package and service based on sensor existence, instead of service status

## 2.7.1

  - Pablo Pérez
    - [3975465] fix spelling
    - [6911bae] check if is more than one node
    - [e1996b6] Add sync address to redborder-ai

## 2.7.0

  - Miguel Alvarez
    - [aac735d] Add cookbook rb chrony as dependency
    - [ee99d8c] Add chrony service

## 2.6.2

  - nilsver
    - [918fd9d] add rb_create_rsa to sudoers file

## 2.6.1

  - Miguel Negrón
    - [c0bf956] Merge pull request #177 from redBorder/feature/#18106_install_llamafile_as_service

## 2.6.0

  - David Vanhoucke
    - [c70c775] Bump release
    - [80162bb] run rb_upload_cookbooks when triggered

## 2.5.3

  - nilsver
    - [4195b55] Feature/18013 integrate mongodb (#176)
    - [4ebc4ec] Release 2.5.2
    - [afd6735] Merge pull request #170 from redBorder/bug/#17959_Add_memcached-hosts_to_druid_common_propiertes
  - David Vanhoucke
    - [80162bb] run rb_upload_cookbooks when triggered
  - jnavarrorb
    - [f011ad1] fix_memcached_hosts

## 2.5.2

  - jnavarrorb
    - [f011ad1] fix_memcached_hosts

## 2.5.1

  - Miguel Negrón
    - [6f3647b] Fix error service name on mem2incident

## 2.5.0

  - Pablo Pérez
    - [b0a6896] Added default value of node variable sso_enabled

## 2.4.0

  - Miguel Negrón
    - [b49dc76] Merge pull request #171 from redBorder/feature/incident_response
  - Luis Blanco
    - [d7eaeba] Release 2.3.1
    - [291aaab] Merge pull request #162 from redBorder/bugfix/17853_minio_cannot_stop
    - [adf0025] Merge remote-tracking branch 'origin/master' into bugfix/17853_minio_cannot_stop
    - [4f013bc] Merge remote-tracking branch 'origin/master' into bugfix/17853_minio_cannot_stop
  - Miguel Alvarez
    - [4681fe2] Fix default action of minio to do nothing when disabling

## 2.3.1

  - Miguel Alvarez
    - [4681fe2] Fix default action of minio to do nothing when disabling

## 2.3.0

  - Rafael Gomez
    - [db4f4be] Feature/#17820 add intrusion pipeline

## 2.2.2

  - Miguel Negrón
    - [10b3f6e] Update get_pipelines.rb
  - nilsver
    - [d3e9e40] fix linter
    - [9fd823c] fix bug mobility pipelines nil
    - [a97909b] add arubacentral-sensor
  - Miguel Negrón
    - [abe7d76] Release 2.2.1

## 2.2.1

  - nilsver
    - [a97909b] add arubacentral-sensor

## 2.2.0

  - nilsver
    - [0186ecc] add pipeline per monitor configuration
    - [b5d56c5] fix check if pipelines are active
    - [e557b19] add helper file
    - [64b9adc] monitor pipelines work with proxy too
  - Miguel Alvarez
    - [86e6e36] Add memcached hosts to the webui
    - [2be5b59] Fix configure clamscan
    - [2e0b86b] Add clamav

## 2.1.0

  - David Vanhoucke
    - [161b5dd] add library to get virtual ips
    - [32fe52b] add keepalived and balanced services

## 2.0.1

  - Miguel Alvarez
    - [d6ecac2][e748afe][2405993]  Fix lint issues
    - [292288d] Add hosts in node data
    - [fd63ad2] Fix prepare and configure
    - [ac54c02] Proper use of s3 hosts
    - [f08e447] Configure minio nodes and load balancer
    - [78f1562][4db8fa1][e101c2d][3220e71][4ec77f8][d89bd26][ed91ff3] Updates
    - [6e7680a] Delete resources/templates/default/minio.erb

## 2.0.0

  - Miguel Álvarez
    - [a28b728] Configure minio nodes and load balancer (#145)

## 1.9.3

  - Miguel Negrón
    - [a12be85] Improvement/fix lint (#148)

## 1.9.2

  - Miguel Negrón
    - [65696ef] configure not removing geoip. Geoip wont be in the list because is no longer a service

## 1.9.1

  - David Vanhoucke
    - [f22a469] add temporary variables in node.run_state
  - Miguel Negrón
    - [7d26b70] Update README.md
    - [d29155f] Update rpm.yml
    - [4a4efaa] Update metadata.rb
    - [1120885] Merge pull request #142 from redBorder/bugfix/missing_specific_dist_kernel_info_in_motd
    - [31682a0] Add full kernel release info in motd

## 1.9.0

  - Miguel Negrón
    - [ef94e3c] Add configure common cookbook call (#140)

## 1.8.0
  - David Vanhoucke
    - [c2df76a] add postfix service
  - Luis Blanco
    - [48c4142] add ale service in redborder full installation

## 1.7.10

  - nilsver
    - [f66e148] added conditional check on pipelines

## 1.7.9

  - Miguel Álvarez
    - [1c900b6] Update prepare_system.rb
    - [f9d986c] Update memory_services.rb
    - [546e802] rename to excluded_memory_services

## 1.7.8

  - nilsver
    - [ae88eb5] fix_logstash_crash

## 1.7.7

  - nilsver
    - [3268d47] imported logstash template from centos6

## 1.7.6

  - Miguel Álvarez
    - [10301b6] Add parition id for druid realtime
    - [17142d4] Use zookeeper.service instead of hardcoded localhost

## 1.7.5

  - Miguel Negrón
    - [0c6a59b] Change the way we get the sync IP using ip route

## 1.7.4
dvanhoucke
- add ipaddress sync for minio

## 1.7.3
vimesa
- Fix druid tiers

## 1.6.9
malvarez
- Add rbaioutliers & nginx config for it

## 0.0.22
eareyes
- Add rbale

## 0.0.21
eareyes
- Add n2klocd


## 0.0.20
eareyes
- Add rbnmsp

## 0.0.19
eareyes & vimesa
- Add rbsocial

## 0.0.18
  [Juan J. Prieto]
- Add logstash

## 0.0.17
  - cjmateos
    - b3b5edc Update changelog
    - 8fd399a Add attribute uploaded_s3
    - a5b29bb Add riak to service list
  - ejimenez
    - 7f4380d Fix postgresql integration
    - 2bd3b3c updated changelog
    - 2c676be fix merge issue
    - 0f3791e Add chef and postgresql
    - 1ec3186 Update CHANGELOG
    - 85d8ad4 Added memcached service
    - 4a1865a updated version
    - f628177 Fix indentation typo
    - 85d8ad4 Added memcached service
    - 0f3791e Add postgresql and chef

## 0.0.16
 [Enrique Jimenez]
- Add cdomain to hosts template

## 0.0.15
 [Enrique Jimenez]
- Typo on get_sensor lib
- Add chef-server/postgresql

## 0.0.14
 [Enrique Jimenez]
- Add cdomain as default attribute
- Add http2k
- Memory for druid services

## 0.0.13
 [Enrique Jimenez]
- Add druid broker, historical and middlemanager

## 0.0.12
 [Enrique Jimenez]
- Add druid overlord
- Enable/disable chef-client service by attribute

## 0.0.11
 [Enrique Jimenez]
- Add chef-client service

## 0.0.10
 [Enrique Jimenez]
- Add slash to druid services name
- Clean yum cache to upgrade packages

## 0.0.9
 [Enrique Jimenez]
- Passing memory to resources

## 0.0.8
 [Enrique Jimenez]
- Added memory_services
- Fixed redborder in lower case error in harddisk_services lib

## 0.0.7
 [Enrique Jimenez]
- set zk_hosts for kafka configuration
- integration for kafka

## 0.0.6
- [Enrique Jimenez] - Changel managers_info to cluster_info to get more readibility

## 0.0.5
- [Enrique Jimenez] - Kafka basic integration

## 0.0.4
- [Enrique Jimenez] - Added new library to manager disks

## 0.0.3
- [Enrique Jimenez] - Fixing attributes in zookeeper custom resource

## 0.0.2
- [Enrique Jimenez] - Added zookeeper integration

## 0.0.1
- [Enrique Jimenez] - Initial release of manager
