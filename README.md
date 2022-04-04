# Jenkins-s3-backup
AWS Infrastructure built with Terraform. 
EC2 Instance contains user data to spin up 3 Docker containers   
1. Jenkins Docker Container 
2. MySQL database Server  
3. SSH Remote Server  

The Remote Server queries the mySQL DB to store data   
The remote server to create a local back up of the database 
Jenkins connect’s to the remote server through SSH and sends the local backup to an S3 bucket
