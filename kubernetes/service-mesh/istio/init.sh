
function init_cluster {
  minikube delete 
  minikube start --memory 4096
}


function install_istio {
istioctl install --set profile=demo -y
}

function install_applications {
  kubectl label namespace default istio-injection=enabled
  kubectl apply -f manifests/bookinfo-gateway.yaml
  kubectl apply -f manifests/bookinfo.yaml
}

function install_infra {
  echo "install infrastructure"
  # install addons ( kiali, prometheus, grafana, jaeger ) 
  kubectl apply -f manifests/addons
}
