# Kubernetes Commands Reference

## Kubernetes Workflow Overview

Kubernetes (K8s) is an open-source container orchestration platform that
automates deployment, scaling, and management of containerized applications. The
typical Kubernetes workflow follows these stages:

1. **Define**: Create YAML manifests for Deployments, Services, ConfigMaps, and
   other resources
2. **Apply**: Deploy resources to the Kubernetes cluster
3. **Monitor**: Check pod status, logs, and resource usage
4. **Scale**: Adjust the number of pod replicas based on demand
5. **Update**: Roll out new versions with zero-downtime deployments
6. **Debug**: Troubleshoot issues using logs, exec, and describe commands
7. **Clean Up**: Remove resources when no longer needed

### Kubernetes with Docker Desktop

Docker Desktop includes a single-node Kubernetes cluster for local development.
Enable it in Settings > Kubernetes. This provides a local K8s environment
perfect for testing deployments before pushing to production clusters.

---

## 15 Most Used Kubernetes Commands

### 1. `kubectl get`

**List resources in the cluster**

```bash
kubectl get pods                    # List all pods in current namespace
kubectl get pods -A                 # List pods in all namespaces
kubectl get pods -o wide            # Show additional info (node, IP)
kubectl get deployments             # List deployments
kubectl get services                # List services
kubectl get nodes                   # List cluster nodes
kubectl get all                     # List all resources
kubectl get pods --watch            # Watch for changes in real-time
kubectl get pods -n namespace_name  # List pods in specific namespace
```

### 2. `kubectl describe`

**Show detailed information about resources**

```bash
kubectl describe pod pod_name       # Detailed pod information
kubectl describe deployment deploy_name  # Deployment details
kubectl describe service svc_name   # Service details
kubectl describe node node_name     # Node details
kubectl describe pod pod_name -n namespace  # In specific namespace
```

### 3. `kubectl apply`

**Apply configuration from file or stdin**

```bash
kubectl apply -f deployment.yaml    # Apply single file
kubectl apply -f ./configs/         # Apply all YAML files in directory
kubectl apply -f https://url/to/manifest.yaml  # Apply from URL
kubectl apply -f - < manifest.yaml  # Apply from stdin
kubectl apply -k ./kustomize/       # Apply kustomization
```

### 4. `kubectl create`

**Create resources from file or command**

```bash
kubectl create -f deployment.yaml   # Create from file
kubectl create namespace dev        # Create namespace
kubectl create deployment nginx --image=nginx  # Create deployment imperatively
kubectl create service clusterip my-svc --tcp=80:80  # Create service
kubectl create configmap my-config --from-file=config.txt  # Create ConfigMap
kubectl create secret generic my-secret --from-literal=password=secret  # Create Secret
```

### 5. `kubectl delete`

**Delete resources**

```bash
kubectl delete pod pod_name         # Delete pod
kubectl delete -f deployment.yaml   # Delete resources from file
kubectl delete deployment deploy_name  # Delete deployment
kubectl delete pods --all           # Delete all pods in namespace
kubectl delete namespace dev        # Delete namespace and all resources
kubectl delete pod pod_name --grace-period=0 --force  # Force delete
```

### 6. `kubectl logs`

**View container logs**

```bash
kubectl logs pod_name               # View pod logs
kubectl logs pod_name -f            # Follow/stream logs
kubectl logs pod_name --tail=100    # Last 100 lines
kubectl logs pod_name -c container_name  # Specific container in pod
kubectl logs pod_name --previous    # Logs from previous container instance
kubectl logs pod_name --since=1h    # Logs from last hour
kubectl logs -l app=nginx           # Logs from pods with label
kubectl logs deployment/deploy_name # Logs from deployment
```

### 7. `kubectl exec`

**Execute commands in a container**

```bash
kubectl exec pod_name -- ls -la     # Run single command
kubectl exec -it pod_name -- bash   # Interactive bash shell
kubectl exec -it pod_name -- sh     # Interactive sh shell
kubectl exec pod_name -c container_name -- command  # Specific container
kubectl exec -it pod_name -n namespace -- bash  # In specific namespace
```

### 8. `kubectl port-forward`

**Forward local port to pod or service**

```bash
kubectl port-forward pod_name 8080:80  # Forward local 8080 to pod's 80
kubectl port-forward service/my-svc 8080:80  # Forward to service
kubectl port-forward deployment/deploy 8080:80  # Forward to deployment
kubectl port-forward pod_name 8080:80 --address 0.0.0.0  # Listen on all interfaces
```

### 9. `kubectl scale`

**Scale resources**

