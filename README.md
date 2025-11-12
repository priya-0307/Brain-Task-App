# Brain-Tasks-App — Production Deployment


## Project Overview

This project demonstrates deploying a React application to production using Docker, AWS ECR, and Kubernetes (EKS). It also sets up CI/CD using AWS CodeBuild, CodeDeploy, and CodePipeline.

* Application runs on **port 3000**
* Uses **Docker** for containerization
* Deploys on **AWS EKS** with a **LoadBalancer service**
* Monitored using **CloudWatch Logs**

---

## Prerequisites

* AWS CLI configured
* kubectl installed
* Docker installed
* Git installed
* Access to AWS EKS cluster


---

## Docker 

-->Build and run locally:


docker build -t brain-tasks-app .

docker run -p 3000:80 brain-tasks-app

---

## ECR Setup


aws ecr create-repository --repository-name devops-build-prod --region ap-south-1
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

-->Build, tag, and push Docker image:


IMAGE_TAG=$(git rev-parse --short HEAD)
IMAGE_URI=<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/devops-build-prod:$IMAGE_TAG
docker build -t $IMAGE_URI .
docker push $IMAGE_URI


---

## Kubernetes Deployment


kubectl apply -f deployment.yaml

kubectl apply -f service.yaml

---

## CI/CD Pipeline

### CodeBuild `buildspec.yml`

* Builds Docker image
* Pushes to ECR
* Writes image URI for deploy stage

### CodeDeploy `appspec.yml` & Deploy Script

* `appspec.yml` triggers `scripts/deploy_to_eks.sh`
* Script updates kubeconfig and applies Kubernetes manifests

### CodePipeline Overview

* Source: GitHub repository
* Build: CodeBuild project
* Deploy: CodeDeploy or a second CodeBuild action running the deploy script

---

## Monitoring

* CodeBuild logs: CloudWatch Logs

---

## Useful Commands

* Update kubeconfig:


aws eks update-kubeconfig --region <region> --name <cluster-name>


* Get LoadBalancer hostname:


kubectl get svc brain-tasks-lb -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'


* Check logs of a container:

docker logs <container_id>

* Start exited container:

docker start -a <container_id>



