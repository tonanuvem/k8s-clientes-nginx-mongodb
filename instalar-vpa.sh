#!/bin/bash

# Habilitar o VPA (Vertical Pod Autoscaler) em um cluster Kubernetes
# https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler

#!/bin/bash
set -e

echo "👉 Clonando o repositório do autoscaler..."
git clone https://github.com/kubernetes/autoscaler.git
cd autoscaler

echo "👉 Alternando para a branch estável vpa-release-0.8..."
git checkout vpa-release-0.8

echo "👉 Entrando no diretório vertical-pod-autoscaler..."
cd vertical-pod-autoscaler

echo "👉 Executando o script de instalação do VPA..."
./hack/vpa-up.sh

echo ""
echo "✅ VPA instalado com sucesso!"
echo "🔍 Verificando pods no namespace kube-system..."
kubectl get pods -n kube-system | grep vpa

echo ""
echo "✅ Pronto... Agora vamos criar um recurso VPA para testar."
echo ""
