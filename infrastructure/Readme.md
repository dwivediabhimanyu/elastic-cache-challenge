- **Update IAM credentials**
  Update IAM User access id and access key in the file `provider.tf`

- **Using Terraform**
  Start by getting Terraform from their [download page](https://www.terraform.io/downloads.html).
  Test that Terraform is accessible by checking for the version number in a terminal with the command underneath.
  `terraform -v`
  In `infrastucuter` directory initialize terraform by running the command below.
  `terraform init`
  Deploy the configuration by using the command below followed by typing yes in command line.
  `terraform apply`
  To destroy resources use command
  `terraform destroy`
