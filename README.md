# Local Kafka Development Workflow
## Tools
1. MiniKube
2. Podman
3. Helm

## Setup
Make sure to have Podman, Kubectl, Helm, and Minikube installed.

When ready, perform the following:

1. Add the `$(minikube ip):5000` address to the insecure registries in your /etc/containers/registries.conf file
2. Create a MiniKube cluster with `minikube start --insecure-registry "10.0.0.0/24"`
3. Enable the registry addon with `minikube addons enable registry`

## Instructions
Make sure to port-forward the MiniKube registry.
```
kubectl port-forward --namespace kube-system service/registry 5000:80
```

Run the deployment script like so:
```
./deploy.sh <DOCKERFILE PATH (relative)> <REGISTRY NAME> <IMAGE NAME>
```

This will:

1. Build your image
2. Tag your image
3. Push your image to the MiniKube registry
4. Create a deployment for your image in the MiniKube "cluster"
