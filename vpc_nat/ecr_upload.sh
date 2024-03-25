# Retrieve authentication token for Amazon ECR and authenticate your Docker client to your registry.
aws ecr git-login-password --region us-west-2 --profile tf-dev \
| docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-west-2.amazonaws.com

docker build -t my_app_repo .

docker tag my_app_repo:latest 123456789012.dkr.ecr.us-west-2.amazonaws.com/my_app_repo:latest

docker push 123456789012.dkr.ecr.us-west-2.amazonaws.com/my_app_repo:latest
