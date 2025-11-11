#!/bin/bash
set -e


# input args (if passed from pipeline) or environment
CLUSTER_NAME=${EKS_CLUSTER_NAME:-my-eks-cluster}
REGION=${AWS_REGION:-ap-south-1}
NAMESPACE=${K8S_NAMESPACE:-default}
IMAGE_URI=${700664161347.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest}


# Update kubeconfig
aws eks update-kubeconfig --region ${REGION} --name ${CLUSTER_NAME}




# Replace image placeholder in deployment and apply
sed -i "s|<ECR_IMAGE_PLACEHOLDER>|${IMAGE_URI}|g" deployment.yaml
kubectl apply -f deployment.yaml -n ${NAMESPACE}
kubectl apply -f service.yaml -n ${NAMESPACE}

# Update kubernetes Deployment image 
kubectl --kubeconfig "$KUBECONFIG" -n brain-tasks-app set image deployment/brain-tasks-deployment brain-tasks-container=$IMAGE_URI --record