```bash
kubectl scale deployment nginx --replicas=3  # Scale to 3 replicas
kubectl scale deployment nginx --replicas=0  # Scale down to 0
kubectl scale --replicas=5 -f deployment.yaml  # Scale from file
kubectl scale statefulset db --replicas=3  # Scale StatefulSet
kubectl autoscale deployment nginx --min=2 --max=10 --cpu-percent=80  # Auto-scale
```

### 10. `kubectl rollout`

**Manage rollouts of resources**

```bash
kubectl rollout status deployment/nginx  # Check rollout status
kubectl rollout history deployment/nginx  # View rollout history
kubectl rollout undo deployment/nginx   # Rollback to previous version
kubectl rollout undo deployment/nginx --to-revision=2  # Rollback to specific revision
kubectl rollout restart deployment/nginx  # Restart deployment
kubectl rollout pause deployment/nginx  # Pause rollout
kubectl rollout resume deployment/nginx  # Resume rollout
```

### 11. `kubectl edit`

**Edit resources directly**

```bash
kubectl edit deployment deploy_name  # Edit deployment in default editor
kubectl edit service svc_name       # Edit service
kubectl edit pod pod_name           # Edit pod (limited fields)
kubectl edit configmap config_name  # Edit ConfigMap
KUBE_EDITOR="nano" kubectl edit deployment nginx  # Use specific editor
```

### 12. `kubectl config`

**Manage kubeconfig files**

```bash
kubectl config view                 # View kubeconfig
kubectl config get-contexts         # List all contexts
kubectl config current-context      # Show current context
kubectl config use-context docker-desktop  # Switch context
kubectl config set-context --current --namespace=dev  # Set default namespace
kubectl config delete-context context_name  # Delete context
```

### 13. `kubectl expose`

**Expose resources as services**

```bash
kubectl expose deployment nginx --port=80 --type=ClusterIP  # Create ClusterIP service
kubectl expose deployment nginx --port=80 --type=NodePort   # Create NodePort service
kubectl expose deployment nginx --port=80 --type=LoadBalancer  # Create LoadBalancer
kubectl expose pod nginx --port=80 --name=nginx-svc  # Expose pod
```

### 14. `kubectl top`

**Show resource usage**

```bash
kubectl top nodes                   # Node CPU and memory usage
kubectl top pods                    # Pod CPU and memory usage
kubectl top pods -A                 # All pods across namespaces
kubectl top pods --containers       # Show per-container metrics
kubectl top pods -l app=nginx       # Pods with specific label
```

### 15. `kubectl get events`

**View cluster events**

```bash
kubectl get events                  # List events in current namespace
kubectl get events -A               # Events across all namespaces
kubectl get events --sort-by=.metadata.creationTimestamp  # Sort by time
kubectl get events --field-selector type=Warning  # Only warnings
kubectl get events --watch          # Watch events in real-time
```

---

## Additional Useful Commands

### Resource Information

```bash
kubectl api-resources               # List all resource types
kubectl explain pod                 # Documentation for pod spec
kubectl explain pod.spec.containers # Documentation for specific fields
kubectl get pods -o yaml            # Output in YAML format
kubectl get pods -o json            # Output in JSON format
kubectl get pods -o jsonpath='{.items[*].metadata.name}'  # Custom output
```

### Debugging & Troubleshooting

```bash
kubectl get pods --field-selector=status.phase=Failed  # Failed pods
kubectl get pods --show-labels      # Show all labels
kubectl label pod pod_name env=prod # Add label to pod
kubectl annotate pod pod_name description="My app"  # Add annotation
kubectl cp pod_name:/path/file ./local/path  # Copy files from pod
kubectl cp ./local/file pod_name:/path/  # Copy files to pod
kubectl attach pod_name -i          # Attach to running container
```

### Namespace Management

```bash
kubectl create namespace dev        # Create namespace
kubectl delete namespace dev        # Delete namespace
kubectl get namespaces              # List all namespaces
kubectl config set-context --current --namespace=dev  # Set default namespace
```

### Context & Cluster Management

```bash
kubectl cluster-info                # Display cluster info
kubectl version                     # Show kubectl and cluster version
kubectl api-versions                # List supported API versions
kubectl proxy                       # Start proxy to Kubernetes API
kubectl auth can-i create pods      # Check permissions
kubectl drain node_name             # Drain node for maintenance
kubectl cordon node_name            # Mark node as unschedulable
kubectl uncordon node_name          # Mark node as schedulable
```

### Dry Run & Validation

