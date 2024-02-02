# DevOps task  in steps

#### Step 1: Create Dockerfile for flask app and create image and push it to dockerhub in private repo . 
#### Step 2: Create docker-compose.yml that contains thhree services flaskapp , MySQL  , phpmyadmin .
#### Step 3: Create other docker-compose.yml contains jwilder/nginx-proxy to expose flask-app and phpmyadmin with a self signed certificates to enable https connection to phpmyadmin and flaskapp.
#### Step 4: Deploy the flaskapp,MySQL and phpmyadmin to k8s minikube cluster and presist  MySQL data, Put Environment variables in Configmap and secret data in secrets, Acees applications from outside the minilube using the same domains and use self signed certificates as in docker-compose.
#### Step 5: Install your own gitlab server using docker-compose and push previous code(docker-compose files and k8s files) on gitlab, and configure a pipeline with gitlab-ci file to auto deploy the stack on the docker  and the kubernetes.
#### Step 6: Write down the whole k8s files (deployments,configmaps, secrets, services, ingreses, etc) to a helm chart for easy deployment and management of the stack.
#### Step 7: Auto deploy the stack via ArgoCD using our helm chart  previously taking into account to prevent any changes from the server side to be applied, only changes can be done from the helm chart that is pushed on the repository. 

## Step 1: Write Dockerfile for flaskapp and create image and push it to private repo in dockerhub.

- `this  Dockerfile used to build image  of Flask application and minimize size of image as much as possible` 

![1](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/8cfe651b-db7e-4518-9496-3c28c80c29fe)
- `size of image`
![2](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/68c9a453-d772-4df3-8110-0bd64a758593)
- `After building the image, Push it to the dockerhub registry in a private repo`
![3](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/b8a22c19-a5cd-4b6a-b8f3-7497c932ef40)

## Step 2: Create docker-compose.yml that contains the services python-app,MySQL and phpmyadmin.

![4](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/530bab01-e6f1-4531-a0fb-53f2b720d8a2)

## Step 3: Create other docker-compose.yml contains jwilder/nginx-proxy to expose python-app and phpmyadmin with a self signed certificates.

-`First, Create  self signed certificate: `

```bash
# Create a Self-Signed Root CA
openssl req -x509 -sha256 -days 1825 -newkey rsa:2048 -keyout rootCA.key -out rootCA.crt
```
- `Second, Create docker-compose file that contain jwilder/nginx-proxy `
![5](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/03e75b69-3698-41ea-832d-c2f993ec5924)

- `add domains to /etc/hosts`
- `flask app on` `flaskapp` `domain name`
- `phpmyadmin on` `phpmyadmin` `domain name`
![6](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/70923d36-b600-4f88-9e36-e988354741be)
 
- 'start container of jwilder/nginx-proxy`
![7](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/b494aa9d-da39-47b6-9851-ea19afb2dbf3)

- `Now we are able to access our apps on these domains through https connection`

![flask](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/1226a059-7c4b-4b78-bc42-860484caadd3)

![php](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/a98a4d2b-4c52-41db-ad0f-8ce4146d2ada)



## Step 4: Deploy the python-app,MySQL and phpmyadmin to k8s minikube cluster taking into account the persistence of MySQL data,put Environment variables in Configmap,acees applications from outside the minilube and use the same domains and use self signed certificates as in docker-compose.

## Prerequisites

- `Before we deploy our k8s files, We need to configure 2 things: `

- `First, As our flask image is in a private repo in dockerhub registry, We need to create a Pull image secret to enable flask-deployment.yml to pull the image from the private dockerhub registry`
- `We will do some steps: `

- `1-` `Create .docker-config.json file`
![dockerjson](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/aceb2a10-fd0f-4955-8be0-a7b8601d28f1)
- `Where auth attribute is` `base64 of dockerhub-username:dockerhub-password`

