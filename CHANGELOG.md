cookbook-rb-manager CHANGELOG
===============

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
  - Miguel Negron
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

  - Miguel Negron
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
