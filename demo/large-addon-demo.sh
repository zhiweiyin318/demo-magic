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
# TYPE_SPEED=20

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
echo "Demo: The latest addon-framework supports large size of manifests in an add-on."


echo ""
echo "There is an exmaple add-on named large-addon"
echo ""
pe "oc get managedclusteraddons.addon.open-cluster-management.io -n cluster1"

echo ""
echo "The addon has a manfiestWork and deploys 2 configmaps"
echo ""
pe "oc get manifestworks.work.open-cluster-management.io -n cluster1"

echo ""
pe "oc get configmaps -n open-cluster-management-agent-addon"

echo ""
echo "Update the env of the add-on controller to trigger controller upgrade"
echo ""
pe "oc set env -n open-cluster-management deployment/large-addon-controller ADDON_VERSION=2.0"

echo ""
echo "There are 2 manfiestWorks and deploys 4 configmaps"
echo ""
pe "oc get manifestworks.work.open-cluster-management.io -n cluster1"

echo ""
pe "oc get configmaps -n open-cluster-management-agent-addon"

echo ""
echo "delete the add-on CR to delete the manifests and clean up the configmaps"
echo ""
pe "oc delete managedclusteraddons.addon.open-cluster-management.io -n cluster1 large-addon"

echo ""
pe "oc get manifestworks.work.open-cluster-management.io -n cluster1 -w"

echo ""
pe "oc get configmaps -n open-cluster-management-agent-addon"
