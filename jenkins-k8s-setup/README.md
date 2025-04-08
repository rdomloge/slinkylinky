# Jenkins Kubernetes Setup

This project provides a complete setup for running Jenkins in a Kubernetes environment, including dedicated workers for building Spring Java projects and Next.js React projects. 

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