```bash
kubectl apply -f deployment.yaml --dry-run=client  # Client-side validation
kubectl apply -f deployment.yaml --dry-run=server  # Server-side validation
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml  # Generate YAML
```

---

## Kubernetes Manifest Examples

### Basic Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.21
          ports:
            - containerPort: 80
          resources:
            limits:
              cpu: "500m"
              memory: "512Mi"
            requests:
              cpu: "250m"
              memory: "256Mi"
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 5
```

### Service Types

```yaml
# ClusterIP (internal only)
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: ClusterIP
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

---
# NodePort (external access via node IP)
apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080 # Optional: K8s assigns if not specified

---
# LoadBalancer (cloud load balancer)
apiVersion: v1
kind: Service
metadata:
  name: nginx-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

### ConfigMap & Secret

```yaml
# ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  database_url: "postgres://db:5432/myapp"
  api_key: "not-secret-config-value"
  config.json: |
    {
      "setting1": "value1",
      "setting2": "value2"
    }

---
# Secret
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  username: YWRtaW4= # base64 encoded
  password: cGFzc3dvcmQ= # base64 encoded
```

### StatefulSet

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: postgres
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:15
          ports:
            - containerPort: 5432
          volumeMounts:
            - name: data
              mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
```

### Job & CronJob

```yaml
# Job
apiVersion: batch/v1
kind: Job
metadata:
  name: data-migration
spec:
  template:
    spec:
      containers:
        - name: migrate
          image: myapp/migrator:v1
          command: ["./migrate.sh"]
      restartPolicy: OnFailure
  backoffLimit: 4

---
# CronJob
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-job
spec:
  schedule: "0 2 * * *" # Daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: backup
              image: myapp/backup:v1
              command: ["./backup.sh"]
          restartPolicy: OnFailure
```

---

## Docker Desktop Kubernetes Features

With Docker Desktop's Kubernetes:

- View and manage Kubernetes resources in the GUI Dashboard
- Single-node cluster perfect for local development and testing
- kubectl included and pre-configured to work with local cluster
- Context switching between local and remote clusters
- Reset cluster quickly to clean state
- Set CPU and memory limits in Docker Desktop settings
- LoadBalancer services automatically route to localhost

### Enabling Kubernetes on Docker Desktop

1. Open Docker Desktop Settings
2. Go to Kubernetes section
3. Check "Enable Kubernetes"
4. Click "Apply & Restart"
5. Wait for Kubernetes to start (green indicator)

### Verify Installation

```bash
kubectl cluster-info
kubectl get nodes
kubectl config current-context  # Should show "docker-desktop"
```

---

## Best Practices

1. **Use namespaces**: Separate environments (dev, staging, prod) and teams
2. **Resource limits**: Always set CPU and memory requests/limits
3. **Health checks**: Define liveness and readiness probes for all services
4. **Labels**: Use consistent labeling for organization and selection
5. **Version control**: Store all manifests in git
6. **Secrets management**: Never commit secrets to git, use Secret resources or
   external vaults
7. **Rolling updates**: Use Deployments for zero-downtime updates
8. **ConfigMaps**: Separate configuration from application code
9. **RBAC**: Implement Role-Based Access Control for security
10. **Monitoring**: Use kubectl top and integrate with monitoring tools
    (Prometheus, Grafana)

### Resource Requests vs Limits

```yaml
resources:
  requests:
    cpu: "250m" # Minimum guaranteed
    memory: "256Mi"
  limits:
    cpu: "500m" # Maximum allowed
    memory: "512Mi"
```

### Horizontal Pod Autoscaler

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

---

## Quick Reference Card

| Task              | Command                                                    |
| ----------------- | ---------------------------------------------------------- |
| List pods         | `kubectl get pods`                                         |
| Pod details       | `kubectl describe pod pod_name`                            |
| Pod logs          | `kubectl logs -f pod_name`                                 |
| Execute in pod    | `kubectl exec -it pod_name -- bash`                        |
| Apply config      | `kubectl apply -f file.yaml`                               |
| Delete resource   | `kubectl delete -f file.yaml`                              |
| Scale deployment  | `kubectl scale deployment name --replicas=3`               |
| Rollout status    | `kubectl rollout status deployment/name`                   |
| Rollback          | `kubectl rollout undo deployment/name`                     |
| Port forward      | `kubectl port-forward pod_name 8080:80`                    |
| View events       | `kubectl get events --sort-by=.metadata.creationTimestamp` |
| Resource usage    | `kubectl top pods`                                         |
| Edit resource     | `kubectl edit deployment name`                             |
| Get all resources | `kubectl get all -A`                                       |
| Create namespace  | `kubectl create namespace dev`                             |

---

## Troubleshooting Common Issues

### Pod Not Starting

```bash
# Check pod status
kubectl get pods

