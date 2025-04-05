
# Task 3: Kubernetes Cluster Setup and Application Deployment

This README provides a step-by-step guide to setting up a Kubernetes (K8s) cluster, deploying a web application, and exposing it via an Ingress controller using NGINX and a Load Balancer.

![](/assets/icons8-kubernetes-96.png)

---

## Prerequisites
- A Kubernetes cluster-ready environment (master and worker nodes).
- `kubectl` installed and configured.
- Docker installed for building and pushing the app image.
- Helm installed for NGINX Ingress Controller setup.
- Access to Docker Hub for image storage.
- AWS CLI configured (for Load Balancer and Target Group setup).

---

## Step 1: Setting Up the Kubernetes Cluster

### 1.1 Prepare the Nodes
- Run the cluster [setup script](/Task3/k8s.sh) on the **master machine** and all **worker nodes** to configure the environment.
- Ensure all nodes are reachable and properly networked.

### 1.2 Initialize the Master Node
- On the master node, initialize the Kubernetes cluster:
  ```bash
  kubeadm init
  ```
- Follow the output instructions to set up `kubectl` and save the `join` command for worker nodes.

### 1.3 Join Worker Nodes
- On each worker node, run the `join` command provided by the master node initialization (e.g.):
  ```bash
  kubeadm join <master-ip>:<port> --token <token> --discovery-token-ca-cert-hash <hash>
  ```
- Verify all nodes are joined:
  ```bash
  kubectl get nodes
  ```

---

## Step 2: Setting Up the Application

### 2.1 Modify the Application
- Edit the app design as needed (e.g., UI changes, configuration updates).

### 2.2 Build and Push Docker Image
- Build the Docker image:
  ```bash
  docker build -t alyesmaeil/springboot-gradle-web-app:latest .
  ```
- Push the image to Docker Hub:
  ```bash
  docker push alyesmaeil/springboot-gradle-web-app:latest
  ```

---

## Step 3: Create Namespace

- Create a namespace called `ivolve`:
  ```bash
  kubectl create namespace ivolve
  ```
- Verify the namespace:
  ```bash
  kubectl get namespaces
  ```

**Demo**:  
![Namespace Creation](/assets/namespace.png)

---

## Step 4: Create Deployment

### 4.1 Define the Deployment
- Create a file named `deployment.yml`:
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: ivolve-task3
    namespace: ivolve
  spec:
    replicas: 3
    selector:
      matchLabels:
        app: web-app
    template:
      metadata:
        labels:
          app: web-app
      spec:
        containers:
        - name: web-app
          image: alyesmaeil/springboot-gradle-web-app:latest
          ports:
          - containerPort: 8081
  ```

### 4.2 Apply the Deployment
- Deploy the application:
  ```bash
  kubectl apply -f deployment.yml
  ```
- Verify the deployment:
  ```bash
  kubectl get deployments -n ivolve
  ```

---

## Step 5: Create Service

### 5.1 Define the Service
- Create a file named `service.yml`:
  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    name: ivolve-task3
    namespace: ivolve
  spec:
    selector:
      app: web-app
    ports:
    - protocol: TCP
      port: 80
      targetPort: 8081
    type: ClusterIP
  ```

### 5.2 Apply the Service
- Apply the service configuration:
  ```bash
  kubectl apply -f service.yml
  ```
- Verify the service:
  ```bash
  kubectl get services -n ivolve
  ```

**Demo**:  
![Resources Overview](/assets/all-resourece.png)

---

## Step 6: Install NGINX Ingress Controller with Helm

- Add the Helm repository for NGINX Ingress:
  ```bash
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update
  ```
- Install the NGINX Ingress Controller:
  ```bash
  helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ivolve
  ```
- Verify the installation:
  ```bash
  kubectl get pods -n ivolve
  ```

**Demo**:  
![NGINX Controller Installed](/assets/nginx-controller.png)

---

## Step 7: Configure Networking

### 7.1 Create Target Group
- In AWS, create a **Target Group** forwarding traffic from the worker nodes to the NGINX controller port (default: 80 or 443).
- Register the worker nodes in the Target Group.

### 7.2 Create Load Balancer
- Set up an **Application Load Balancer (ALB)** in AWS.
- Attach the Target Group to the ALB.
- Note the ALB DNS name (e.g., `ing-1997727146.us-east-1.elb.amazonaws.com`).

---

## Step 8: Create Ingress

### 8.1 Define the Ingress
- Create a file named `ingress.yml`:
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: ivolve-ingress
    namespace: ivolve
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /
  spec:
    ingressClassName: nginx
    rules:
    - host: ing-1997727146.us-east-1.elb.amazonaws.com
      http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: ivolve-task3
              port:
                number: 80
  ```

### 8.2 Apply the Ingress
- Apply the Ingress configuration:
  ```bash
  kubectl apply -f ingress.yml
  ```
- Verify the Ingress:
  ```bash
  kubectl describe ingress ivolve-ingress -n ivolve
  ```

**Demo**:  
![Ingress Description](/assets/des-ing.png)

---

## Final Verification

- Access the application via the Load Balancer URL (e.g., `http://ing-1997727146.us-east-1.elb.amazonaws.com`).
- Ensure the app is running with 3 replicas and responding correctly.

**Final Demo**:
![App Running](/assets/finaldemo.png)

![App Running](/assets/final-demo.gif)

---

## Troubleshooting
- Check pod logs:
  ```bash
  kubectl logs <pod-name> -n ivolve
  ```
- Describe resources for detailed status:
  ```bash
  kubectl describe <resource-type> <resource-name> -n ivolve
  ```

