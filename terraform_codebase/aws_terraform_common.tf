#terraform aws provider config
provider "aws"{
	shared_credentials_file = "~/.aws/credentials" 
	region = "us-east-1"
}


#aws s3 bucket terraform state backup config
terraform{
        backend "s3"{
                bucket = "capstone-project37"
                key = "terraform.tfstate"
                region = "us-east-1"
        }

}
