## Environment Setup

AWS Free Tier account was configured for this assignment.

Security best practices followed:
- Created IAM user instead of using root account.
- Enabled programmatic access.
- Configured AWS CLI locally.

## AWS CLI Configuration

Configured AWS CLI using IAM user credentials.
Region: ap-south-1

## Infrastructure as Code

Terraform is used to provision AWS resources.
This ensures:
- Reproducibility
- Version control
- Automation

## Docker Swarm Cluster Setup

Docker Swarm was initialized on the manager node.
The cluster follows a manager-worker architecture.

Benefits:
- High availability
- Built-in load balancing
- Service discovery

## Docker Swarm Cluster

A Docker Swarm cluster was created with:
- 1 Manager node
- 1 Worker node

The worker joined the cluster using a join token and private VPC IP.

Cluster status verified using:
docker node ls

This setup ensures:
- High availability
- Service orchestration
- Internal secure communication using private networking

## Local Application Testing

Before containerization, both services were validated locally in a Linux environment to ensure runtime stability and dependency compatibility. This step reduces deployment risks and ensures faster debugging in production.

### Environment Setup

A local Ubuntu VM was used to closely replicate the AWS EC2 production environment. This ensured consistency across development and deployment.

---

### Node.js (NestJS) Service

#### Steps Performed

1. Installed Node.js using NVM to manage runtime compatibility.
2. Resolved dependency issues caused by version mismatch.
3. Cleaned and reinstalled dependencies to fix module resolution errors.
4. Verified application startup and logs.
5. Confirmed API endpoints and health checks.

#### Key Validations

* Application successfully started.
* Health endpoint verified:

  ```
  curl http://localhost:3000/health
  ```
* Additional routes tested:

  ```
  /hello
  /users/{id}
  ```
* Port exposure confirmed (3000).

---

### Python (FastAPI) Service

#### Steps Performed

1. Installed Python dependencies using a virtual environment.
2. Addressed Ubuntu package restrictions (PEP 668).
3. Installed required venv modules.
4. Activated isolated environment.
5. Verified application startup and endpoints.

#### Key Validations

* Swagger documentation available at:

  ```
  http://localhost:8000/docs
  ```
* Health endpoint verified:

  ```
  curl http://localhost:8000/health
  ```
* Additional endpoints tested:

  ```
  /hello
  /products/{id}
  ```
* Port exposure confirmed (8000).

---

### Why Local Testing Was Critical

This phase ensured:

* Runtime compatibility
* Correct dependency resolution
* Verified service health endpoints
* Clear understanding of application behavior
* Reduced container debugging time
* Faster and reliable deployments


### Containerization
After validating both services locally, Docker images were created to ensure portability and environment consistency.

### Node.js (NestJS) Service Containerization
Steps Performed
* Created a production-ready Dockerfile.
* Used lightweight Node base image.
* Installed dependencies inside container.
* Built the application.
* Exposed application port (3000).
* Verified container health.
Image built successfully:

docker build -t client-a-node:1.0 .
docker run -p 3000:3000 client-a-node:1.0
curl http://localhost:3000/health

Container status confirmed healthy.

### Python (FastAPI) Service Containerization
Steps Performed
* Created Dockerfile using slim Python base image.
* Installed required dependencies.
* Configured Uvicorn as the entrypoint.
* Exposed port 8000.
Verified service accessibility.

docker build -t client-b-python:1.1 .
docker build -t client-b-python:1.1 .
curl http://localhost:8000/health

### Multi-Service Deployment Using Docker Swarm
After containerization, services were deployed using:
* Docker
* Docker Swarm


# Stack Deployment

* A stack.yml file was created to define:
* Services
* Replicas
* Overlay network
* Reverse proxy configuration
* Routing rules

docker stack deploy -c stack.yml multi-client-stack
docker service ls
docker service ps <service-name>

### Reverse Proxy Configuration (Traefik)
To route traffic to multiple services through a single entry point, a reverse proxy was implemented using:

* Traefik (v2.11)

# Why Traefik?
* Automatic service discovery
* Native Docker Swarm integration
* Host-based routing
* Built-in dashboard
* Lightweight and production-ready

# Traefik Configuration Highlights
* Docker provider enabled in Swarm mode
* Overlay network attached
* HTTP entrypoint configured on port 80
* Dashboard enabled on port 8080

Routing rules were defined using labels:

traefik.http.routers.client-a.rule=Host(`client-a.local`)
traefik.http.routers.client-b.rule=Host(`client-b.local`)

### Overlay Network Configuration
networks:
  multi-client-network:
    driver: overlay

# Benefits:
* Secure internal communication
* Service discovery via internal DNS
* Load-balanced traffic routing
* Isolation between services

### Host-Based Routing Validation
Requests were routed based on hostname headers.
Testing performed using:
curl -H "Host: client-a.local" http://<VM-IP>
curl -H "Host: client-b.local" http://<VM-IP>

### Traefik Dashboard Verification
Dashboard accessed via:
http://<VM-IP>:8080/dashboard/

# Dashboard confirmed:
All services detected
Routers configured correctly
Services healthy
Entry points active