- `2-` `Now,We can create our pull image secret`
![pull-sec4](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/e97d6c62-4215-452c-8b54-359350402047)
- `Where .dockerconfigjson attribute is` `base64-encoded-contents-of-.docker/config.json file`

- `3-` `After creating the pull image secret,We must refer it into flask-deployment.yml`
![pull-sec5](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/4f3d790a-c7bf-4d9c-b87c-996d96549d59)
- `Now our flask deployment is able to pull the flask image from the private repo`

- `Second` `We need to add our minikube ip and our domain names to /etc/hosts to map these doamins to the minikube ingress controller to route them` 
![Dns1](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/ffc21420-11de-48e5-a845-1b7667d0a21c)
![Dns2](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/0d3516ad-59b7-442c-ba9c-baa43fcd8ad3)


## Deploy our applications on the minikube cluster

- `All k8s files are in` `k8s-task`

![1](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/4a18f4a4-2185-4702-888b-de275dc2c863)
![2](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/fc399360-84dc-40bb-bbb0-d704011e4f3d)
![3](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/5b9093e8-8dcd-4cc3-b56c-1d6066b73119)
![4](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/80fe69b8-f357-4672-a04a-e17a08169493)

## Acess our apps

- `Now, We can access our apps on the specific domains`

![f](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/32cdbd45-7947-49a2-a780-967df215e47c)


![p](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/5418c9e0-9924-4cbc-9d5f-9c845892ba70)




## Step 5: Install gitlab and push previous code(docker-compose files and k8s files) on gitlab, and configure a pipeline with gitlab-ci file to auto deploy the stack on the docker environment and the kubernetes environment

## Install gitlab locally with docker-compose

- `We installed gitlab with a docker-compose file to presist data,configration and logs`
![gl](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/0ba358f2-4b02-4573-a746-ecc90ef6e6dd)

- `Acess gitlab UI`
![ui](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/df200bd3-6684-498b-8cb4-40e4e1a75b76)

- `Assign pass to root user by command`
```bash
sudo docker exec -it gitlab gitlab-rake "gitlab:password:reset[root]"
```

## Deploy docker-compose files by gitlab (.gitlab-ci.yml file)

- `Before we push our docker-compose files we need to configure 3 things: `

- `First, Add docker login credentials in gitlab to enable docker-compose to pull the flask image from the private dockerhub registry `
![1](https://github.com/0xZe/FS/assets/81789671/c1d07316-141a-4663-812e-6b70dfe26e63)
- `Second, We need to configure and add a runner to our project to execute pipelines commans on it`
![2](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/6b2f9d6e-5553-42ae-b541-b1310b85c95b)
- `Our runner is active and running and ready to receive pipeline jobs`
![3](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/f5cf49a5-19de-4709-a88d-f44c2fb71d45)
- `Third, Configure .gitlab-ci.yml file and write the pipeline to deploy our  app in docker and k8s ` 
![jj](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/513b2ddc-81f1-4682-abba-2944211f2d42)


## Step 6: Write down the whole k8s files (deployments,configmaps, secrets, services, ingreses, etc) to a helm chart, in other meaning, create a helm chart for the stack.

- `Stack Helm chart files is in` `mychart`

## Step 7: Auto deploy the stack via ArgoCD using the helm chart that we wrote it down previously taking into account to prevent any changes from the server side to be applied, only changes can be done from the helm chart that is pushed on the repository. 

- `First, we need to install ArgoCD on our minikube cluster`
```bash
#Create a new namespace for ArgoCD:
kubectl create namespace argocd
```
```bash
#Apply the ArgoCD installation manifests:
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
```bash
#To forward traffic of this service in our  local machine to access ArgoCD from browser 
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
```bash
#Retrieve Default Login Credentials
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

- `After doing that ArgoCD become synchronized with Helm chart repo and changes in applications happens only from Helm chart repo`
![w1](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/fba0253a-8252-4626-bb39-b775a4f974f2)
![w2](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/b1567c53-2f54-4887-b762-c5995d8b43b6)


