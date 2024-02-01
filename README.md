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
- `create nginx config file to route traffic to our domains through our app be accessible through https`

![6](https://github.com/MhmdAbdo74/fixed-solutions-tasks-22/assets/94086189/b2975896-1ecc-44d6-a84d-40907ec27ff1)
 `
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
# Create a Self-Signed Root CA
sudo docker exec -it gitlab gitlab-rake "gitlab:password:reset[root]"
```

## Deploy docker-compose files by gitlab (.gitlab-ci.yml file)

- `Before we push our docker-compose files we need to configure 3 things: `

- `First, Add docker login credentials in gitlab to enable docker-compose to pull the flask image from the private dockerhub registry `
![1](https://github.com/0xZe/FS/assets/81789671/c1d07316-141a-4663-812e-6b70dfe26e63)
- `Second, We need to configure and add a runner to our project to execute pipelines commans on it`
![2](https://github.com/0xZe/FS/assets/81789671/12776d51-8648-41c4-9f76-95b50228af9c)
- `Our runner is active and running and ready to receive pipeline jobs`
![3](https://github.com/0xZe/FS/assets/81789671/7ab2cb8b-7d0b-4e33-b773-0c1cb34b1344)
- `Third, Configure .gitlab-ci.yml file and write the pipeline`
![jj](https://github.com/0xZe/FS/assets/81789671/4c7560ef-9721-4cc6-ba70-5d1576f4e7a5)

- `All docker-compose files,scripts and .gitlab-ci.yml file is on` `gitlab-compose`

- `Now,We are ready to deploy our docker-compose files`
- `As soon as the docker compose files and .gitlab-ci.yml file are pushed to the gitlab repo, The pipeline will start`
- `Pipeline ran successfully`
![4](https://github.com/0xZe/FS/assets/81789671/5c1e7326-c785-4fdf-82ec-5cd6805aea76)

- `Now, We can access our apps from Environmnent tab`
![5](https://github.com/0xZe/FS/assets/81789671/f6c53562-6e88-4a58-b013-d8489a311f2f)


## Deploy K8s files by gitlab (.gitlab-ci.yml file)

## Prerequisites

- `Before we deploy our k8s files, We need to configure some things: `

- `First, Create a dedicated service account with a dedicated permissions to use this service account to aceess minikube cluster and deploy k8s files`
![sa](https://github.com/0xZe/FS/assets/81789671/ad21bb7f-6c6b-46de-8062-8ffb73fb44ba)

- `Second,Put the token of the secret file in kubeconfig file to be able to access the minikube cluster`
- `To do that, We need first to create a secret token to the service account`
![sa-t](https://github.com/0xZe/FS/assets/81789671/4322854c-3703-4d0d-815b-bcbbceb9e7a1)

- `Then we need the token from this secret file and convert it to bas64`
![4](https://github.com/0xZe/FS/assets/81789671/88d6cfa8-2d98-4f89-9f3b-882f1c1a7d3b)

- `Encode the token to base64`
![5](https://github.com/0xZe/FS/assets/81789671/31333514-56cb-4ad1-8f28-906341d8b60a)

- `Finally, Add the encoded bas64 token to kubeconfig file`
![6](https://github.com/0xZe/FS/assets/81789671/efcaa08f-77d7-4ed5-af04-4b82d9b2d2e1)
- `Now we have a kubeconfig file and can use it to access the minikube cluster and deploy k8s files`

- `Add this kubeconfig file to gitlab to use it in our pipeline`
![7](https://github.com/0xZe/FS/assets/81789671/77c6d6b4-2c27-4785-83a6-8d60bb2a13ef)

- `gitlab service account files are in` `gitlab-serviceaccount`

- `We need also to configure and add a runner to our project to execute pipelines commans on it`
![8](https://github.com/0xZe/FS/assets/81789671/c58f2596-5e85-43a5-8270-c1e06cd7fe01)
- `Our runner is active and running and ready to receive pipeline jobs`
![9](https://github.com/0xZe/FS/assets/81789671/f256325c-2189-4233-a410-dd91e94780af)

- `All k8s files,scripts and .gitlab-ci.yml file is on` `gitlab-k8s`

- `Now,We are ready to deploy our k8s files`
- `As soon as the k8s files and .gitlab-ci.yml file are pushed to the gitlab repo, The pipeline will start`
- `Pipeline ran successfully`
![10](https://github.com/0xZe/FS/assets/81789671/69f60215-c4c4-4da9-b811-0357e8c57be9)

- `Now, We can access our apps from Environmnent tab`
![11](https://github.com/0xZe/FS/assets/81789671/6821b7b8-483e-453d-9ebd-61a7e09e5056)


## Step 6: Write down the whole k8s files (deployments,configmaps, secrets, services, ingreses, etc) to a helm chart, in other meaning, create a helm chart for the stack.

- `Stack Helm chart files is in` `stack-chart`

## Step 7: Auto deploy the stack via ArgoCD using the helm chart that we wrote it down previously taking into account to prevent any changes from the server side to be applied, only changes can be done from the helm chart that is pushed on the repository. 

- `First, we need to install ArgoCD on our minikube cluster`
![install argocd in minikube cluster](https://github.com/0xZe/FS/assets/81789671/e106b3c8-b23d-4534-9a59-52c31b9504b0)

- `Then, Froward ArgoCDd service to port 8080 to access ArgoCD UI`
![froward argocd to port 8080 to access ArgoCD UI](https://github.com/0xZe/FS/assets/81789671/42e77bc5-537b-4ee5-bd97-97a67cd90489)

- `Finally, Get ArgoCD password to access the UI`
![get password to access the ui](https://github.com/0xZe/FS/assets/81789671/03bee886-8620-42ae-b59c-f4df2106e4f6)
![access ui](https://github.com/0xZe/FS/assets/81789671/3a91032c-a231-46ae-b0b2-8d91e6ca2611)

- `After ArgoCD working, We can now apply ArgoCD-App.yml to configure and synchronize ArgoCD with Helm chart repo`
![apply argocd yml to configure argocd with helm cahrt repo](https://github.com/0xZe/FS/assets/81789671/40f2abdc-36f6-41b1-b21a-af96be7419b6)

- `ArgoCD-App.yml file is in` `ArgoCD`

- `After doing that ArgoCD become synchronized with Helm chart repo and changes in applications happens only from Helm chart repo`
![sync happened and application is healthy](https://github.com/0xZe/FS/assets/81789671/04d61607-692e-428d-9a27-f438afac9ae5)
![w1](https://github.com/0xZe/FS/assets/81789671/8c7d591b-1376-4822-994e-42be2e1731c3)
![w2](https://github.com/0xZe/FS/assets/81789671/eb68c9aa-f616-4315-a6fb-413b582c98d4)


## Step 2: Create docker-compose.yml that contains the services python-app,MySQL and phpmyadmin.

- `db.yml and flask-php.yml files are in` `docker-compose`
![4](https://github.com/0xZe/FS/assets/81789671/bdd26578-d2c5-47bc-8d8c-c4f6ddceb8c6)

## Step 3: Create other docker-compose.yml contains jwilder/nginx-proxy to expose python-app and phpmyadmin with a self signed certificates.

-`First, Create 2 self signed certificates: `

- `The first certificate is to flask-app with domain name called` `flask-app.local`
![flask-ssl](https://github.com/0xZe/FS/assets/81789671/51fab8e8-7c19-4198-ade2-163c5c049151)
- `The second certificate is to phpmyadmin with domain name called` `phpmyadmin.local`
![php-ssl](https://github.com/0xZe/FS/assets/81789671/63098cac-c2bb-40e5-a098-1312732f9396)
- `Certs are in` `docker-compose/nginx-proxy/certs`
- `But first we need to put these domains in our /etc/hosts file to map them to the proxy to route them`
![dns](https://github.com/0xZe/FS/assets/81789671/c40f642f-700c-48c8-a33a-8215ca820af1)

- `Second, Create proxy file with the created ssl to be able to access our apps: `

- `flask app on` `flask-app.local` `domain name`
- `phpmyadmin on` `phpmyadmin.local` `domain name`

- `proxy.yml is in` `docker-compose`
![6](https://github.com/0xZe/FS/assets/81789671/ecf710ec-9078-47b1-83b2-51f0e69db1d8)


- `Now we are able to access our apps on these domains`

![flask](https://github.com/0xZe/FS/assets/81789671/dcdde777-82b0-4c74-b20c-1dfc5d982fe4)
![flaskssl](https://github.com/0xZe/FS/assets/81789671/625312c7-6415-46e9-9e24-d0be0d2c111a)

![php](https://github.com/0xZe/FS/assets/81789671/f876c640-7b4a-4745-b5da-7d86444561d0)
![phpssl](https://github.com/0xZe/FS/assets/81789671/b577d078-ec81-41c0-be29-9c168ad6fb2c)


## Step 4: Deploy the python-app,MySQL and phpmyadmin to k8s minikube cluster taking into account the persistence of MySQL data,put Environment variables in Configmap,acees applications from outside the minilube and use the same domains and use self signed certificates as in docker-compose.

## Prerequisites

- `Before we deploy our k8s files, We need to configure 2 things: `

- `First, As our flask image is in a private repo in dockerhub registry, We need to create a Pull image secret to enable flask-deployment.yml to pull the image from the private dockerhub registry`
- `We will do some steps: `

- `1-` `Create .docker-config.json file`
![dockerjson](https://github.com/0xZe/FS/assets/81789671/ba9d4fd6-f24c-47ec-bab1-65fe8a082fe1)
- `Where auth attribute is` `base64 of dockerhub-username:dockerhub-password`

- `2-` `Now,We can create our pull image secret`
![pull-sec4](https://github.com/0xZe/FS/assets/81789671/0e2d5560-cd6d-4837-8d34-29a798912ff2)
- `Where .dockerconfigjson attribute is` `base64-encoded-contents-of-.docker/config.json file`

- `3-` `After creating the pull image secret,We must refer it into flask-deployment.yml`
![pull-sec5](https://github.com/0xZe/FS/assets/81789671/b85edec8-a245-43de-bcd9-98379a648db6)
- `Now our flask deployment is able to pull the flask image from the private repo`

- `Second` `We need to add our minikube ip and our domain names to /etc/hosts to map these doamins to the minikube ingress controller to route them` 
![Dns1](https://github.com/0xZe/FS/assets/81789671/09a2fc7a-2ece-42fc-9a04-8d7ad10f49a0)
![Dns2](https://github.com/0xZe/FS/assets/81789671/f7840a91-d59c-41a4-a169-bdf6c0807da2)


## Deploy our applications on the minikube cluster

- `All k8s files are in` `gitlab-k8s`

![1](https://github.com/0xZe/FS/assets/81789671/73ee7efb-c756-47e1-9e79-bc40de7a438b)
![2](https://github.com/0xZe/FS/assets/81789671/e8438b69-893b-40f3-826f-8e419fa82cd3)
![3](https://github.com/0xZe/FS/assets/81789671/b2437a9b-f816-428e-82e6-51943adc09bb)
![4](https://github.com/0xZe/FS/assets/81789671/be339eb5-2708-4114-826b-545393a8ec0b)
![5](https://github.com/0xZe/FS/assets/81789671/4358b038-1a0d-4494-90e2-eac02209cd8a)
![6](https://github.com/0xZe/FS/assets/81789671/51f26b2b-58e3-452b-9755-4cae1db12873)
![7](https://github.com/0xZe/FS/assets/81789671/c4f3d5d9-1928-4666-8737-f29d7377d0a2)


## Acess our apps

- `Now, We can access our apps on the specific domains`

![f](https://github.com/0xZe/FS/assets/81789671/7c9aa556-4e09-48d6-b27a-112185db829b)
![fssl](https://github.com/0xZe/FS/assets/81789671/f16176ff-0cbf-418f-a2d1-7f2b60e869d2)

![p](https://github.com/0xZe/FS/assets/81789671/22c9caf0-f6be-4f60-bcbb-5d9f44bd882b)
![pssl](https://github.com/0xZe/FS/assets/81789671/1c43e15d-4355-4bcb-bd2a-af55fcfaf919)



## Step 5: Install gitlab and push previous code(docker-compose files and k8s files) on gitlab, and configure a pipeline with gitlab-ci file to auto deploy the stack on the docker environment and the kubernetes environment

## Install gitlab locally with docker-compose

- `We installed gitlab with a docker-compose file to presist data,configration and logs`
![gl](https://github.com/0xZe/FS/assets/81789671/975160eb-146a-4cbe-870c-2ec2b1fdcea0)

- `Acess gitlab UI`
![ui](https://github.com/0xZe/FS/assets/81789671/00defd95-e6d3-4688-a168-56ec27f6fafb)

- `install-gitlab.yml is in` `install-gitlab`

## Deploy docker-compose files by gitlab (.gitlab-ci.yml file)

- `Before we push our docker-compose files we need to configure 3 things: `

- `First, Add docker login credentials in gitlab to enable docker-compose to pull the flask image from the private dockerhub registry `
![1](https://github.com/0xZe/FS/assets/81789671/c1d07316-141a-4663-812e-6b70dfe26e63)
- `Second, We need to configure and add a runner to our project to execute pipelines commans on it`
![2](https://github.com/0xZe/FS/assets/81789671/12776d51-8648-41c4-9f76-95b50228af9c)
- `Our runner is active and running and ready to receive pipeline jobs`
![3](https://github.com/0xZe/FS/assets/81789671/7ab2cb8b-7d0b-4e33-b773-0c1cb34b1344)
- `Third, Configure .gitlab-ci.yml file and write the pipeline`
![jj](https://github.com/0xZe/FS/assets/81789671/4c7560ef-9721-4cc6-ba70-5d1576f4e7a5)

- `All docker-compose files,scripts and .gitlab-ci.yml file is on` `gitlab-compose`

- `Now,We are ready to deploy our docker-compose files`
- `As soon as the docker compose files and .gitlab-ci.yml file are pushed to the gitlab repo, The pipeline will start`
- `Pipeline ran successfully`
![4](https://github.com/0xZe/FS/assets/81789671/5c1e7326-c785-4fdf-82ec-5cd6805aea76)

- `Now, We can access our apps from Environmnent tab`
![5](https://github.com/0xZe/FS/assets/81789671/f6c53562-6e88-4a58-b013-d8489a311f2f)


## Deploy K8s files by gitlab (.gitlab-ci.yml file)

## Prerequisites

- `Before we deploy our k8s files, We need to configure some things: `

- `First, Create a dedicated service account with a dedicated permissions to use this service account to aceess minikube cluster and deploy k8s files`
![sa](https://github.com/0xZe/FS/assets/81789671/ad21bb7f-6c6b-46de-8062-8ffb73fb44ba)

- `Second,Put the token of the secret file in kubeconfig file to be able to access the minikube cluster`
- `To do that, We need first to create a secret token to the service account`
![sa-t](https://github.com/0xZe/FS/assets/81789671/4322854c-3703-4d0d-815b-bcbbceb9e7a1)

- `Then we need the token from this secret file and convert it to bas64`
![4](https://github.com/0xZe/FS/assets/81789671/88d6cfa8-2d98-4f89-9f3b-882f1c1a7d3b)

- `Encode the token to base64`
![5](https://github.com/0xZe/FS/assets/81789671/31333514-56cb-4ad1-8f28-906341d8b60a)

- `Finally, Add the encoded bas64 token to kubeconfig file`
![6](https://github.com/0xZe/FS/assets/81789671/efcaa08f-77d7-4ed5-af04-4b82d9b2d2e1)
- `Now we have a kubeconfig file and can use it to access the minikube cluster and deploy k8s files`

- `Add this kubeconfig file to gitlab to use it in our pipeline`
![7](https://github.com/0xZe/FS/assets/81789671/77c6d6b4-2c27-4785-83a6-8d60bb2a13ef)

- `gitlab service account files are in` `gitlab-serviceaccount`

- `We need also to configure and add a runner to our project to execute pipelines commans on it`
![8](https://github.com/0xZe/FS/assets/81789671/c58f2596-5e85-43a5-8270-c1e06cd7fe01)
- `Our runner is active and running and ready to receive pipeline jobs`
![9](https://github.com/0xZe/FS/assets/81789671/f256325c-2189-4233-a410-dd91e94780af)

- `All k8s files,scripts and .gitlab-ci.yml file is on` `gitlab-k8s`

- `Now,We are ready to deploy our k8s files`
- `As soon as the k8s files and .gitlab-ci.yml file are pushed to the gitlab repo, The pipeline will start`
- `Pipeline ran successfully`
![10](https://github.com/0xZe/FS/assets/81789671/69f60215-c4c4-4da9-b811-0357e8c57be9)

- `Now, We can access our apps from Environmnent tab`
![11](https://github.com/0xZe/FS/assets/81789671/6821b7b8-483e-453d-9ebd-61a7e09e5056)


## Step 6: Write down the whole k8s files (deployments,configmaps, secrets, services, ingreses, etc) to a helm chart, in other meaning, create a helm chart for the stack.

- `Stack Helm chart files is in` `stack-chart`

## Step 7: Auto deploy the stack via ArgoCD using the helm chart that we wrote it down previously taking into account to prevent any changes from the server side to be applied, only changes can be done from the helm chart that is pushed on the repository. 

- `First, we need to install ArgoCD on our minikube cluster`
![install argocd in minikube cluster](https://github.com/0xZe/FS/assets/81789671/e106b3c8-b23d-4534-9a59-52c31b9504b0)

- `Then, Froward ArgoCDd service to port 8080 to access ArgoCD UI`
![froward argocd to port 8080 to access ArgoCD UI](https://github.com/0xZe/FS/assets/81789671/42e77bc5-537b-4ee5-bd97-97a67cd90489)

- `Finally, Get ArgoCD password to access the UI`
![get password to access the ui](https://github.com/0xZe/FS/assets/81789671/03bee886-8620-42ae-b59c-f4df2106e4f6)
![access ui](https://github.com/0xZe/FS/assets/81789671/3a91032c-a231-46ae-b0b2-8d91e6ca2611)

- `After ArgoCD working, We can now apply ArgoCD-App.yml to configure and synchronize ArgoCD with Helm chart repo`
![apply argocd yml to configure argocd with helm cahrt repo](https://github.com/0xZe/FS/assets/81789671/40f2abdc-36f6-41b1-b21a-af96be7419b6)

- `ArgoCD-App.yml file is in` `ArgoCD`

- `After doing that ArgoCD become synchronized with Helm chart repo and changes in applications happens only from Helm chart repo`
![sync happened and application is healthy](https://github.com/0xZe/FS/assets/81789671/04d61607-692e-428d-9a27-f438afac9ae5)
![w1](https://github.com/0xZe/FS/assets/81789671/8c7d591b-1376-4822-994e-42be2e1731c3)
![w2](https://github.com/0xZe/FS/assets/81789671/eb68c9aa-f616-4315-a6fb-413b582c98d4)
