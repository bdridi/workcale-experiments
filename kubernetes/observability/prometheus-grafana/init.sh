
function init_cluster {  
  kind delete cluster --name prometheus-grafana && kind create cluster --name prometheus-grafana --config=.kind/config.yaml
}

function init_app {
    kubectl apply -f app/
}

function init_ingress_controller {
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
}


function init_prometheus_grafana {
  helm repo add stable https://charts.helm.sh/stable
  helm install -f helm/prometheus-values.yaml prometheus stable/prometheus
  helm install -f helm/grafana-values.yaml grafana stable/grafana
}

function init_infrastructure {
  init_ingress_controller
  init_prometheus_grafana
}