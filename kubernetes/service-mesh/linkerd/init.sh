
function init_cluster {  
  kind delete cluster --name linkerd && kind create cluster --name linkerd --config=.kind/config.yaml
}

function init_app {
    kubectl apply -f app
}

function init_ingress_controller {
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
}

function install_linkerd {
  linkerd install | kubectl apply -f -
  #linkerd check
  kubectl apply -k github.com/weaveworks/flagger/kustomize/linkerd
  cat app/wiki.yaml | linkerd inject - | k apply -f -  
  cat app/webapp.yaml | linkerd inject - | k apply -f -  
  cat app/api.yaml | linkerd inject - | k apply -f -    
}
