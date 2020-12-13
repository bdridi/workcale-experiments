# Kubernetes Ingress Controller NGINX

Source code for the Kubernetes Ingress Controller demo using the Microlearning demo app.

## Goals

In this demo we will install NGINX ingress controller on our Kind kubernetes cluster `ingress-nginx` in the namespace `ingress-nginx`. We will create two ingress resources `api-ingress` for the public api and `webapp-ingress` for the web application to be reachable from outside the cluster.

## Demo project: Microlearning

### Overview

Microlearning is demo project for training purpose. The idea is to display a list of random wiki pages to the user based on a set of categories stored in a redis database.

### Microservices

- Microlearning-api
  - the public api  
- Microlearning redis
  - the database to store categories
- Microlearning web application
- Microlearning-wiki service
  - search on wikipedia a random pages with specific category. 

### Architecture

![Alt text](archi.png?raw=true "Architecture")

## Installation

- Run `zsh kind.sh`  from the root folder

- Wait for a couple of minutes and your cluster will be ready.
  
- The ingress controller might takes a little bit more time before it becomes up and running. Wait until is ready to process requests running

```shell
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

- Setup hosts :
Since we work locally, kind is configured to make the ingress controller reachable over localhost. So we need to configure our hosts file to be able to use our custom domain names.

  - add the follwing entries to your `/etc/hosts` file :<br>

  ```shell
  127.0.0.1 api.microlearning.workcale.io
  127.0.0.1 microlearning.workcale.io
  ```

- Run `watch kubectl get pods` so that you can monitor when all the pods are up and running

## Viewing the app

- Add a set of categories :

  `curl --location --request POST 'api.microlearning.workcale.io/api/v1/microlearning/categories?name=kubernetes'`

- Open `microlearning.workcale.io` in a browser and you should see the app UI running and serving wiki pages about kubernetes
  
## Versions

This tutorial is designed to run entirely in Kubernetes and has been tested with the following development environment and component versions.

- macOS Catalina v10.15.7
- go go1.15.5
- kubectl client v1.16.6-beta.0
- kubectl server v1.19.1
- kind v0.8.1
- helm v3.3.1
- kind v0.9.0
