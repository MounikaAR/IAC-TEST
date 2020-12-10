# Deploying the Application 
The application infrastructure includes the following:
* Application Kubernetes Cluster 
* S3 buckets
* RDS Instances
* and other resources

## Jenkins stage definition
Each stage will have its own directory to define the docker images
```
stages
  create-app-k8-cluster
  create-app-rsrcs
```
---
## Background Information
>https://wiki.tpp.tsysecom.com/pages/viewpage.action?pageId=193452844
### K8s Cluster Naming Convention
```
 <app>-<env>-<region>[-<type>].<zone>.tsys.aws
```
<table><tr><td><td>
<b>app</b>: application name or function of cluster, example kafka/web/tsys/loyalty etc.<br>
<b>env</b>: environments include qa/dev/uat and prod.<br>
<b>region</b>: aws regions (us/eu/asia)<br>
<b>type</b>: this is optional to identify windows or linux based cluster (w-windows and u-Linux)<br>
<b>zone</b>: DNS zone (tools/dev/devdl/devqa/prime)<br>
<b>Domain</b>: private zone (tsys.aws)<br>
</td></td></tr></table><br>

---

### S3 Bucket Naming Convention
<b>Application Bucket Names</b>
```
<prefix>-<department>-<env>-<region>-<awsaccountname>
```
<table><tr><td><td>
<b>prefix</b>: application prefix (landing/staging)<br>
<b>department</b>: dl<br>
<b>env</b>: environment qa/uat/prod<br>
<b>region</b>: aws regions (us-east-1-tsys/eu-central-1-tsys)<br>
<b>accountname</b>: aws account number<br>
</td></td></tr></table><br>

<b>DevOps Bucket Names</b>

```
Standard names for kubernetes automation and backups.
```
<table><tr><td><td>
<b>example</b>:<br>
k8s-devops-us-east-1-\<awsaccountname><br>
common-devops-us-east-1-\<awsaccountname><br>
</tr></td></td></table><br>
