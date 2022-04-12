#
# Cookbook Name:: manager
# Recipe:: default
#
# Copyright 2016, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#

include_recipe 'rb-manager::prepare_system'
include_recipe 'rb-manager::configure'
include_recipe 'rb-manager::cron_tasks'

