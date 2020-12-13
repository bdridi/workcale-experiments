
function init_cluster {  
  kind delete cluster --name ingress-nginx && kind create cluster --name ingress-nginx --config=.kind/config.yaml
}

function init_app {
    kubectl apply -f app
}

function init_ingress_controller {
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
}
