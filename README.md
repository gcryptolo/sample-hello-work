# Sample hello work LAB-1
sample hello work for OpenShift Sandbox buildConfig personal LAB-1

refer to [OpenShift Sandbox](https://developers.redhat.com/developer-sandboxx) for more information about OpenShift Sandbox
refer to [BuildConfig Documentation](https://docs.redhat.com/de/documentation/openshift_container_platform/4.14/pdf/builds_using_buildconfig/openshift_container_platform-4.14-builds_using_buildconfig-en-us.pdf) for technical information about BuildConfig.


PS: hello work is my mistake, I mean hello world, but I like it so I keep it as it is.

# sample-hello-work LAB-1 index

This repository is intended to be a sample hello work for the following:

- Create sample java project to test buildConfig in Openshift Sandbox

- Tecnologies used:
  - Java 21
  - Spring Boot 3.2.0
  - Maven 3.9.0
  - Docker 
  - OpenShift Sandbox version 4.14
  - OpenShift CLI (oc)

## Pre-requisites

 - Familiarity with Docker
 - Familiarity with OpenShift 
 - RedHat Account and Sandbox Access  [OpenShift Sandbox](https://developers.redhat.com/developer-sandbox)
 - GitHub Account  [GitHub](https://github.com/)
 - OC CLI installed

About 2 hours of work if you are familiar with Openshift and Docker

## Objectives

 - Build a sample Java project using BuildConfig of our Openshift Sandbox
 - Deploy the sample Java project using Deployment of our Openshift Sandbox
 - Modify the code and redeploy the sample Java project using DeploymentConfig of our Openshift Sandbox

## Steps

1. Check project name (like k8s namespace) in your OpenShift Sandbox for me is 'giovanni-manzone-dev' 
2. Checkout this sample project
3. Create a new repository in your GitHub account
4. Import this project to your gitHub repository
5. Create BuildConfig in your OpenShift Sandbox pointing gitHub repository
6. Create ImageStream in your OpenShift Sandbox
7. Create Deployment using ImageStream
8. Create Service to access the application
9. Create Route to access the application
10. Check the application
11. Modify the code and redeploy

### Step 1: Check project name

Once you create your Sandbox, you will have a project name. You can check it on OpenShift Console:


![img.png](doc%2Fimg%2Fimg.png)

### Step 2: Checkout this sample project
to checkout this project, you can use the following command:

```git clone https://github.com/gcryptolo/sample-hello-work.git```

In this project you can  find a simple hello work app and the resource file to create Openshift resources.
For java project, you can use your own project or you can use the sample project in this repository.


### Step 3: Create a new repository in your GitHub account

1. Go to your GitHub account
2. Click on the '+' icon on the top right corner
3. Click on 'New repository'
4. Enter the repository name (like 'sample-hello-work')
5. Set Public repository
5. Click on 'Create repository' 

### Step 4: Import this project to your gitHub repository

Now we have to create a java project and import it to our GitHub repository. You can use your simple java project or you can use the sample project in this repository.

If you want to use the sample project in this repository, you can follow the following steps:
1. Clone the project to your local machine
2. Go to the project directory you have cloned at Step2
3. Remove the existing git repository by deleting the .git folder
4. Copy the content of the project to your new repository
5. Commit and push the code to your new repository
6. Try the code running the simple spring boot application that respond at /hello

If you prefer don't clone the project you can use this as it is and your Openshift take  care to download this repo and build the project.

otherwise, you can use your own project and push it to your new repository.
For this lab I use java 21 to build the project with Openshift image so you also need to use java 21 to build your project.
Other important thing is that you need to use maven to build your project.
The last thing is that you need to use the following plugin in your pom.xml file to build the project with Openshift image:
```
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <mainClass>#your.main.class.package.Application#</mainClass>
        <layout>JAR</layout>
    </configuration>
    <executions>
        <execution>
            <goals>
                <goal>repackage</goal>
            </goals>
        </execution>
    </executions>
</plugin>

```

### Step 5: Create BuildConfig in your OpenShift Sandbox pointing GitHub repository
If you are using the sample project in this repository, you can use the buildConfig.yaml file in the doc folder to create the BuildConfig in your OpenShift Sandbox and follow the steps below:

1. Go to your OpenShift Sandbox
2. Click on 'Build Configs' on the top menu
3. Click on 'Create BuildConfig' on the top right corner
4. if you did not clone repo simply select YAML tab and copy the code in [doc/buildConfig.yaml](doc/buildConfig.yaml) file 
5. If you clone the repo or you are using your own project replace the &lt;your-project-name&gt; with your OpenShift Sandbox project name
6. Replace the &lt;gitHubRepository&gt; with your GitHub repository URL
7. Replace the &lt;gitHubBranch&gt; with your GitHub branch name (for example main)
8. Click on 'Create' button

```
kind: BuildConfig
apiVersion: build.openshift.io/v1
metadata:
  name: sample-hello-work-build-config   # name of the buildConfig
  namespace: your-project-name           # your project name
spec:
  output:
    to:
      kind: ImageStreamTag                  # kind of output
      name: 'sample-hello-work:latest'      # name of the output image
  strategy:
    type: Source                         # type of strategy
    sourceStrategy:
      from:
        kind: DockerImage                # kind of image
        name: '<your-route-to-image-repository>/openshift/ubi8-openjdk-21:1.18'
  postCommit:
    script: |
      echo "Build completed!"
  source:
    type: Git
    git:
      uri: <gitHubRepository> # your gitHub repository URL
      ref: <gitHubBranch>   # your gitHub branch name
    contextDir: / # your gitHub repository context directory
  runPolicy: Serial 
  ```

Now you can see the build config create in your Openshift Sandbox, but you dont see it completed because you need to create the ImageStream first and then you can start the build.
We have to create the ImageStream to store the image that will be created by the buildConfig.

### Step 6: Create ImageStream in your OpenShift Sandbox

1. Go to your OpenShift Sandbox
2. Click on 'Image Streams' on the top menu
3. Click on 'Create ImageStream' on the top right corner
4. if you did not clone repo simply select YAML tab and copy the code in [doc/imageStream.yaml](doc/imageStream.yaml) file and change the namespace value with your project name.
5. If you clone the repo or you are using your own project replace also the &lt;your-project-name&gt; with your OpenShift Sandbox project name


```
kind: ImageStream
apiVersion: image.openshift.io/v1
metadata:
  name: <your-java-project-name>   # es sample-hello-work
  namespace: <your-project-name>

```

Now you can see the buildConfig running and you can check the build, in the Build menu, you can see the build running and you can check the logs of the build.

### Step 7: Create Deployment using ImageStream

1. Go to your OpenShift Sandbox
2. Click on 'Deployments' on the top menu
3. Click on 'Create Deployment' on the top right corner
4. You can use the console to select the source StreamImage

![img_1.png](doc%2Fimg%2Fimg_1.png)


### Step 8: Create Service to access the application

now we simply create service using oc command to expose our deployment typing the following command:

```
oc expose deployment <your-java-project-name> --port=8080 --target-port=8080
```

Replace &lt;your-java-project-name&gt; with your java project name, for example sample-hello-work

you can check the service is created in Networking -> Services menu.

### Step 9: Create Route to access the application

1. Go to your OpenShift Sandbox
2. Click on 'Routes' on the top menu
3. Click on 'Create Route' on the top right corner
4. Insert Route name 
5. Insert / as path or change it with your path if your app is not responding at /
6. Select the service you created in the previous step
7. Secure Route checkbox to enable TLS
8. Click on 'Create' button

Now you can see the created route in your OpenShift Sandbox, you can check the route in the Routes menu, you can see the route created and you can check the URL of the route.


### Step 10: Check the application

retrieve URL from Openshift Console by clicking on Routes menu and then click on the route you created in the previous step, you can see the URL of the route.

![img_2.png](doc%2Fimg%2Fimg_2.png)

If you go to the route URL https://<your_route_url>/hello you can see the hello work application running.

### Step 11: Modify the code and redeploy

In order to modify the code and redeploy the application, we have to define  a trigger on our buildConfig  adding the following code in the buildConfig.yaml file in spec section:
```
  triggers:
    - type: Generic
      generic:
        secret: mysecretkey
```

Once you add the trigger you can retrive Webhook URL from the buildConfig in the OpenShift Console, you can see the Webhook URL typing the following command:

```
oc describe bc sample-hello-work-build-config
```

the output will be something like this:
```
Webhook GitHub:
        URL:    https://api.rm1.0a51.p1.openshiftapps.com:6443/apis/build.openshift.io/v1/namespaces/giovanni-manzone-dev/buildconfigs/sample-hello-work-build-config/webhooks/<secret>/github

```

the defined secret <secret> is the one you defined in the buildConfig.yaml file, in this case mysecretkey so the url in my case is:

```
https://api.rm1.0a51.p1.openshiftapps.com:6443/apis/build.openshift.io/v1/namespaces/giovanni-manzone-dev/buildconfigs/sample-hello-work-build-config/webhooks/mysecretkey/github
```

if you configure this in settings section under webhooks in your gitHub repository:
![img_3.png](doc%2Fimg%2Fimg_3.png)

you can see the webhook created  but if you commit code the webhook fail because you need a permission ti run webhook .
You can set the permission in your Openshift Sandbox by typing the following command:

```
oc policy add-role-to-user system:webhook -n <your-project-name> -z default
oc adm policy add-role-to-group system:webhook system:unauthenticated -n <your-project-name>
```
Now finally you can see your webhook working and you can see the buildConfig running in your OpenShift Sandbox.
After buildConfig is completed you can see the deployment changing the image because  the ImageStream is updated with the new image.


