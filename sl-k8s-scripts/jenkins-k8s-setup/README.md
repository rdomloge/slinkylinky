# Jenkins Kubernetes Setup

This project provides a complete setup for running Jenkins in a Kubernetes environment, including dedicated workers for building Spring Java projects and Next.js React projects. 

## Notes from Ramsay (the rest was CoPilot)
When Jenkins starts a build it first checks out on the controller node.
This then accesses the Jenkinsfile which tells it what to get the worker to do.
git config --global safe.directory '*'
Lightweight checkout should be unchecked in the Jenkins job configuration.
Branch should be changed to 'main' in the Jenkins job configuration.

## Builder preparation
The kubernetes nodes obviously all run K8S containers, but they don't have Docker installed by default.
A node needs to be selected - I suggest the single rpi5 node, k8s-node-13, to have Docker installed on it.

To install Docker on the worker node, use https://docs.docker.com/engine/install/ubuntu/

The node must then be labeled to indicate that it has Docker, using
```
kubectl label node k8s-node-13 node-role.kubernetes.io/image-builder=true
```

Install a cross-platform builder on the node:
```
    docker buildx create --name mybuilder --driver docker-container --bootstrap --use --platform linux/amd64,linux/arm64
```

Finally, Jenkins needs to be configured with the DockerHub credentials. This can be done in the Jenkins UI under "Manage Jenkins" -> "Manage Credentials".

## Kubernetes access setup
To allow Jenkins to access the Kubernetes cluster, you need to get the kubeconfig file from your cluster provider and save it locally (delete it straight after use).
Then in Jenkins create a new set of credentials of type 'file', give it the ID `prod-k8s`, and upload the kubeconfig file.

## Linode Kubernetes CSI Driver
Install chocolated
Install helm
helm install linode-csi-driver --set apiToken="<token from linode console>" --set region="London 2" linode-csi/linode-blockstorage-csi-driver


## Project Structure

```
jenkins-k8s-setup
├── jenkins
│   ├── jenkins-statefulset.yml       # Defines the StatefulSet for Jenkins
│   ├── jenkins-service.yml            # Defines the LoadBalancer service for Jenkins
├── workers
│   ├── spring-worker-deployment.yml   # Defines the Deployment for the Spring worker
│   ├── spring-worker-service.yml      # Defines the Service for the Spring worker
│   ├── nextjs-worker-deployment.yml   # Defines the Deployment for the Next.js worker
│   ├── nextjs-worker-service.yml      # Defines the Service for the Next.js worker
└── README.md                          # Documentation for the project
```

## Setup Instructions

1. **Prerequisites**
   - Ensure you have a Kubernetes cluster running.
   - Install `kubectl` to interact with your Kubernetes cluster.

2. **Deploy Jenkins**
   - Apply the Jenkins StatefulSet:
     ```
     kubectl apply -f jenkins/jenkins-statefulset.yml
     ```
   - Apply the Jenkins service:
     ```
     kubectl apply -f jenkins/jenkins-service.yml
     ```

3. **Deploy Workers**
   - Deploy the Spring worker:
     ```
     kubectl apply -f workers/spring-worker-deployment.yml
     ```
   - Apply the Spring worker service:
     ```
     kubectl apply -f workers/spring-worker-service.yml
     ```
   - Deploy the Next.js worker:
     ```
     kubectl apply -f workers/nextjs-worker-deployment.yml
     ```
   - Apply the Next.js worker service:
     ```
     kubectl apply -f workers/nextjs-worker-service.yml
     ```

4. **Access Jenkins**
   - Once the services are up and running, you can access the Jenkins frontend using the external IP of the LoadBalancer service on port 8099.

## Usage

- After accessing Jenkins, you can configure your jobs to use the Spring and Next.js workers for building your projects.
- Make sure to set the appropriate environment variables in your Jenkins jobs to connect to the workers.

## Notes

- Replace any placeholder values in the YAML files with your actual configuration details.
- Ensure that your Kubernetes cluster has sufficient resources to run Jenkins and the worker pods.