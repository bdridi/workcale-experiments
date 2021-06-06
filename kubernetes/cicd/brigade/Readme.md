# Brigade

Source code for demo of the CNCF Brigade project for running scriptable automated tasks in the cloud.

## Prerequisites

- Kind
- Docker
- Brig CLI

## Goals

In this demo we will install `Brigade` on kind kubernetes cluster to run scriptable automated tasks ( javascript ) as part of our kubernetes cluster. The scripts are triggered by Brigade events. The following demo cover only two types of events ( exec, generic-gateway ) since we run on local. Brigade script could be triggered by other several methods such as github push or webhook..

## Installation

### Install Brig-Cli

```bash
wget -O brig https://github.com/brigadecore/brigade/releases/download/v1.4.0/brig-darwin-amd64
chmod +x brig
mv brig ~/bin
```

### Install Minikube cluster 

- Run `zsh minikube.sh`  from the root folder

- Wait a couple of minutes and your cluster will be up and ready.

## Create a Brigade project

Once our cluster is up and running we can create a Brigade project as follow :

```bash
dridibilel@DRIDIs-MacBook-Pro brigade % brig project create
? VCS or no-VCS project? no-VCS
? Project Name test
? Add secrets? No
? Secret for the Generic Gateway (alphanumeric characters only). Press Enter if you want it to be auto-generated 
Auto-generated Generic Gateway Secret: m4uvW
? Default script ConfigMap name 
? Upload a default brigade.js script scripts/brigade-default.js
? Default brigade.json config ConfigMap name 
? Upload a default brigade.json config config/brigade.json
? Configure advanced options No
Project ID: brigade-9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c
```

- The project ID is randomly generated.

## Run Brigade scripts

### Trigger simple script

- As brigade scripts are triggered by events, we can run script by executing using the `brig-cli` `run` command. The latter fires an event of type `exec` which allows to execute the javascript file.
The script `brigade-do-nothing.js` does nothing as its name indicates. It will create a simple brigade job.  

- Run the script `brigade-do-nothing.js`

```bash
brig run -f scripts/brigade-do-nothing.js {brigade-project-id}
```

The output should looks like as follows : 

```bash
[brigade:k8s] Creating PVC named brigade-worker-01f7gk9yxfvfdrt3fcbxhnzhjy
[brigade:k8s] Creating secret do-nothing-01f7gk9yxfvfdrt3fcbxhnzhjy
[brigade:k8s] Creating pod do-nothing-01f7gk9yxfvfdrt3fcbxhnzhjy
[brigade:k8s] Timeout set at 900000 milliseconds
[brigade:k8s] Pod not yet scheduled
[brigade:k8s] default/do-nothing-01f7gk9yxfvfdrt3fcbxhnzhjy phase Pending
[brigade:k8s] default/do-nothing-01f7gk9yxfvfdrt3fcbxhnzhjy phase Succeeded
[brigade:app] after: default event handler fired
[brigade:app] beforeExit(2): destroying storage
[brigade:k8s] Destroying PVC named brigade-worker-01f7gk9yxfvfdrt3fcbxhnzhjy
```

### Run a pipeline ( sequence of jobs )  

- The following example runs 3 jobs ( one, two and three ) that share a persistant volume. Jobs one and two print each a message 
onto a shared file `hello.txt` and the thired log the content of the resulted file. 

- Run the script `scripts/brigade-pipeline.js`

```bash
brig run -f scripts/brigade-pipeline.js {brigade-project-id}
```

You should get as result something similar as the following output : 

```bash
Event created. Waiting for worker pod named "brigade-worker-01f7ghypz87068mewzsm1e3wnv".
Build: 01f7ghypz87068mewzsm1e3wnv, Worker: brigade-worker-01f7ghypz87068mewzsm1e3wnv
prestart: no dependencies to install
[brigade] brigade-worker version: 1.2.1
[brigade:k8s] Creating PVC named brigade-worker-01f7ghypz87068mewzsm1e3wnv
[brigade:k8s] Creating secret one-01f7ghypz87068mewzsm1e3wnv
[brigade:k8s] Creating pod one-01f7ghypz87068mewzsm1e3wnv
[brigade:k8s] Timeout set at 900000 milliseconds
[brigade:k8s] Pod not yet scheduled
[brigade:k8s] default/one-01f7ghypz87068mewzsm1e3wnv phase Pending
[brigade:k8s] default/one-01f7ghypz87068mewzsm1e3wnv phase Succeeded
done         
[brigade:k8s] Creating secret two-01f7ghypz87068mewzsm1e3wnv
[brigade:k8s] Creating pod two-01f7ghypz87068mewzsm1e3wnv
[brigade:k8s] Timeout set at 900000 milliseconds
[brigade:k8s] Pod not yet scheduled
[brigade:k8s] default/two-01f7ghypz87068mewzsm1e3wnv phase Succeeded
[brigade:k8s] Creating secret three-01f7ghypz87068mewzsm1e3wnv
[brigade:k8s] Creating pod three-01f7ghypz87068mewzsm1e3wnv
[brigade:k8s] Timeout set at 900000 milliseconds
[brigade:k8s] Pod not yet scheduled
[brigade:k8s] default/three-01f7ghypz87068mewzsm1e3wnv phase Succeeded
[brigade:app] after: default event handler fired
[brigade:app] beforeExit(2): destroying storage
[brigade:k8s] Destroying PVC named brigade-worker-01f7ghypz87068mewzsm1e3wnv
```

### Fire SimpleEvent with Generic Gateway

Brigade contains a Generic Gateway that can be used to accept requests from other platforms or systems. Generic Gateway is a separate component in the Brigade system, like Github and Container Registry (CR) Gateways.
Generic Gateway listens and accepts POST JSON messages. 

- Before firing the event, we need to expose the generic gateway by a port-forwarding

```bash
kubectl port-forward service/brigade-server-brigade-generic-gateway 8082:8081
```

- Create the simpleEvent and trigger the default script `scripts/brigade-default.js` by executing the following curl command. ( We will need the secret generated at the project creation )
  
```bash
curl --header "Content-Type: application/json" \
  --request POST \
  --data '{
    "key1": "Cloud",
    "key2": "Native"
}' \
  http://localhost:8082/simpleevents/v1/{brigade-project-id}/{secret}
```

- The response should looks as follows : `{"status":"Success. Build created"}`

## Monitor Brigade jobs execution history

Brigade comes with a fancy tool called `kashti` that offers simple GUI as a dashboard. To access to this dashboard you
need only to run `brig dashboard`, an interface will be opened automatically in the navigator on port 8081, in which you can
consult all your created brigade projets and jobs executions.

## Using a VCS Brigade project

In this demo we covered the non VCS brigade project locally that fit with our main purpose which is a first hands with Brigde.
Please Note that Brigade offers also the possiblity to create a VCS project and trigger scripts on the kubernetes cluster based on github commits for example. This feature is more intresting for real use cases in production such as running tests, ci pipelines ...

- For further informations please visit the [Brigade Official Websit](https://docs.brigade.sh/intro/tutorial03/)

## Versions

This tutorial is designed to run entirely in Kubernetes and has been tested with the following development environment and component versions.

- macOS Catalina v10.15.7
- kubectl client v1.16.6-beta.0
- kubectl server v1.19.1
- helm v3.3.1
- minikube v1.15.1
- brig-cli v1.4.0