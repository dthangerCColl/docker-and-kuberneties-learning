Write(kubernetes-commands.md)
  ⎿  Updated kubernetes-commands.md with 460 additions and 4 removals      
       255    kubectl create namespace dev        # Create namespace
       256    kubectl delete namespace dev        # Delete namespace
       257    kubectl get namespaces              # List all namespaces
       258 -  kubens                              # Switch namespace (with 
           - kubens tool)
       258    kubectl config set-context --current --namespace=dev  # Set 
             default namespace
       259    ```
       260    
     ...
       274    
       275    ---
       276    
       277 -  ## Common Kubernetes Manifest Examples
       277 +  ## Kubernetes Manifest Examples
       278    
       279    ### Deployment
       280    
     ...
       453        env: dev
       454    ```
       455    
       456 +  ### StatefulSet
       457 +  
       458 +  ```yaml
       459 +  apiVersion: apps/v1
       460 +  kind: StatefulSet
       461 +  metadata:
       462 +    name: postgres
       463 +  spec:
       464 +    serviceName: postgres
       465 +    replicas: 3
       466 +    selector:
       467 +      matchLabels:
       468 +        app: postgres
       469 +    template:
       470 +      metadata:
       471 +        labels:
       472 +          app: postgres
       473 +      spec:
       474 +        containers:
       475 +        - name: postgres
       476 +          image: postgres:15
       477 +          ports:
       478 +          - containerPort: 5432
       479 +          volumeMounts:
       480 +          - name: data
       481 +            mountPath: /var/lib/postgresql/data
       482 +    volumeClaimTemplates:
       483 +    - metadata:
       484 +        name: data
       485 +      spec:
       486 +        accessModes: [ "ReadWriteOnce" ]
       487 +        resources:
       488 +          requests:
       489 +            storage: 10Gi
       490 +  ```
       491 +  
       492 +  ### DaemonSet
       493 +  
       494 +  ```yaml
       495 +  apiVersion: apps/v1
       496 +  kind: DaemonSet
       497 +  metadata:
       498 +    name: node-exporter
       499 +  spec:
       500 +    selector:
       501 +      matchLabels:
       502 +        app: node-exporter
       503 +    template:
       504 +      metadata:
       505 +        labels:
       506 +          app: node-exporter
       507 +      spec:
       508 +        containers:
       509 +        - name: node-exporter
       510 +          image: prom/node-exporter:latest
       511 +          ports:
       512 +          - containerPort: 9100
       513 +  ```
       514 +  
       515 +  ### Job
       516 +  
       517 +  ```yaml
       518 +  apiVersion: batch/v1
       519 +  kind: Job
       520 +  metadata:
       521 +    name: data-migration
       522 +  spec:
       523 +    template:
       524 +      spec:
       525 +        containers:
       526 +        - name: migrate
       527 +          image: myapp/migrator:v1
       528 +          command: ["./migrate.sh"]
       529 +        restartPolicy: OnFailure
       530 +    backoffLimit: 4
       531 +  ```
       532 +  
       533 +  ### CronJob
       534 +  
       535 +  ```yaml
       536 +  apiVersion: batch/v1
       537 +  kind: CronJob
       538 +  metadata:
       539 +    name: backup-job
       540 +  spec:
       541 +    schedule: "0 2 * * *"  # Daily at 2 AM
       542 +    jobTemplate:
       543 +      spec:
       544 +        template:
       545 +          spec:
       546 +            containers:
       547 +            - name: backup
       548 +              image: myapp/backup:v1
       549 +              command: ["./backup.sh"]
       550 +            restartPolicy: OnFailure
       551 +  ```
       552 +  
       553    ---
       554    
       555    ## Docker Desktop Kubernetes Features
     ...
       520        memory: "512Mi"
       521    ```
       522    
       523 +  ### Pod Disruption Budgets
       524 +  
       525 +  ```yaml
       526 +  apiVersion: policy/v1
       527 +  kind: PodDisruptionBudget
       528 +  metadata:
       529 +    name: myapp-pdb
       530 +  spec:
       531 +    minAvailable: 2
       532 +    selector:
       533 +      matchLabels:
       534 +        app: myapp
       535 +  ```
       536 +  
       537 +  ### Network Policies
       538 +  
       539 +  ```yaml
       540 +  apiVersion: networking.k8s.io/v1
       541 +  kind: NetworkPolicy
       542 +  metadata:
       543 +    name: allow-frontend
       544 +  spec:
       545 +    podSelector:
       546 +      matchLabels:
       547 +        app: backend
       548 +    policyTypes:
       549 +    - Ingress
       550 +    ingress:
       551 +    - from:
       552 +      - podSelector:
       553 +          matchLabels:
       554 +            app: frontend
       555 +      ports:
       556 +      - protocol: TCP
       557 +        port: 8080
       558 +  ```
       559 +  
       560    ---
       561    
       562 +  ## Multi-Container Pod Patterns
       563 +  
       564 +  ### Sidecar Pattern
       565 +  
       566 +  ```yaml
       567 +  apiVersion: v1
       568 +  kind: Pod
       569 +  metadata:
       570 +    name: app-with-sidecar
       571 +  spec:
       572 +    containers:
       573 +    - name: app
       574 +      image: myapp:v1
       575 +      ports:
       576 +      - containerPort: 8080
       577 +    - name: log-shipper
       578 +      image: fluentd:latest
       579 +      volumeMounts:
       580 +      - name: logs
       581 +        mountPath: /var/log
       582 +    volumes:
       583 +    - name: logs
       584 +      emptyDir: {}
       585 +  ```
       586 +  
       587 +  ### Init Container Pattern
       588 +  
       589 +  ```yaml
       590 +  apiVersion: v1
       591 +  kind: Pod
       592 +  metadata:
       593 +    name: app-with-init
       594 +  spec:
       595 +    initContainers:
       596 +    - name: init-db
       597 +      image: busybox
       598 +      command: ['sh', '-c', 'until nc -z db:5432; do sleep 1; 
           + done']
       599 +    containers:
       600 +    - name: app
       601 +      image: myapp:v1
       602 +      ports:
       603 +      - containerPort: 8080
       604 +  ```
       605 +  
       606 +  ---
       607 +  
       608    ## Useful Kubectl Plugins & Tools
       609    
       610    ### Kubens & Kubectx
     ...
       556    brew install helm
       557    helm repo add stable https://charts.helm.sh/stable
       558    helm install my-release stable/nginx
       559 +  helm list
       560 +  helm upgrade my-release stable/nginx
       561 +  helm rollback my-release 1
       562    ```
       563    
       564    ### Kustomize
     ...
       563    Template-free Kubernetes configuration:
       564    
       565    ```bash
       566 -  kubectl apply -k ./kustomization/
       566 +  # kustomization.yaml
       567 +  apiVersion: kustomize.config.k8s.io/v1beta1
       568 +  kind: Kustomization
       569 +  resources:
       570 +    - deployment.yaml
       571 +    - service.yaml
       572 +  configMapGenerator:
       573 +    - name: app-config
       574 +      files:
       575 +        - config.properties
       576 +  
       577 +  # Apply
       578 +  kubectl apply -k ./
       579    ```
       580    
       581 +  ### Stern
       582 +  
       583 +  Multi-pod log tailing:
       584 +  
       585 +  ```bash
       586 +  brew install stern
       587 +  stern pod-name-prefix     # Tail logs from multiple pods
       588 +  stern --namespace dev .   # Tail all pods in namespace
       589 +  ```
       590 +  
       591    ---
       592    
       593    ## Quick Reference Card
     ...
       623      --docker-server=<server> \
       624      --docker-username=<user> \
       625      --docker-password=<pass>
       626 +  
       627 +  # Add to deployment
       628 +  spec:
       629 +    template:
       630 +      spec:
       631 +        imagePullSecrets:
       632 +        - name: regcred
       633    ```
       634    
       635    ### CrashLoopBackOff
     ...
       637    # Check liveness/readiness probes
       638    kubectl describe pod pod_name
       639    
       640 -  # Adjust probe timing if needed
       640 +  # Increase probe delays if needed
       641 +  livenessProbe:
       642 +    initialDelaySeconds: 60  # Give app more time to start
       643    ```
       644    
       645    ### Service Not Accessible
     ...
       664    nslookup service_name
       665    curl http://service_name:port
       666    ping pod_ip
       667 +  traceroute service_name
       668    ```
       669    
       670 +  ### Persistent Volume Issues
       671 +  
       672 +  ```bash
       673 +  # Check PV and PVC status
       674 +  kubectl get pv
       675 +  kubectl get pvc
       676 +  
       677 +  # Describe for details
       678 +  kubectl describe pv pv_name
       679 +  kubectl describe pvc pvc_name
       680 +  
       681 +  # Check storage class
       682 +  kubectl get storageclass
       683 +  ```
       684 +  
       685    ---
       686    
       687    ## Converting Docker Compose to Kubernetes
     ...
       696    
       697    Docker Compose:
       698    ```yaml
       699 +  version: '3.8'
       700    services:
       701      web:
       702        image: nginx
       703        ports:
       704          - "8080:80"
       705 +      environment:
       706 +        - ENV=production
       707 +      volumes:
       708 +        - ./html:/usr/share/nginx/html
       709    ```
       710    
       711    Kubernetes Equivalent:
       712 +  
       713    ```yaml
       714 +  # ConfigMap for environment
       715 +  apiVersion: v1
       716 +  kind: ConfigMap
       717 +  metadata:
       718 +    name: web-config
       719 +  data:
       720 +    ENV: production
       721 +  
       722 +  ---
       723    # Deployment
       724    apiVersion: apps/v1
       725    kind: Deployment
     ...
       725            image: nginx
       726            ports:
       727            - containerPort: 80
       728 +          envFrom:
       729 +          - configMapRef:
       730 +              name: web-config
       731 +          volumeMounts:
       732 +          - name: html
       733 +            mountPath: /usr/share/nginx/html
       734 +        volumes:
       735 +        - name: html
       736 +          hostPath:
       737 +            path: /path/to/html  # For local dev only
       738    
       739    ---
       740    # Service
     ...
       743    
       744    ---
       745    
       746 +  ## Advanced Kubernetes Patterns
       747 +  
       748 +  ### Blue-Green Deployment
       749 +  
       750 +  ```yaml
       751 +  # Blue deployment (current version)
       752 +  apiVersion: apps/v1
       753 +  kind: Deployment
       754 +  metadata:
       755 +    name: myapp-blue
       756 +  spec:
       757 +    replicas: 3
       758 +    selector:
       759 +      matchLabels:
       760 +        app: myapp
       761 +        version: blue
       762 +    template:
       763 +      metadata:
       764 +        labels:
       765 +          app: myapp
       766 +          version: blue
       767 +      spec:
       768 +        containers:
       769 +        - name: myapp
       770 +          image: myapp:v1
       771 +  
       772 +  ---
       773 +  # Green deployment (new version)
       774 +  apiVersion: apps/v1
       775 +  kind: Deployment
       776 +  metadata:
       777 +    name: myapp-green
       778 +  spec:
       779 +    replicas: 3
       780 +    selector:
       781 +      matchLabels:
       782 +        app: myapp
       783 +        version: green
       784 +    template:
       785 +      metadata:
       786 +        labels:
       787 +          app: myapp
       788 +          version: green
       789 +      spec:
       790 +        containers:
       791 +        - name: myapp
       792 +          image: myapp:v2
       793 +  
       794 +  ---
       795 +  # Service (switch between blue/green)
       796 +  apiVersion: v1
       797 +  kind: Service
       798 +  metadata:
       799 +    name: myapp
       800 +  spec:
       801 +    selector:
       802 +      app: myapp
       803 +      version: blue  # Change to 'green' to switch
       804 +    ports:
       805 +    - port: 80
       806 +  ```
       807 +  
       808 +  ### Canary Deployment
       809 +  
       810 +  ```yaml
       811 +  # Stable version (90% traffic)
       812 +  apiVersion: apps/v1
       813 +  kind: Deployment
       814 +  metadata:
       815 +    name: myapp-stable
       816 +  spec:
       817 +    replicas: 9
       818 +    selector:
       819 +      matchLabels:
       820 +        app: myapp
       821 +        track: stable
       822 +    template:
       823 +      metadata:
       824 +        labels:
       825 +          app: myapp
       826 +          track: stable
       827 +      spec:
       828 +        containers:
       829 +        - name: myapp
       830 +          image: myapp:v1
       831 +  
       832 +  ---
       833 +  # Canary version (10% traffic)
       834 +  apiVersion: apps/v1
       835 +  kind: Deployment
       836 +  metadata:
       837 +    name: myapp-canary
       838 +  spec:
       839 +    replicas: 1
       840 +    selector:
       841 +      matchLabels:
       842 +        app: myapp
       843 +        track: canary
       844 +    template:
       845 +      metadata:
       846 +        labels:
       847 +          app: myapp
       848 +          track: canary
       849 +      spec:
       850 +        containers:
       851 +        - name: myapp
       852 +          image: myapp:v2
       853 +  
       854 +  ---
       855 +  # Service (routes to both versions)
       856 +  apiVersion: v1
       857 +  kind: Service
       858 +  metadata:
       859 +    name: myapp
       860 +  spec:
       861 +    selector:
       862 +      app: myapp  # No track label, routes to both
       863 +    ports:
       864 +    - port: 80
       865 +  ```
       866 +  
       867 +  ---
       868 +  
       869 +  ## Horizontal Pod Autoscaler (HPA)
       870 +  
       871 +  ```yaml
       872 +  apiVersion: autoscaling/v2
       873 +  kind: HorizontalPodAutoscaler
       874 +  metadata:
       875 +    name: myapp-hpa
       876 +  spec:
       877 +    scaleTargetRef:
       878 +      apiVersion: apps/v1
       879 +      kind: Deployment
       880 +      name: myapp
       881 +    minReplicas: 2
       882 +    maxReplicas: 10
       883 +    metrics:
       884 +    - type: Resource
       885 +      resource:
       886 +        name: cpu
       887 +        target:
       888 +          type: Utilization
       889 +          averageUtilization: 70
       890 +    - type: Resource
       891 +      resource:
       892 +        name: memory
       893 +        target:
       894 +          type: Utilization
       895 +          averageUtilization: 80
       896 +  ```
       897 +  
       898 +  ---
       899 +  
       900 +  ## Monitoring and Observability
       901 +  
       902 +  ### Resource Quotas
       903 +  
       904 +  ```yaml
       905 +  apiVersion: v1
       906 +  kind: ResourceQuota
       907 +  metadata:
       908 +    name: dev-quota
       909 +    namespace: development
       910 +  spec:
       911 +    hard:
       912 +      requests.cpu: "10"
       913 +      requests.memory: 20Gi
       914 +      limits.cpu: "20"
       915 +      limits.memory: 40Gi
       916 +      pods: "50"
       917 +  ```
       918 +  
       919 +  ### Limit Ranges
       920 +  
       921 +  ```yaml
       922 +  apiVersion: v1
       923 +  kind: LimitRange
       924 +  metadata:
       925 +    name: resource-limits
       926 +    namespace: development
       927 +  spec:
       928 +    limits:
       929 +    - max:
       930 +        cpu: "2"
       931 +        memory: 2Gi
       932 +      min:
       933 +        cpu: "100m"
       934 +        memory: 128Mi
       935 +      default:
       936 +        cpu: "500m"
       937 +        memory: 512Mi
       938 +      defaultRequest:
       939 +        cpu: "250m"
       940 +        memory: 256Mi
       941 +      type: Container
       942 +  ```
       943 +  
       944 +  ---
       945 +  
       946    ## Cheat Sheet: kubectl Command Structure
       947    
       948    ```bash
     ...
       777    - **Kubectl Cheat Sheet**: 
             https://kubernetes.io/docs/reference/kubectl/cheatsheet/
       778    - **Play with K8s**: https://labs.play-with-k8s.com/
       779    - **K8s by Example**: https://kubernetesbyexample.com/
       780 +  - **Kubernetes Patterns**: https://k8spatterns.io/
       781 +  - **CNCF Landscape**: https://landscape.cncf.io/