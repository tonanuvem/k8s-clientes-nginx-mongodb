#!/bin/bash

# Habilitar o VPA (Vertical Pod Autoscaler) em um cluster Kubernetes
# https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler

set -e

VPA_VERSION="master"  # Ou use uma tag específica como "v1.1.2"
BASE_URL="https://raw.githubusercontent.com/kubernetes/autoscaler/${VPA_VERSION}/vertical-pod-autoscaler/deploy/kubernetes"
NAMESPACE="kube-system"

echo "👉 Aplicando CRDs do VPA..."
kubectl apply -f ${BASE_URL}/vpa-v1-crd-gen.yaml

echo "👉 Aplicando RBAC..."
kubectl apply -f ${BASE_URL}/vpa-rbac.yaml

echo "👉 Implantando componentes do VPA..."
kubectl apply -f ${BASE_URL}/vpa-deployment.yaml

echo ""
echo "✅ VPA implantado com sucesso!"
echo "🔍 Verificando pods no namespace ${NAMESPACE}..."
kubectl get pods -n ${NAMESPACE} | grep vpa

echo ""
echo "✅ Pronto... Agora vamos criar um recurso VPA para testar."
echo ""
