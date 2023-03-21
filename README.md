
# TimeOff.Management

Web application for managing employee absences.

<a href="https://travis-ci.org/timeoff-management/timeoff-management-application"><img align="right" src="https://travis-ci.org/timeoff-management/timeoff-management-application.svg?branch=master" alt="Build status" /></a>

## Features

**Multiple views of staff absences**

Calendar view, Team view, or Just plain list.

**Tune application to fit into your company policy**

Add custom absence types: Sickness, Maternity, Working from home, Birthday etc. Define if each uses vacation allowance.

Optionally limit the amount of days employees can take for each Leave type. E.g. no more than 10 Sick days per year.

Setup public holidays as well as company specific days off.

Group employees by departments: bring your organisational structure, set the supervisor for every department.

Customisable working schedule for company and individuals.

**Third Party Calendar Integration**

Broadcast employee whereabouts into external calendar providers: MS Outlook, Google Calendar, and iCal.

Create calendar feeds for individuals, departments or entire company.

**Three Steps Workflow**

Employee requests time off or revokes existing one.

Supervisor gets email notification and decides about upcoming employee absence.

Absence is accounted. Peers are informed via team view or calendar feeds.

**Access control**

There are following types of users: employees, supervisors, and administrators.

Optional LDAP authentication: configure application to use your LDAP server for user authentication.

**Ability to extract leave data into CSV**

Ability to back up entire company leave data into CSV file. So it could be used in any spreadsheet applications.

**Works on mobile phones**

The most used customer paths are mobile friendly:

* employee is able to request new leave from mobile device

* supervisor is able to record decision from the mobile as well.

**Lots of other little things that would make life easier**

Manually adjust employee allowances
e.g. employee has extra day in lieu.

Upon creation employee receives pro-rated vacation allowance, depending on start date.

Email notification to all involved parties.

Optionally allow employees to see the time off information of entire company regardless of department structure.

## Architecture

The proposed architecture is based in a kubernetes cluster, in this case a minikube cluster, however, this infrastructure can be deployed in kubernetes cluster in cloud.

The diagram of this infrastructure is shown in the following image:

![image](https://user-images.githubusercontent.com/17441125/226503549-80bb0e73-7f19-4f24-bf32-3fbe20418136.png)


## Screenshots

This is the deployed application 

![image](https://user-images.githubusercontent.com/17441125/226500543-405f3720-1b0d-4179-a30f-4edccef9ec02.png)

This is the terminal of minikube 

![image](https://user-images.githubusercontent.com/17441125/226500683-362e3faf-c15f-45e4-bf0f-52d2024689f8.png)

## Installation

For Installation purpose it was required to modify the dependencies versions in package.json provided in the project. For infrastructure security purposes it is required to add an ingress to create a balancer with the related annotations.

### Self hosting

Install TimeOff.Management application within your infrastructure:

(make sure you have Node.js (>=4.0.0), SQLite installed, dockerhub login and minikube installed locally)

```bash
sudo /etc/init.d/docker start
minikube start
kubectl apply -f kubernetes/
bash deployment.sh
minikube ip
```
Open http://${MINIKUBE_IP}:$(MINIKUBE_PORT)/ in your browser.

## How to?

There are some customizations available.

## How to amend or extend colours available for colour picker?
Follow instructions on [this page](docs/extend_colors_for_leave_type.md).

## Customization

There are few options to configure an installation.

### Make sorting sensitive to particular locale and Force employees to pick type each time new leave is booked

The config file is modified as follows:

![image](https://user-images.githubusercontent.com/17441125/226501670-3619d3fc-02c0-4eb6-82c0-6729fff5853c.png)

## Use Redis as a sessions storage

To use the redis server the file app.json is configured like this
```json
"sessionStore": {
    "useRedis": true,
    "redisConnectionConfiguration": {
      "host": "192.168.49.2",
      "port": 30009
    }
  },
```
A deployment and a service are deployed to get a standalone redis like this:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: redis
spec:
  type: NodePort
  selector:
    app: redis
  ports:
  - port: 6379
    targetPort: 6379
    nodePort: 30009
    protocol: TCP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
spec:
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis-container
        image: redis:latest
        resources:
          limits:
            memory: "512Mi"
            cpu: "500m"
        ports:
        - containerPort: 6379
```

The timeoff deployment is configured to allow a load balancing traffic with a exposed service, and configurable number of replicas.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: timeoff
spec:
  replicas: 2
  selector:
    matchLabels:
      app: timeoff
  template:
    metadata:
      labels:
        app: timeoff
    spec:
      containers:
      - name: timeoff
        image: leonardos37/timeoff:v1.4
        ports:
        - containerPort: 3000
```

When the pipeline is executed through the deployment.sh file, a new image is built in dockerhub which is then pulled by the deployment, based on the latest version.

![image](https://user-images.githubusercontent.com/17441125/226502442-64d5ec52-2418-48e4-9323-f2914f37b879.png)



## Feedback

Please report any issues or feedback to <a href="https://twitter.com/FreeTimeOffApp">twitter</a> or Email: pavlo at timeoff.management

