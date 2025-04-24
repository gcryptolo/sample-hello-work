# sample-hello-work
sample hello work for OpenShift Sandbox buildConfig personal LAB-1


# sample-hello-work LAB-1 index

This repository is intended to be a sample hello work for the following:

- Create sample java project to test buildConfig in Openshift Sandbox

## Pre-requisites

 - Familiarity with Docker
 - Familiarity with OpenShift
 - RedHat Account and Sandbox Access
 - GitHub Account

About 2 hours of work if you are familiar with Openshift and Docker

## Objectives

 - Build a sample Java project using BuildConfig of our Openshift Sandbox
 - Deploy the sample Java project using Deployment of our Openshift Sandbox
 - Modify the code and redeploy the sample Java project using DeploymentConfig of our Openshift Sandbox

## Steps

1. Check project name (like k8s namespace) in your OpenShift Sandbox for me is '<username>-dev' 
2. Checkout this sample project
3. Create a new repository in your GitHub account
4. Import this project to your gitHub repository
5. Create BuildConfig in your OpenShift Sandbox pointing gitHub repository
6. Create ImageStream in your OpenShift Sandbox
7. Crete Deployment using ImageStream
8. Create Service to access the application
9. Create Route to access the application
9. Check the application
10. Modify the code and redeploy

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

Now we have to create a java project and import it to our gitHub repository. You can use your simple java project or you can use the sample project in this repository.

If you want to use the sample project in this repository, you can follow the following steps:
1. Clone the project to your local machine
2. Go to the project directory you have cloned at Step2
3. Remove the existing git repository by deleting the .git folder
4. Copy the content of the project to your new repository
5. Commit and push the code to your new repository
6. Try the code running the simple spring boot application that respond at /hello

If you prefer dont clone the project you can use this as it is and your Openshift take  care to download this repo and build the project.

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

### Step 5: Create BuildConfig in your OpenShift Sandbox pointing gitHub repository
If you are using the sample project in this repository, you can use the buildConfig.yaml file in the doc folder to create the BuildConfig in your OpenShift Sandbox and follow the steps below:

1. Go to your OpenShift Sandbox
2. Click on 'Build Configs' on the top menu
3. Click on 'Create BuildConfig' on the top right corner
4. if you did not clone repo simply select YAML tab and copy the code in [doc/buildConfig.yaml](doc/buildConfig.yaml) file 
5. If you clone the repo or you are using your own project replace the <your-project-name> with your OpenShift Sandbox project name
6. Replace the <gitHubRepository> with your GitHub repository URL
7. Replace the <gitHubBranch> with your GitHub branch name (for example main)
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

Now you can see the build config create din your Openshift Sandbox, but you dont see it completed because you need to create the ImageStream first and then you can start the build.
We have to create the ImageStream to store the image that will be created by the buildConfig.

### Step 6: Create ImageStream in your OpenShift Sandbox

1. Go to your OpenShift Sandbox
2. Click on 'Image Streams' on the top menu
3. Click on 'Create ImageStream' on the top right corner
4. if you did not clone repo simply select YAML tab and copy the code in [doc/imageStream.yaml](doc/imageStream.yaml) file and change the namespace value with your project name.
5. If you clone the repo or you are using your own project replace also the <your-project-name> with your OpenShift Sandbox project name


```
kind: ImageStream
apiVersion: image.openshift.io/v1
metadata:
  name: <your-java-project-name>   # es sample-hello-work
  namespace: <your-project-name>

```

Now you can see the builConfig runnning and you can check the build, in the Build menu, you can see the build running and you can check the logs of the build.

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

replace <your-java-project-name> with your java project name, for example sample-hello-work

you can check the service is created in Networking -> Services menù.

### Step 9: Create Route to access the application

1. Go to your OpenShift Sandbox
2. Click on 'Routes' on the top menu
3. Click on 'Create Route' on the top right corner
4. Insert Route name 
5. Insert / as path or change it with your path if your app is not responding at /
6. Select the service you created in the previous step
7. Secure Route checkbox to enable TLS
8. Click on 'Create' button

Now you can see the route created in your OpenShift Sandbox, you can check the route in the Routes menu, you can see the route created and you can check the URL of the route.
If you go to the route URL https://<your_route_url>/hello you can see the hello work application running.