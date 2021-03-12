
function init_cluster { 
   
  kind delete cluster --name vault-approle && kind create cluster --name vault-approle --config=.kind/config.yaml

  helm install -f helm/consul-values.yaml consul hashicorp/consul --version "0.23.1" --wait

  helm install -f helm/vault-values.yaml vault hashicorp/vault --version "0.6.0" --wait

}
