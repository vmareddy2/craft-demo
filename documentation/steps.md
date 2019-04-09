1. create IAM group admin
2. create IAM user admin
3. create access key for user and download via console. 
2. export credentials AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
3. download terraform
4. terraform init
5. Create single vpc, 2 web subnets, 2 app subnets 
6. Create Launch configuration with ec2 instance which brings up tomcat in docker container. 
7. Create Autoscaling Group and tie Launch conifguration with it.
8. Create Application Load Balancer and tie target group with the autoscaling group.
9. Create Basic Monitoring
10. 

