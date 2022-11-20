This is for tech-challenge information.

Source Control
https://github.com/uturndata-public/tech-challenge-preetham


CI/CD Jenkins Pipeline:
http://localhost:8080/job/Tech-Challenge/

#### Introduction
Using this terraform module user would be able to create a minimum aws resouce to deploy any application

There are separate module created for each resources, the module has been resused to create 2 ec2 instances , ec2 security group , Load Balancer secruity group.

A vpc has been created and two subnet each in us-east-a and us-east-b AZ, An internetgateway has been created. The route table is a public route table which has been associated with both subnet, thus both the subnet are public subnet.

There are two ec2 instance created for High availability each in AZ us-east-a and us-east-b. The loadbalancer has been deployed in Public subnet. Since the loadbalance is in public subnet ec2 instance can also be deployed in private subnet. the target group has been created which is attached to the load balancer and both the ec2 instance are registered to the target group. the target group has healtch check.

Since the flash app is running on port 8000, the target group health is configured with http and the path /gtg , if the application is running the target group would consider the target as healthy and the load balancer would only route the traffic to the heathy ec2 instance.


#### PREREQUISITE
|Application | version|
|------------|-------------|
| terraform  |  > 1.2|

#### Terraform module 
The repository contain the Terraform module to deploy the below AWS resource
* VPC
* Subnet
* Route Table
* Security Group
* EC2 Instance
* EC2 KEY PAIR
* Internet Gateway
* Load Balancer
* Load Balancer Target Group
* IAM Role
* IAM Instance Profile
* Database

### Instructon on how to initiate terraform and deploy the above resource

### create ssh key pair to access ec2 instance

Run the below command and follow the instruction, this would generate a public key and a private key. Use the public in the tfvar file and the private to connect to ec2 instance using ssh.
```sh

ssh-keygen -t rsa -b 4096
```
### preparing the terraform tfvars

```sh
aws_region="< aws region >"
aws_access_key="aws user secret access key "
aws_secret_key="aws user secret"
public_key="<public key>"
sg_ingress_rules = { <list of ingress rule to be added>}
target_group_health_check =   {<target group health check parameter > } 
example - 
sg_ingress_rules = {
    "my ingress rule" = {
      "description" = "For HTTP"
      "from_port"   = "80"
      "to_port"     = "80"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },
    "my other ingress rule" = {
      "description" = "For SSH"
      "from_port"   = "22"
      "to_port"     = "22"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },
    "flash app ingress rule" = {
      "description" = "For SSH"
      "from_port"   = "8000"
      "to_port"     = "8000"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    }
}



target_group_health_check =   {
      "timeout"  = "10"
      "interval" = "20"
      "path"     = "/gtg"
      "port"     = "8000"
      "unhealthy_threshold" = "2"
      "healthy_threshold" = "3"
  }
```

#### initializing Terraform 

```sh

terraform Init 
```
#### Terraform Plan

```sh
terraform plan
terraform apply --var-file=<path to the tf var file > 

example 
terraform apply -var-file="dev.tfvars" 
```

### access ec2 instance
Use the private key to ssh to the ec2 instance

```sh
chmod 400 <private key >
ssh -i <private key> ubuntu@<public ip of ec2 instance>

example 

chmod 400 aws_key
ssh -i aws_key ubuntu@10.10.10.10
```
#### Deploy application using jenknfile
#### Screenshots of Jenkins pipeline is pushed to repo https://github.com/uturndata-public/tech-challenge-preetham/blob/main/Jenkins%20Pipeline%20document.docx
Use the Jenkinsfile to deploy the flash app on the AWS ec2 instance , the jenkinsfile contains three stages 
```
Stage1 - Checkout - pull the code from repository.
Stage2 - copy Artifact- copy the code to the individual EC2 instance
Stage3 - run application- run the application 
```

### accesing applicatin 
The application is running on port 8000. To test the application is running hit the public ip of the ec2 instance at port 8000 
```sh
http://<ec2 instance public ip >:8000
http://10.10.10.10:8000/gtg?details

```

```sh
http://<loadbalancer dns >:8000

example 

http://flashapp.aws.com:8000/gtg
```


