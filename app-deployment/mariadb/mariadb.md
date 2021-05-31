We are going to deploy a database for our application called "Chatty". For this purpose, we will use public MariaDB docker image. MariaDB is open-source implementation of MYSQL database. You can find more about the MariaDB on the official [MariaDB website](https://mariadb.com/).

## Deployment of non-public docker image
Kubernetes by default pulls image from docker hub if the image is not already present. If you want to deploy local image, **you have to build the image on a node hosting the pod**.

## Docker build
We need to start a database and initialize it with a [database table](app-Deployment/mariadb/docker-resources/chatty.sql) for our app. To do so, we need to alter MariaDB docker image a bit and build our own image. See the [Dockerfile](app-Deployment/mariadb/docker-resources/Dockerfile). Let's build the database:  
```
docker build -t chatty-db:0.0.1 docker-resources/
```

## Writing k8s deployment configuration
```
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  labels:
    # These labels are optional, but considered a good practise
    app.kubernetes.io/name: chatty-db
    app.kubernetes.io/instance: chatty-db
    app.kubernetes.io/version: "0.0.1"
    app.kubernetes.io/component: database
    app.kubernetes.io/part-of: chatty
  name: chatty-server-db
spec:
  selector:
    matchLabels:
      app: chatty-server-db
  replicas: 1
  template:
    metadata:
      labels:
        app: chatty-server-db
    spec:
      containers:
      - name: chatty-db
        image: chatty-db:0.0.1
        env:
          - name: MYSQL_ROOT_PASSWORD
            value: "chatty"
          - name: MYSQL_DATABASE
            value: "chatty"
        ports:
        - containerPort: 3306
```
Useful observations:
* **image: chatty-db:0.0.1** - you have to specify it with the same name:tag pair you built it with.
* **env:** - These env variables are needed for the MariaDB to run. This is equivalent to running a docker command: **docker run -e MYSQL_ROOT_PASSWORD=chatty -e MYSQL_DATABASE=chatty chatty-db:0.0.1**

## Deployment
1. Apply configuration file  
```
kubectl apply -f k8s-resources/mariadb-k8s-deployment.yaml
```

2. Check deployment status  
Wait for mariadb to enter into running state.
```
watch -n 10 -- kubectl get pods -n kube-system
```

If mariadb entered into running state, deployment should be successful. Otherwise, use [k8s troubleshooting guide](kubernetes-guides/troubleshooting.md).
