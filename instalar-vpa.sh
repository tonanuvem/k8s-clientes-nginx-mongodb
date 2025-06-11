#!/bin/bash

# Habilitar o VPA (Vertical Pod Autoscaler) em um cluster Kubernetes
# https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler

set -e

VPA_VERSION="master"  # ou uma versão como "v1.1.2" se preferir travar
NAMESPACE="kube-system"

echo "👉 Baixando e aplicando os CRDs do VPA..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/$VPA_VERSION/vertical-pod-autoscaler/deploy/vpa-v1-crd-gen.yaml

echo "👉 Criando RBAC e permissões..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/$VPA_VERSION/vertical-pod-autoscaler/deploy/vpa-rbac.yaml

echo "👉 Implantando os componentes VPA..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/$VPA_VERSION/vertical-pod-autoscaler/deploy/vpa-deployment.yaml

echo "✅ VPA implantado com sucesso!"

echo ""
echo "🔍 Verificando pods no namespace $NAMESPACE..."
kubectl get pods -n $NAMESPACE | grep vpa

echo ""
echo "✅ Pronto... Agora vamos criar um recurso VPA para testar."
echo ""
