#
# Cookbook Name:: manager
# Recipe:: prepare_system
#
# Copyright 2016, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#

node.set["redborder"]["managers_info"] = get_managers_info()

#node.set["redborder"]["memory"] = memory(12345678)