# Check pod details for events
kubectl describe pod pod_name

# Check logs
kubectl logs pod_name

# Check previous container logs if crashed
kubectl logs pod_name --previous
```

### ImagePullBackOff Error

```bash
# Check image name and tag
kubectl describe pod pod_name

# Verify image exists locally
docker pull image_name:tag

# Check image pull secrets if private registry
kubectl create secret docker-registry regcred \
  --docker-server=<server> \
  --docker-username=<user> \
  --docker-password=<pass>

# Add to deployment
spec:
  template:
    spec:
      imagePullSecrets:
      - name: regcred
```

### CrashLoopBackOff

```bash
# Check logs for errors
kubectl logs pod_name

# Check previous logs
kubectl logs pod_name --previous

# Check liveness/readiness probes
kubectl describe pod pod_name

# Increase probe delays if needed
livenessProbe:
  initialDelaySeconds: 60  # Give app more time to start
```

### Service Not Accessible

```bash
# Check service endpoints
kubectl get endpoints service_name

# Verify pod labels match service selector
kubectl get pods --show-labels
kubectl describe service service_name

# Test from another pod
kubectl run test --rm -it --image=busybox -- wget -O- http://service_name
```

### Debugging Network Issues

```bash
# Create debug pod
kubectl run debug --rm -it --image=nicolaka/netshoot -- bash

# Inside debug pod
nslookup service_name
curl http://service_name:port
ping pod_ip
```

---

## Converting Docker Compose to Kubernetes

If you're using Docker Desktop with Kubernetes:

```bash
# Install Kompose
brew install kompose  # macOS
# or download from https://kompose.io

# Convert docker-compose.yml to Kubernetes manifests
kompose convert

# Apply to Kubernetes
kubectl apply -f .
```

### Manual Conversion Example

Docker Compose:

```yaml
version: "3.8"
services:
  web:
    image: nginx
    ports:
      - "8080:80"
    environment:
      - ENV=production
```

Kubernetes Equivalent:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: web
          image: nginx
          ports:
            - containerPort: 80
          env:
            - name: ENV
              value: "production"

---
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
    - port: 8080
      targetPort: 80
```

---

## Useful Kubectl Tools & Plugins

### Kubens & Kubectx

Switch contexts and namespaces quickly:

```bash
# Install (macOS)
brew install kubectx

# Usage
kubectx                    # List contexts
kubectx docker-desktop     # Switch context
kubens                     # List namespaces
kubens dev                 # Switch namespace
```

### K9s

Terminal UI for Kubernetes:

```bash
brew install k9s
k9s  # Launch interactive interface
```

### Helm

Package manager for Kubernetes:

```bash
brew install helm
helm repo add stable https://charts.helm.sh/stable
helm install my-release stable/nginx
helm list
helm upgrade my-release stable/nginx
```

### Stern

Multi-pod log tailing:

```bash
brew install stern
stern pod-name-prefix     # Tail logs from multiple pods
stern --namespace dev .   # Tail all pods in namespace
```

---

## Key Kubernetes Concepts

- **Pod**: Smallest deployable unit, contains one or more containers
- **Deployment**: Manages ReplicaSets and provides declarative updates
- **Service**: Exposes pods to network traffic (ClusterIP, NodePort,
  LoadBalancer)
- **ConfigMap**: Store non-sensitive configuration data
- **Secret**: Store sensitive data like passwords and API keys
- **Namespace**: Virtual clusters for resource isolation
- **Ingress**: HTTP/HTTPS routing to services
- **PersistentVolume (PV)**: Storage resource in the cluster
- **PersistentVolumeClaim (PVC)**: Request for storage by a pod
- **StatefulSet**: Manages stateful applications with stable identities
- **DaemonSet**: Ensures a pod runs on all (or some) nodes
- **Job**: Creates one or more pods and ensures they complete successfully
- **CronJob**: Creates Jobs on a schedule

---

## kubectl Command Structure

```bash
kubectl [command] [TYPE] [NAME] [flags]

# Examples:
kubectl get pods
        │    │
        │    └─ Resource type
        └────── Command

kubectl delete pod nginx-pod
        │      │   │
        │      │   └─ Resource name
        │      └───── Resource type
        └──────────── Command

kubectl get pods -n production --selector=app=nginx
        │    │   │              │
        │    │   │              └─ Flag (label selector)
        │    │   └──────────────── Flag (namespace)
        │    └──────────────────── Resource type
        └───────────────────────── Command
```
