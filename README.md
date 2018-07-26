# spring-boot-mongo-kubernetes-docker

This is a sample spring-boot application that talks to mongoDB for GET/POST REST APIs and deployed in Kubernetes cluster.

Prerequisites
minikube
kubectl
docker
maven

Set up a Spring Boot app
If you want to run with Maven, execute:

./mvn package && java -jar target/spring-boot-mongo-docker-1.0.0.jar
and go to http://localhost:8080/customer/ to see your persisted customers.

Dockerisation
We need a container with jdk to run our springboot application. There are many images with jdk 8 publicly available already but just to get the end to end experience We will built a minimal container based on alpine linux with Jdk 8

docker build -t  aritranag20/spring-boot-mongo-docker .

Then log into docker, with your credentials after signing up on docker.io,

docker login

Execute the following command to push image to docker registry.

docker push aritranag20/spring-boot-mongo-docker 

Containerize It

If you want to run with Docker, execute:

./docker-compose up

Deploying on Kubernetes
Now that we have image of our application available in the docker registry, we can deploy it in a kubernetes cluster. We will also set up a node for mongoDB to be used as backend by our application.

Start local kubernetes cluster with the following command:

minikube start

We can then launch dashboard for the cluster:

minikube dashboard

Next create deployment of our application in the cluster.

kubectl create -f deployment.yml

We can see description of the service with

kubectl describe service spring-boot-mongo-docker

Now get the exact address of the service with

minikube service spring-boot-mongo-docker 

which will launch browser and point to the endpoint. For e.g. in my case,

curl http://192.168.99.101:30864/user =>
[{"id":"58bcd7ad5908010005cce257","firstName":"Arun","lastName":null,"email":null,"address":{"street1":null,"street2":null,"town":null,"postcode":null,"state":null}}]

Summary
Congratulations! You’ve just created a Docker container for a Spring Boot app with MongoDB and hosted the app in Kubernets! Spring Boot apps run on port 8080 inside the container by default and we mapped that to the same port on the pods which is load balanced across multiple replicas of the service and can be assessed by getting the NodePort from kubectl describe service spring-boot-mongo-docker command.

Optional
Finally to stop your local kubernetes cluster:

minikube stop
