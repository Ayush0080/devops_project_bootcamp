## Docker Compose
![alt text](image.png)
![alt text](image-1.png)

---
- `NET_BIND_SERVICE` allows a non-root user (like your app) to bind to these low-numbered ports.

---
- `cap_drop: - all`
  - This removes ALL Linux capabilities from the container.
By default, containers get some privileges (like network control, file permissions, etc.).
Here, you're saying: “Start with zero privileges (very secure).”

---
- `cap_add: - NET_BIND_SERVICE`
  - After removing everything, you add back only one specific capability.
  - `NET_BIND_SERVICE`
     - Allows the container to bind to privileged ports (<1024)
        ```bash
        Example:
        Port 80 (HTTP)
        Port 443 (HTTPS)
        Port 22 (SSH)
        ``` 
  - Normally, only root can use these ports.
  - This capability allows a non-root process inside container to still use them.


---
- `interval` → how often to run check
- `retries` → failure threshold
- `start_period` → ignore failures during startup  

---
#### Compose Up / Down / Logs

```bash
# Create Directory
mkdir demo-compose
cd demo-compose

# Download the Docker Compose file
wget https://github.com/aws-containers/retail-store-sample-app/releases/download/v1.3.0/docker-compose.yaml

# Set environment variable
export DB_PASSWORD=

# Start all services
## Important Note:  if your file name is docker-compose.yaml dont need to specify -f with file
docker compose -f docker-compose.yaml up
docker compose up 

# OR start in detached mode (background)
docker compose -f docker-compose.yaml up -d
docker compose up -d

# Stop all services (gracefully) (NOT NEEDED NOW - JUST FOR REFERENCE)
docker compose down

```


![alt text](image-3.png)
![alt text](image-2.png)
![alt text](image-4.png)
![alt text](image-5.png)

---

#### Docker Compose Commands

```bash
# List Services 
docker compose ps

# Also verify Docker images it downloaed
docker images

# Stop a Service
docker compose stop orders

# Verify if service is stopped
docker compose ps
docker compose ps -a

# Start a Service
docker compose start orders

# Restart a Service
docker compose restart cart

# Verify if service restarted
docker compose ps

# Logs for all services
docker compose logs

# Logs for a specific service
docker compose logs ui

# Follow logs
docker compose logs -f ui

# Connect to a Container
docker compose exec ui sh

# Stats 
docker compose stats

# Specific Containers
docker compose stats ui

# Display the running process of all service containers
docker compose top

# Specific containers
docker compose top ui

```

![alt text](image-6.png)
![alt text](image-7.png)
![alt text](image-8.png)
![alt text](image-9.png)
![alt text](image-10.png)
![alt text](image-11.png)
![alt text](image-12.png)
![alt text](image-13.png)
![alt text](image-14.png)
![alt text](image-15.png)
![alt text](image-16.png)
![alt text](image-17.png)
![alt text](image-18.png)
![alt text](image-19.png)
---


#### Force recreate UI Container

- first check env variable 
![alt text](image-20.png)
- add colour env in to ui service 
![alt text](image-21.png)

- after the down and up the service chnages will be not reflect so we ude force recreate

```bash
# Stop All Services
docker compose up -d --force-recreate ui

[or]

# Stop All Services
docker compose down 

# Start All Services
docker compose up -d

```
![alt text](image-22.png)


- Verify UI Service Container after changes

![alt text](image-23.png)
![alt text](image-24.png)


---


## Docker Buildx
![alt text](image-25.png)

---
- check Buildx/BuildKit is available
```bash

export DOCKER_BUILDKIT=1
docker buildx version
```
![alt text](image-26.png)

---

- Install binfmt/QEMU emulators

  - `QEMU` is the actual translator. It is a hosted hypervisor that performs "binary translation." It takes instructions meant for one CPU (e.g., ARM) and converts them into instructions your actual CPU (e.g., Intel/AMD) can understand in real-time.
```bash
# Reinstall QEMU binfmt handlers
docker run --privileged --rm tonistiigi/binfmt --install all

# OR explicitly for arm64 + amd64
docker run --privileged --rm tonistiigi/binfmt --install arm64,amd64

```
![alt text](image-27.png)

---
- Create a containerized Buildx builder (multi-arch capable) using installed QEMU emulators

```bash
# Create a new multiarch builder that uses BuildKit in a container
docker buildx create --name multiarch --driver docker-container --use

# Bootstrap to detect all supported platforms
docker buildx inspect --bootstrap

# List Buildx Builders
docker buildx ls


```

![alt text](image-28.png)
---
- Docker Hub login & variables
```bash

export DOCKERHUB_USER="ayush0080"     
export DH_REPO="devops_project_bootcamp"            
export TAG="5.0.0"                                  

# ---- DERIVED ----
export IMAGE="${DOCKERHUB_USER}/${DH_REPO}:${TAG}"
echo $IMAGE

# Login to Docker Hub 
docker login -u "${DOCKERHUB_USER}"

```

![alt text](image-29.png)

---
- Use your Dockerfile (Retail Store UI)

```bash
# Create a Folder
mkdir demo-multiarch
cd demo-multiarch

# Download the Application Source
wget https://github.com/aws-containers/retail-store-sample-app/archive/refs/tags/v1.3.0.zip

# Unzip Application Source
unzip v1.3.0.zip

# Change Directory to UI Source folder
cd retail-store-sample-app-1.3.0/src/ui
```
![alt text](image-30.png)





---

- Build & push multi-platform image (AMD64 + ARM64)

```bash
DOCKER_BUILDKIT=1 docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t "${IMAGE}" \
  --push .
```
[Docker-Hub](https://hub.docker.com/repository/docker/ayush0080/devops_project_bootcamp/tags)
![alt text](image-31.png)
![alt text](image-35.png)


---

- Create ARM64 VM , Run and test the containers

    ![alt text](image-32.png)

    - first test images that created without buildx on arm64 vm
  ![alt text](image-33.png)
  ![alt text](image-34.png)

   - now using multi-platform image
     ![alt text](image-36.png)
     ![alt text](image-37.png)
     
