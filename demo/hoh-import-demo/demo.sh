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
TYPE_SPEED=80

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


p "# Demo 1: Import an OCP cluster without ACM as a regional hub cluster."
p ""
p "## The hub1 cluster is a OCP cluster which has no MCH and klusterlet"
pei "oc --kubeconfig=kubeconfig-hub1 get mch -A"
pei "oc --kubeconfig=kubeconfig-hub1 get klusterlet"
p ""
p "## Step 1: Import the ACM Hub cluster in default mode."
p ""
p "## Check on the global hub cluster."
pei "oc --kubeconfig=kubeconfig-hub get mcl"
pei "oc --kubeconfig=kubeconfig-hub get managedclusteraddons -n hub1"
p "## Check on the regional hub cluster."
pei "oc --kubeconfig=kubeconfig-hub1 get mch -n open-cluster-management"
pei "oc --kubeconfig=kubeconfig-hub1 get klusterlet"

p ""
p "# Demo 2: Import an existing ACM Hub cluster with local-cluster as a regional hub cluster."
p ""
p "## The ACM has been installed on the hub2 cluster, and local-cluster is enabled."
pei "oc --kubeconfig=kubeconfig-hub2 get mch -A"
pei "oc --kubeconfig=kubeconfig-hub2 get mcl"
pei "oc --kubeconfig=kubeconfig-hub2 get klusterlet"

p ""
p "## Step 1: Import the ACM Hub cluster in hosted mode."
p "### Step 1.1: Add hosted annotations."
p "### Step 1.2: Disable all addons."
p "### Step 1.3: Import by kubeconfig mode."

p "## Check on the global hub cluster."
pei "oc --kubeconfig=kubeconfig-hub get mcl"
pei "oc --kubeconfig=kubeconfig-hub get klusterlet"

p ""
p "## Step 2: Enable the work-manager addon in hosted mode."
p ""

p "### Step 2.1: Create work-manager addon CR."
p ""
pei "cat work-manager-addon.yaml"
pe "oc --kubeconfig=kubeconfig-hub apply -f work-manager-addon.yaml"

p ""
p "### Step 2.2: Create a kubeconfig secret for the work-manager addon."

p ""
pe "oc --kubeconfig=kubeconfig-hub create secret generic work-manager-managed-kubeconfig --from-file=kubeconfig=./kubeconfig-hub2 -n open-cluster-management-hub2-addon-workmanager"

pe "oc --kubeconfig=kubeconfig-hub get managedclusteraddons -n hub2"
pe "oc --kubeconfig=kubeconfig-hub get pods -n open-cluster-management-hub2-addon-workmanager"

p ""
p "## Step 3: Eanble multicluster-global-hub-controller add-on." 

p ""
p "### Option 1: The multicluster-global-hub-controller addon CR will be created in default mode automatically by default."

p ""
pei "oc --kubeconfig=kubeconfig-hub get managedclusteraddons -n hub1"

pei "oc --kubeconfig=kubeconfig-hub1 get pods -n open-cluster-management-global-hub-system"

p ""
p "### Option 2: We can also enable the multicluster-global-hub-controller addon in hosted mode via a label."
p ""
p "#### Step 1: Label the managedCluster with global-hub.open-cluster-management.io/agent-deploy-mode=Hosted"
pe "oc --kubeconfig=kubeconfig-hub label mcl hub2 global-hub.open-cluster-management.io/agent-deploy-mode=Hosted --overwrite"
pe "oc --kubeconfig=kubeconfig-hub get managedclusteraddons -n hub2 multicluster-global-hub-controller -o yaml"

p ""
p "#### Step 2: Need to create a kubeconfig secret for the HoH addon."
pe "oc --kubeconfig=kubeconfig-hub create secret generic managed-kubeconfig-secret --from-file=kubeconfig=./kubeconfig-hub2 -n open-cluster-management-hub2-hoh-addon"

p "#### Check the add-on and agent pod on the global hub cluster."
pe "oc --kubeconfig=kubeconfig-hub get managedclusteraddons -n hub2"
pe "oc --kubeconfig=kubeconfig-hub get pods -n open-cluster-management-hub2-hoh-addon"


