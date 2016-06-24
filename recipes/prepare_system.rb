#
# Cookbook Name:: manager
# Recipe:: prepare_system
#
# Copyright 2016, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#
managers = get_managers()

node.set["redborder"]["memory"] = memory(12345678)

