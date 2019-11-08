# Prisma Public Cloud Demo with Google GCP integration

The idea of this repository is to show a full integration with Prisma Public Cloud and Google Cloud.

It is using the following components:
- _Google Cloud Source Repositories_
- _Google Cloud Build_
- _Google KMS_
- _Google Container Registry_
- _Google Kubernetes Cluster GKE_
- Prisma Public Cloud (compute) and Prisma Public Cloud IAC Scan

It is based on the following example tutorial [GitOps-style Continuous Delivery with Cloud Build](https://cloud.google.com/kubernetes-engine/docs/tutorials/gitops-cloud-build).

It is mainly using two repositories:
1. app repository: To manage the application itself (folder hello-cloudbuild-app)
2. env repository: contains the manifests for the Kubernetes Deployment and to manage the deployment of the application via Cloud Build (folder hello-cloudbuild-env)

The main integration with Twistlock twistcli scan and Prisma Public Cloud IAC is done with the cloudbuild.yaml files for each.

If you do the setup correct as described inside the tutorial the Google Cloud Build CI and CD pipelines are automatically triggered via the Triggers.

For the demo in used the following flow:

## Preparation

1. First you need to do the application setup as described inside the tutorial [GitOps-style Continuous Delivery with Cloud Build](https://cloud.google.com/kubernetes-engine/docs/tutorials/gitops-cloud-build) including the GKE Cluster.
* For the app repository please use the following Git Repsitory: [hello-cloudbuild-app](https://github.com/automatecloud/hello-cloudbuild-app)
* For the env repository please use the following Git Repository: [hello-cloudbuild-env](https://github.com/automatecloud/hello-cloudbuild-env)
2. Make sure that all the necessary APIs are configured for the project.
* *Google Cloud Container API*: `gcloud services enable container.googleapis.com`
* *Google Cloud Build API*: `gcloud services enable cloudbuild.googleapis.com`
* *Google Cloud Source Code Repository API*: `gcloud services enable sourcerepo.googleapis.com`
* *Google Cloud Container Analysis API*: `gcloud services enable containeranalysis.googleapis.com`
* *Google Cloud KMS API*: `gcloud services enable cloudkms.googleapis.com`
2. You need to bulid a twistcli image that will be used to trigger the twistcli scan and is saved within your _Google Cloud Registry_ of the Project.
* Change to the folder [Dockerfiles/twistcli](https://github.com/automatecloud/google-summit/tree/master/Dockerfiles/twistcli)
* Execute a Google Cloud Build: `gcloud builds submit --tag gcr.io/[YOUR PROJECT_NAME]/cloud-build-twistcli` .
* Check _Google Cloud Build_ History if the Job was executed without any errors.
* Check the _Google Container Registry_ if the new image cloud-build-twistcli with tag latest was pushed.
3. You need to create a CI User with name cloud-build inside your Twistlock Console that has the role CI User.
4. Steps for _Google KMS System_
* Create a new keyring with name cloud-build: `gcloud kms keyrings create cloud-build --location=global`
* Create a new key for the Twistlock cloud-build ci user password: `gcloud kms keys create password --location=global --keyring=cloud-build --purpose=encryption`
* Create a new key for the Twislock Console URL: `gcloud kms keys create console --location=global --keyring=cloud-build --purpose=encryption`
* Encrypt the Twistlock Console Password: `echo -n "YOURPASSWORD" | gcloud kms encrypt --plaintext-file=- --ciphertext-file=- --location=global --keyring=cloud-build --key=password | base64`
* Encrypt the Twistlock Console URL: `echo -n "https://yourconsole:8083" | gcloud kms encrypt --plaintext-file=- --ciphertext-file=- --location=global --keyring=cloud-build --key=console | base64`
* The Cloud Build service account must have access to the Google KMS System as Described here [Grant the Cloud Build service account access to the CryptoKey](https://cloud.google.com/cloud-build/docs/securing-builds/use-encrypted-secrets-credentials)
5. changes in cloudbuild.yml?




1. Make sure you got the application itself cloned locally (Repository hello-cloudbuild-app [hello-cloudbuild-app](https://github.com/automatecloud/hello-cloudbuild-app))
2. Make sure you got the application setup as described inside the tutorial [GitOps-style Continuous Delivery with Cloud Build](https://cloud.google.com/kubernetes-engine/docs/tutorials/gitops-cloud-build) including the GKE Cluster
3. Make sure you added the Twistlock Password inside Google KMS.
4. Make sure you downloaded the right config for kubectl.
5. Make sure you are using the right cloudbuild.yml files in both repositories.
6. Make sure Twistlock is installed in the GKE environment.
7. Open a Browser with the following opened so you can show it during the demo:
  - Google Cloud Source Repositories with your two repos.
  - Google Cloud Build.
  - Google KMS.
  - Google Registry.
  - Google Kubernetes Cluster GKE
  - Prisma Public Cloud compute (Twistlock)
  - Description of the Prisma Public Cloud IAC Scan #
8. Open a terminal (I'm using iterm on my local Mac Os)

Flow:
1. Change the application locally:

update the app.py and the test_app.py with the right output.

2. Build the application locally on your machine:

docker build -t hello-cloudbuild-app:test .

3. Test the application locally:

docker run -d -p 8080:8080 hello-cloudbuild-app:test
Show the app running with your local Docker Engine:
docker ps
Show the app running locally in your browser (Zoom In the View of the application, so everyone can see it)

4. Show the local image and image id:

docker images

5. Do a local twistcli scan (make sure it is installed on your MacOs)

twistcli images  scan --address https://yourconsole --project google (if you use projects) --details --user andreas 45d6da1b962b (image id)

6. Show the scan results in the Prisma Public Cloud Compute GUI.

7. Show the Kubernetes Cluster (GKE Cluster)

- In browser
- Via kubectl (make sure you downloaded the right kubeconfig file before)

8. Adding the changes to the git repos:

git add app.py
git add test_app.py
git commit -m "Now the next city"
git push google master

9. Show the flow of the Cloud Build:

- Integration with twistcli and thresholds for vulnerabilites and compliance
- How the CI Pipeline is triggering the CD pipline
- Integration with IAC Scan https://iacscanapidoc.redlock.io/

10. If finished show the deployed app

- via kubectl get all -n default
- via the browser and call the public ip of the application load balancer shown.

Demo Video available here https://www.youtube.com/watch?v=fvDfKcsEUx0&feature=youtu.be
