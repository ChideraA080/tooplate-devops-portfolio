# Tooplate Site Deployment - DevOps Portfolio Project

Static website CI/CD deployment with Docker, Terraform, and AWS EC2.
![Project Screenshot](./screenshots/homepage.png)

## Overview

This project demonstrates a full DevOps workflow for deploying a static website downloaded from [Tooplate](https://www.tooplate.com/), using modern cloud and containerization technologies. The workflow includes:

- Downloading and preparing a static website template
- Provisioning infrastructure on AWS EC2 using Terraform
- Containerizing the website using Docker
- Automating the build, push, and deployment process via GitHub Actions CI/CD
- Deploying and managing the Docker container on an EC2 instance
- Handling environment secrets securely without exposing sensitive data

This project is part of my DevOps portfolio, showcasing hands-on experience with cloud infrastructure, automation, and containerization.


## Features

- Automated Docker image build and push to DockerHub
- CI/CD pipeline that deploys directly to AWS EC2
- Infrastructure as Code using Terraform
- Secure handling of secrets (DockerHub credentials, EC2 key)
- Automatic container replacement for updates
- Port management to avoid conflicts on EC2

## Technologies Used

| Category               | Tool/Technology                |
|------------------------|--------------------------------|
| Cloud                  | AWS EC2                        |
| Infrastructure as Code | Terraform                      |
| Containerization       | Docker                         |
| CI/CD                  | GitHub Actions                 |
| Version Control        | Git & GitHub                   |
| Website Template       | Tooplate Template (tooplate_site) |


## Project Structure
project-root/
│

├── site/ # Tooplate website files

├── Dockerfile

├── terraform/

│ ├── main.tf

│ ├── variables.tf

│

├── .github/

│ └── workflows/

│ └── deploy.yml

│

└── screenshots/

## Project Setup & Steps

### 1. Clone the Repository

git clone https://github.com/
<your-username>/<repo-name>.git
cd <repo-name>

## Step 1: Download and Prepare Tooplate Template

1. Go to https://www.tooplate.com/
2. Download any free HTML template (ZIP file)

### 2. Prepare Website Files

1. Create a folder `site` in your project root:

mkdir site


2. Download your Tooplate template and copy the content into the `site` folder.

> Screenshot idea: Show `site` folder with Tooplate files inside.


4. Unzip the downloaded template:

unzip tooplate-xxx.zip


5. Copy the extracted files into the `site` directory:

cp -r tooplate-xxx/* site/


OR (if already extracted manually):

cp -r <downloaded-folder>/* site/

6. Confirm files are inside:

ls site

You should see:

- index.html

- css/

- js/

- images/


### 3. Create Dockerfile

Create a `Dockerfile` in the project root:

Dockerfile for Tooplate site

FROM nginx:alpine

RUN  rm -rf  /usr/share/nginx/html/ *

COPY site/site  /usr/share/nginx/html/

EXPOSE 80

RUN echo "OK" >  /usr/share/nginx/html/health.txt

CMD ["nginx", "-g", "daemon off;"]

### 2. Terraform Infrastructure

Terraform is used to provision the EC2 instance and security group.

1. Set your AWS credentials:

export AWS_ACCESS_KEY_ID=<your-access-key>

export AWS_SECRET_ACCESS_KEY=<your-secret-key>

2. Update the key pair variable in `terraform/variables.tf`:

variable "key_name" {

description = "AWS key pair for EC2"

type = string

}

3. Initialize Terraform:

cd terraform
terraform init


4. Apply Terraform configuration:
terraform apply --auto-approve

> Screenshot idea: Capture `terraform apply` output with instance IP.

### 3. Dockerize Tooplate Site

1. Download your Tooplate template and place it in the project root.

2. Build the Docker image locally:

docker build -t <your-dockerhub-username>/tooplate_site:v1.0 .
  
3. Test the container:
docker run -d -p 8081:80 --name tooplate_site <your-dockerhub-username>/tooplate_site:v1.0


4. Open your browser and navigate to `http://localhost:8081` to verify.

> Screenshot idea: Show website running locally in browser.


### 4. Push Docker Image to DockerHub

docker login -u <your-dockerhub-username>

Use Personal Access Token (PAT) as password if prompted

docker push <your-dockerhub-username>/tooplate_site:v1.0

Use Personal Access Token (PAT) as password if prompted


> Screenshot idea: Show DockerHub repository with the pushed image.

---

### 5. CI/CD Pipeline via GitHub Actions

Create file:

.github/workflows/deploy.yml

The `.github/workflows/deploy.yml` workflow:

- Checks out the repository
- Builds the Docker image
- Pushes it to DockerHub
- SSHs into EC2, stops any existing container, and deploys the latest container

#### Key Steps:

1. Add your **secrets** to GitHub repository:

## Step 7: GitHub Secrets Configuration

Go to:

Settings → Secrets → Actions

Add:

- `DOCKER_USERNAME`
- `DOCKER_PASSWORD` (PAT)
- `EC2_HOST` (public IP)
- `EC2_KEY` (private key content)

2. Push changes to `main` branch to trigger CI/CD.

> Screenshot idea: Show GitHub Actions build logs successful run.

---

### 6. EC2 Deployment & Testing

Connect to EC2:

ssh -i <your-key.pem> ubuntu@<EC2_PUBLIC_IP>

- Install docker:
  sudo install docker.io -y

- Start docker:
  sudo systemctl start docker
  
- Enable docker:
  sudo systemctl enable docker
  
- Pull docker image:
  sudo docker pull <your-dockerhub-username>/tooplate_site:v1.0
   
- Run docker container:
  sudo docker run -d -p 8081:80 --name tooplate_site <your-dockerhub-username>/tooplate_site:v1.0

- Verify Docker container:
  sudo docker ps

  
Open browser and navigate to:
http://<EC2_PUBLIC_IP>:Port 


> Screenshot idea: Live site on EC2 with browser screenshot.

---

## Challenges Faced & Solutions

| Challenge | Solution |
|-----------|---------|
| Docker build failed with tag errors | Ensured image tag matched DockerHub naming conventions and removed invalid characters (`-` vs `_`) |
| Port conflicts on EC2 (`Bind for 0.0.0.0:80 failed`) | Stopped existing containers using port 80 (`docker stop` & `docker rm`) before deploying new container |
| Sensitive keys exposed | Stored all secrets in GitHub repository secrets and used environment variables in workflows |
| SSH access errors from GitHub Actions | Used `chmod 600` for key and `StrictHostKeyChecking=no` for non-interactive SSH |

---

## Lessons Learned

- Understanding Docker image tagging and naming conventions
- Automating deployment with GitHub Actions
- Managing AWS EC2 networking and ports
- Best practices for storing secrets securely
- Applying Terraform for Infrastructure as Code

---

## Screenshots / Proof of Work

1. Terraform EC2 provisioning:

`./screenshots/terraform_apply.png`

2. Docker image build & push:

`./screenshots/docker_build.png`

3. GitHub Actions CI/CD workflow success:

`./screenshots/github_actions.png`

4. Live website running on EC2:

`./screenshots/ec2_site.png`

---

## How to Replicate

1. Clone the repository
2. Set AWS credentials and key pair
3. Create `site` folder
4. Copy Tooplate template into `site`
5. Create Dockerfile
6. Build Docker image
7. Push to DockerHub
8. Provision EC2 using Terraform
9. Add GitHub Secrets
10. Add GitHub Actions workflow
11. Push to `main` to trigger CI/CD
12. Access website via EC2 public IP


## Conclusion

This project demonstrates a full DevOps lifecycle from infrastructure provisioning, containerization, to CI/CD deployment. It highlights problem-solving, automation, and best practices for deploying production-ready applications securely.


**Author:** Chidera Alaeto  
**Portfolio:** [GitHub](https://github.com/chideraalaeto)  
**Contact:** chideraalaeto92@gmail.com






