# Service mesh - Istio

Source code for the Kubernetes service mesh Istio demo. This demo is based on the official documentation of Istio.

## Prerequisites

- Istio Cli ( `$ curl -L https://istio.io/downloadIstio | sh -`)
- Mermaid
- Kind
- Docker

## Goals

In this demo we will set up `Istio` service mesh in a minikube . We will be using the Istio BookInfo project as a demo.

## Demo project: BookInfo

[https://istio.io/latest/docs/examples/bookinfo/](https://istio.io/latest/docs/examples/bookinfo/)

## Setup and launch the application

Start the minikube kubernetes cluster by running the bash `minikube.sh` that install `Istio` and the demo application. 

### Check up the Bookinfo service

Verify everything is working correctly up to this point. Run this command to see if the app is running inside the cluster and serving HTML pages by checking for the page title in the response:

```bash
$ kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
```

```html
<title>Simple Bookstore App</title>
```

### Check up the ingress gateway

Since we run on a local machine we need to create a minikube tunnel in order to reach the Istio Ingress Gateway ( traefik ). 

- Execute `minikube tunnel` in a new terminal

- Add `127.0.0.1 bookinfo.com` to your `hosts` file
  
- If everything is okay you should view the web page in the browser at `http://bookinfo.com/productpage`.

## Mesh overview with Kiali

Launch `Kiali` dashboard `istioctl dashboard kiali`

To see trace data, you must send requests to your service. The number of requests depends on Istio’s sampling rate. You set this rate when you install Istio. The default sampling rate is 1%. You need to send at least 100 requests before the first trace is visible. To send a 100 requests to the productpage service, use the following command:

```bash
$ for i in $(seq 1 100); do curl -s -o /dev/null "http://bookinfo.com/productpage"; done
```

The Kiali dashboard shows an overview of your mesh with the relationships between the services in the Bookinfo sample application. It also provides filters to visualize the traffic flow.

## Others Istio features

Istio is an extensible tool that can offer a complete overview of your system. In this demo the installation script install addons such 
as `Prometheus`, `Jaeger`, `Grafana` and `Kiali`. 
Alongside the mesh management, Istio provides others intresting feaures like : 

- Request routing
- Fault injection
- Traffic shifting
- Querying metrics
- Visualizing metrics
- Accessing external services
- Visualizing your mesh

## Further informations

[https://istio.io/latest/docs/setup/getting-started/](https://istio.io/latest/docs/setup/getting-started/)

## Versions

This tutorial is designed to run entirely in Kubernetes and has been tested with the following development environment and component versions.

- macOS Catalina v10.15.7
- go go1.15.5
- kubectl client v1.16.6-beta.0
- kubectl server v1.19.1
- kind v0.8.1
- helm v3.3.1
- kind v0.9.0
- IstioCli 1.11.3 
