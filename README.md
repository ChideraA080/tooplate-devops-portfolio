# Tooplate Site Deployment - DevOps Portfolio Project

Static website CI/CD deployment with Docker, Terraform, and AWS EC2.

 Project _workflow
![ Screenshot of Project Workflow](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/DevOps%20workflow%20for%20Tooplate%20deployment.png)

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

###  Clone the Repository

git clone https://github.com/
<your-username>/<repo-name>.git
cd <repo-name>

### Step 1: Download and Prepare Tooplate Template

1. Go to https://www.tooplate.com/
2. Download any free HTML template (ZIP file)

### Step 2. Prepare Website Files

1. Create a folder `site` in your project root:

mkdir site

2. Download your Tooplate template and copy the content into the `site` folder.

3. Unzip the downloaded template:

unzip tooplate-xxx.zip


4. Copy the extracted files into the `site` directory:

cp -r tooplate-xxx/* site/


OR (if already extracted manually):

cp -r <downloaded-folder>/* site/

5. Confirm files are inside:

ls site

You should see:

- index.html

- css/

- js/

- images/


### Step 3. Create Dockerfile

Create a `Dockerfile` in the project root:

Dockerfile for Tooplate site

FROM nginx:alpine

RUN  rm -rf  /usr/share/nginx/html/ *

COPY site/site  /usr/share/nginx/html/

EXPOSE 80

RUN echo "OK" >  /usr/share/nginx/html/health.txt

CMD ["nginx", "-g", "daemon off;"]

### Step 4. Terraform Infrastructure

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

 Terraform _apply output with instance IP
![ Screenshot of Terraform_apply](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1000724760.jpg)

### Step 5. Dockerize Tooplate Site

1. Download your Tooplate template and place it in the project root.

2. Build the Docker image locally:

docker build -t <your-dockerhub-username>/tooplate_site:v1.0 .
  
3. Test the container:
docker run -d -p 8081:80 --name tooplate_site <your-dockerhub-username>/tooplate_site:v1.0

4. Open your browser and navigate to `http://localhost:8081` to verify.

 Website Running locally in browser
![ Screenshot of website running locally](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1000724765.jpg)

### Step 6. Push Docker Image to DockerHub

docker login -u <your-dockerhub-username>

Use Personal Access Token (PAT) as password if prompted

docker push <your-dockerhub-username>/tooplate_site:v1.0

Use Personal Access Token (PAT) as password if prompted

 Docker Image Push to Dockerhub
![ Screenshot of Image in Dockerhub](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1000724783.jpg)


### Step 7. CI/CD Pipeline via GitHub Actions

Create file:

.github/workflows/deploy.yml

The `.github/workflows/deploy.yml` workflow:

- Checks out the repository
- Builds the Docker image
- Pushes it to DockerHub
- SSHs into EC2, stops any existing container, and deploys the latest container

#### Key Steps:

1. Add your **secrets** to GitHub repository:

  GitHub Secrets Configuration

Go to:

Settings → Secrets → Actions

Add:

- `DOCKER_USERNAME`
- `DOCKER_PASSWORD` (PAT)
- `EC2_HOST` (public IP)
- `EC2_KEY` (private key content)

2. Push changes to `main` branch to trigger CI/CD.

![CI/CD Workflow Success](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1000724647.jpg)

### Step 8. EC2 Deployment & Testing

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

- Add Port 8081 in EC2 Security Inbound rule
 
Open browser and navigate to:
http://<EC2_PUBLIC_IP>:Port 

 Website Running Live on EC2 via browser
![ Screenshot of website live on EC2](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1000724764.jpg)

## Challenges Faced & Solutions

| Challenge | Solution |
|-----------|---------|
| Docker build failed with tag errors | Ensured image tag matched DockerHub naming conventions and removed invalid characters (`-` vs `_`) |
| Port conflicts on EC2 (`Bind for 0.0.0.0:80 failed`) | Stopped existing containers using port 80 (`docker stop` & `docker rm`) before deploying new container |
| Sensitive keys exposed | Stored all secrets in GitHub repository secrets and used environment variables in workflows |
| SSH access errors from GitHub Actions | Used `chmod 600` for key and `StrictHostKeyChecking=no` for non-interactive SSH |
| Template not loading | Fixed by correctly copying files into `site/` |
| Wrong file structure | Ensured `index.html` is at root of `site/` |

## Lessons Learned

- Learned proper file structuring for static website deployments
- Understood how Nginx serves static content in Docker containers
- Gained hands-on experience with Docker image building, tagging, and deployment
- Implemented CI/CD automation using GitHub Actions
- Managed AWS EC2 networking, security groups, and port configurations
- Applied best practices for handling secrets securely
- Used Terraform for Infrastructure as Code and resource provisioning
- Practiced cost optimization by destroying unused resources
- Improved troubleshooting skills (SSH errors, port conflicts, Docker issues)

## Cost Optimization & Resource Management (Best Practice)

One key DevOps practice I implemented in this project is **cost control and resource cleanup on AWS**.

After testing and validating the deployment, I used Terraform to destroy provisioned infrastructure:

## Terraform destroy

#### Why this is important:

- Prevents unnecessary AWS charges from running EC2 instances
- Ensures infrastructure is only active when needed (on-demand usage)
- Demonstrates responsible cloud resource management
- Aligns with real-world DevOps practices in production environments

#### What I learned from this:

- Cloud resources are billed per usage, so leaving them running increases cost
- Infrastructure as Code (Terraform) makes it easy to both **provision and tear down** environments
- Clean-up is as important as deployment in a DevOps lifecycle
- Practicing this habit is critical for working in real production systems


## Best Practices Applied

- No hardcoding of sensitive credentials (used GitHub Secrets)
- Used Infrastructure as Code (Terraform) for reproducibility
- Implemented CI/CD for automated deployment
- Ensured proper container lifecycle management (stop/remove before redeploy)
- Practiced cost optimization using `terraform destroy`

## Screenshots / Proof of Work

1. Health Status Confirmation 
![ Screenshot Of terraform_destroy on EC2](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1774452268671.jpg)

1.Terraform _apply
![ Screenshot of Terraform_apply](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1000724760.jpg)

2. Terraform EC2 provisioning:
![ Screenshot of Instance running](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1000724771.jpg)

3. Docker image build & push:
![ Screenshot of docker_build](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1000724782.jpg)

4. Docker Image Push to Dockerhub
![ Screenshot of Image in Dockerhub](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1000724783.jpg)

5. GitHub Actions CI/CD workflow success:

![CI/CD Workflow Success](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1000724647.jpg)


6. Live website running on EC2:
![ Screenshot Of EC2_site](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1000724764.jpg)

7. Terraform Destroy
![ Screenshot Of terraform destroy](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1774452359318.jpg)

8. Terraform Destroy Confirmaion on Ec2
![ Screenshot Of terraform_destroy on EC2](https://github.com/ChideraA080/tooplate-devops-portfolio/blob/main/Tooplate_site%20Project/1774452469999.jpg)


## How to Replicate

1. Clone the repository
2. Set AWS credentials and key pair
3. Download template from Tooplate
4. Create `site` folder
5. Unzip Tooplate template
6. Copy Tooplate template into `site`
7. Create Dockerfile
8. Build Docker image
9. Push to DockerHub
10. Provision EC2 using Terraform
11. Add GitHub Secrets
12. Add GitHub Actions workflow
13. Push to `main` to trigger CI/CD
14. Access website via EC2 public IP


## Conclusion

This project demonstrates my ability to execute a complete DevOps workflow - provisioning infrastructure with Terraform, containerizing applications with Docker, and automating deployments using GitHub Actions on AWS EC2.

It reflects strong hands-on experience in building scalable, secure, and cost-efficient systems, while applying best practices in automation, cloud infrastructure, and real-world troubleshooting.

**Author:** Chidera Pamela Alaeto  
**Portfolio:** [GitHub](https://github.com/ChideraA080/tooplate-devops-portfolio)  
**Contact:** chideraalaeto92@gmail.com






