#!/usr/bin/env bash

#################################
# include the -=magic=-
# you can pass command line args
#
# example:
# to disable simulated typing
# . ../demo-magic.sh -d
#
# pass -h to see all options
#################################
. ../demo-magic.sh


########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
TYPE_SPEED=40

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

# text color
# DEMO_CMD_COLOR=$BLACK

# hide the evidence
clear

# enters interactive mode and allows newly typed command to be executed
cmd

echo ""
p "Demo: The latest addon-framework supports large size of manifests in an add-on."


echo ""
p "There is an exmaple add-on named large-addon "
pei "oc get managedclusteraddons.addon.open-cluster-management.io -n cluster1"

echo ""
p "The addon has a manfiestWork and deploys 2 configmaps "
pei "oc get manifestworks.work.open-cluster-management.io -n cluster1"
pei "oc get configmaps -n open-cluster-management-agent-addon -l app=large-addon"

echo ""
p "Update the env of the add-on controller to trigger controller upgrade "
pei "oc set env -n open-cluster-management deployment/large-addon-controller ADDON_VERSION=2.0"

echo ""
p "There are 2 manfiestWorks and deploys 4 configmaps "
pei "oc get manifestworks.work.open-cluster-management.io -n cluster1"
pei "oc get configmaps -n open-cluster-management-agent-addon -l app=large-addon"

echo ""
p "Delete the add-on CR  "
pei "oc delete managedclusteraddons.addon.open-cluster-management.io -n cluster1 large-addon"

echo ""
p "The deployed manifests configmaps will be cleaned up too "
pei "oc get manifestworks.work.open-cluster-management.io -n cluster1"
pei "oc get configmaps -n open-cluster-management-agent-addon -l app=large-addon"
