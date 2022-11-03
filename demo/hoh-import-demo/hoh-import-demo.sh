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
. ../../demo-magic.sh


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
p "Demo: Import an existing ACM Hub cluster with local-cluster as a regional hub cluster."


echo ""
p "Step 1: Import the ACM Hub cluster in hosted mode. "

echo ""

pei "oc get mcl"

pei "oc get klusterlet"

echo ""
p "Step 2: Enable the work-manager addon in hosted mode."
echo ""

p "Step 2.1: Create work-manager addon CR."
pei "cat work-manager-addon.yaml"
pei "oc apply -f work-manager-addon.yaml"

p "Step 2.2: Create a kubeconfig secret for the work-manager addon."
pei "oc create secret generic work-manager-managed-kubeconfig --from-file=kubeconfig=./kubeconfig-hub1 -n open-cluster-management-hub1-addon-workmanager"

pei "oc get managedclusteraddons -n hub1"

echo ""
p "Step 3: Eanble multicluster-global-hub-controller addon" 

echo ""
p "The multicluster-global-hub-controller addon CR will be created in default mode automaticlly."

pei "oc get managedclusteraddons -n hub1"

pei "oc --kubeconfig=kubeconfig-hub1 get pods -n open-cluster-management-global-hub-system"

echo ""
p "We can also enable the multicluster-global-hub-controller addon in hosted mode."

pei "oc label mcl hub1 global-hub.open-cluster-management.io/agent-deploy-mode=Hosted --overwrite"

pei "oc get managedclusteraddons -n hub1 multicluster-global-hub-controller -o yaml"

echo ""
p "Create a kubeconfig secret for the HoH addon."

pei "oc create secret generic managed-kubeconfig-secret --from-file=kubeconfig=./kubeconfig-hub1 -n open-cluster-management-hub1-hoh-addon"

pei "oc get managedclusteraddons -n hub1"
pei "oc get pods -n open-cluster-management-hub1-hoh-addon"


