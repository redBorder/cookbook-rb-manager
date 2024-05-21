cookbook-rb-manager CHANGELOG
===============

## 1.9.0
  - David Vanhoucke
    - [c2df76a] add postfix service

## 1.8.0
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
