function install_brigade {
  helm repo add brigade https://brigadecore.github.io/charts
  helm install brigade-server brigade/brigade  --set genericGateway.enabled=true
}