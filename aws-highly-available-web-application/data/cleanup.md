Cleanup Steps - 

Don't delete everything randomly. Follow this order:

1. Delete the Auto Scaling Group
2. Delete the Application Load Balancer
3. Delete the Target Group
4. Delete the Launch Template
5. Delete the Ec2 Instances
6. Delete the AMI
7. Delete the Network - VPC, Subnets, Security Groups, Internet Gateway, Route Tables. 
8. Delete the CloudWatch Alarms. 
9. Delete the SNS topic. 
