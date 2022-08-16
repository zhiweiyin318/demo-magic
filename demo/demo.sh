#!/usr/bin/env bash

########################
# include the magic
########################
. ../demo-magic.sh


########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
TYPE_SPEED=20

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


# put your demo awesomeness here
echo ""
echo "Demo: Import a managed cluster with CLI in hosted mode"
echo ""

pe "oc --kubeconfig kubeconfig-hub get mcl"

echo ""
echo "1. Create a Projcet on the hub cluster for the managed cluster"
echo ""
pe "oc --kubeconfig kubeconfig-hub new-project cluster2"

echo ""
echo "2. Create a MangedCluster on the hub cluster"
echo ""
pe "oc --kubeconfig kubeconfig-hub apply -f - <<EOF
apiVersion: cluster.open-cluster-management.io/v1
kind: ManagedCluster
metadata:
  name: cluster2
  annotations:
    import.open-cluster-management.io/klusterlet-deploy-mode: Hosted
    import.open-cluster-management.io/hosting-cluster-name: cluster1
spec:
  hubAcceptsClient: true
EOF"

echo ""
echo "3. Create the auto-import-secret of managed cluster in the cluster project"
echo ""
pe "oc --kubeconfig kubeconfig-hub create secret generic auto-import-secret --from-file=kubeconfig=./kubeconfig-cluster2 -n cluster2"

echo ""
echo "4. Check the klusterlet is installed on the hosting cluster"
echo ""
pe "oc --kubeconfig kubeconfig-cluster1 get klusterlet"
pe "oc  --kubeconfig kubeconfig-cluster1 get pods -n klusterlet-cluster2"

