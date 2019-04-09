# Layout

3 tiers - web, app and db.
2 availability zones - subnet in each zone.

Web Tier:
1. Application Load Balancer
2. Ec2 instance in web use as bastion to log into ec2 instances
3. Lambda instance hitting the Load Balancer to generate traffic?

App Tier:
1. Consists of EC2 instances installed via autoscaling group

DB Tier:
1. RDS 

# Monitoring
1. Monitoring on ALB request count, request/target, response times, Status failures
2. Monitoring on EC2 instance CPU, Disk I/O, Status failures?
3. DB Monitoring??
4. App/tomcat monitoring ? - collectd, statsd. Simpler way another use awscli and push using script

# Alerting
1. Alert primarily on app response times, Status failures (> 1), EC2 Instance count (want 2 running at the very minimum)
2. Test autoscaling

# Sample App
Planned to leverage https://www3.ntu.edu.sg/home/ehchua/programming/java/JavaWebDBApp.html (for an app using mysql)
