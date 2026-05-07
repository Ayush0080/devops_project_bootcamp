## Remote backend
![alt text](image.png)
![alt text](image-1.png)

#### Create S3 Bucket for Remote Backend using terraform

- Use default_tags in Provider (Instead of repeating tags in every resource, define them once in the provider)
```bash
provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Terraform   = "true"
      Environment = "production"
      Project     = "my-app"
      Owner       = "devops-team"
    }
  }
}cd 

```
![alt text](image-2.png)
![alt text](image-3.png)



#### Terraform Remote Backend with S3 Bucket to creat vpc

![alt text](image-4.png)
![alt text](image-5.png)
![alt text](image-6.png)
![alt text](image-7.png)

- again running terraform apply 
![alt text](image-8.png)
![alt text](image-9.png)


#### Terraform Modules

![alt text](image-10.png)
![alt text](image-11.png)


- created vpc using module

![alt text](image-15.png)

![alt text](image-16.png)









