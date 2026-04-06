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

## Running Workers on Windows (Docker Desktop)

When working on the Windows machine with Docker Desktop, you can run Jenkins workers locally instead of (or alongside) the Pi cluster workers. The same Docker images used by Kubernetes are reused here.

### How it works with the Pi cluster workers

The local workers are **additional** agents, not replacements. The Pi cluster continues to run its own workers (`maven-worker`, `kubectl-worker`, etc.). The local workers register under different names (`maven-worker-local`, etc.) but carry the same **labels** as their Pi counterparts.

Jenkins selects agents by label, so when your local workers are running it will distribute builds across both pools — faster builds when Docker Desktop is open on the Windows machine, and automatic fallback to the Pi workers when it is not.

### First-time setup in Jenkins (do this once per local worker)

For each of the four workers, create a new permanent agent in the Jenkins UI:

1. **Manage Jenkins → Nodes → New Node**
2. Name it `maven-worker-local` (or `kubectl-worker-local`, etc.)
3. Set **Labels** to the same value as the corresponding Pi worker (e.g. `maven-worker` for the maven one) — this is what lets Jenkins treat them as a pool
4. Set **Launch method** to "Launch agent by connecting it to the controller"
5. Save — Jenkins will show a secret for that node

Repeat for each of the four workers.

### First-time setup on Windows

1. Make sure Docker Desktop is running and the Pi Jenkins instance is reachable on the network.
2. Open a terminal in `workers/` and run:
   ```
   setup-autostart.bat
   ```
   This will create a `.env` file from `.env.example` and open it in Notepad.

3. Fill in `.env`:
   - `JENKINS_URL`: the Pi cluster's external IP with port 8099 (e.g. `http://10.0.0.12:8099`)
   - Worker secrets: copy the secret shown on each new node's page in Jenkins

4. Re-run `setup-autostart.bat` — it will pull images and start all four workers.

### Auto-start behaviour

Workers use `restart: unless-stopped`. This means:
- They **will** restart automatically whenever Docker Desktop starts.
- They **will not** restart if you manually stop them (via `stop-workers.bat` or Docker Desktop UI) — run `start-workers.bat` to re-enable auto-start.

### Day-to-day commands

| Script | What it does |
|--------|--------------|
| `setup-autostart.bat` | First-time setup: creates `.env`, pulls images, starts workers |
| `start-workers.bat` | Start workers (and re-enable auto-start after a manual stop) |
| `stop-workers.bat` | Stop workers without removing containers |
| `docker compose logs -f` | Tail live logs from all workers |
| `docker compose ps` | Show running status |

### How the workers connect to Jenkins

Each worker container runs `jenkins/inbound-agent` (JDK 21) and connects outbound to Jenkins via HTTP (no inbound ports needed). The `JENKINS_URL`, `JENKINS_AGENT_NAME`, and `JENKINS_SECRET` env vars are read from `.env`.

The **maven-worker** mounts the Docker socket (`/var/run/docker.sock`) so it can run `docker buildx` inside the container — Docker Desktop exposes this socket to Linux containers automatically.

### Worker images

| Container | Jenkins node name | Image | Notes |
|-----------|------------------|-------|-------|
| `jenkins-maven-worker-local` | `maven-worker-local` | `rdomloge/jenkins-worker-maven-jdk21-latest:1.0.14` | Maven + Docker; mounts docker.sock |
| `jenkins-kubectl-worker-local` | `kubectl-worker-local` | `rdomloge/jenkins-worker-kubectl:1.0.0` | kubectl |
| `jenkins-helm-worker-local` | `helm-worker-local` | `rdomloge/jenkins-worker-helm:1.0.0` | Helm + kubectl |
| `jenkins-psql-worker-local` | `psql-worker-local` | `rdomloge/jenkins-worker-psql:1.0.0` | psql client |

### Files

```
workers/
├── docker-compose.yml               # Defines all four workers for Docker Desktop
├── .env.example                     # Template — copy to .env and fill in secrets
├── maven-worker-logging.properties  # Java logging config mounted into maven-worker
├── setup-autostart.bat              # First-time setup
├── start-workers.bat                # Start / re-enable auto-start
└── stop-workers.bat                 # Stop workers
```

> `.env` is gitignored — never commit it.

## Notes

- Replace any placeholder values in the YAML files with your actual configuration details.
- Ensure that your Kubernetes cluster has sufficient resources to run Jenkins and the worker pods.