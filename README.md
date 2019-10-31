# Prisma Public Cloud Demo with Google GCP integration

The idea of this repository is to show a full integration with Prisma Public Cloud and Google Cloud.

It is using the following components:
- Google Cloud Source Repositories
- Google Cloud Build
- Google KMS
- Google Registry
- Google Kubernetes Cluster GKE
- Prisma Public Cloud (compute) and Prisma Public Cloud IAC Scan

It is based on the following example tutorial [GitOps-style Continuous Delivery with Cloud Build](https://cloud.google.com/kubernetes-engine/docs/tutorials/gitops-cloud-build).

It is mainly using two repositories:
1. To manage the application itself (folder hello-cloudbuild-app)
2. To manage the deployment of the application via Cloud Build (folder cloud-summit-env)

The main integration with Twistlock twistcli scan and Prisma Public Cloud IAC is done with the cloudbuild.yaml files for each.

If you do the setup correct as described inside the tutorial the Google Cloud Build CI and CD pipelines are automatically triggered via the Triggers.

For the demo in used the following flow:

Preparation
1. Make sure you got the application itself cloned locally (folder hello-cloudbuild-app)
2. Make sure you got the application setup as described inside the tutorial including the GKE Cluster
3. Make sure you added the Twistlock Password inside Google KMS.
4. Make sure you downloaded the right config for kubectl.
5. Make sure you are using the right cloudbuild.yml files in both repositories.
6. Open a Browser with the following opened so you can show it during the demo:
  - Google Cloud Source Repositories with your two repos.
  - Google Cloud Build.
  - Google KMS.
  - Google Registry.
  - Google Kubernetes Cluster GKE
  - Prisma Public Cloud compute (Twistlock)
  - Description of the Prisma Public Cloud IAC Scan #
7. Open a terminal (I'm using iterm on my local Mac Os)

Flow:
1. Change the application locally:

update the app.py and the test_app.py with the right output.

2. Build the application locally on your machine:

docker build -t googlesummit:test .

3. Test the application locally:

docker run -d -p 8080:8080 googlesummit:test
Show the app running locally in your browser

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
