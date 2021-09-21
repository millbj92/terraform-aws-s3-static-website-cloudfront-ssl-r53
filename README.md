# BMIO_S3_Static_Webstie

This module will deploy all resources necessary to host a static website inside of an S3 bucket. 

## Usage:

 - First start out by cloning this repository.

 - Navigate to /example/main.tf

 - Plug in all variables to what is specific to your use-case.

 - Execute `terraform init`, and then `terraform plan`. Make sure you are happy with the results it gives you.

 - Once you are satisfied, type `terraform apply` and it should start deployting your resources.

 - Note that this deployment could take ~5-10 minutes. It has to deploy your Route53 records, and then confirm via DNS. Cloudfront can also take awhile to deploy.

 - Once it's finished, verify everything is working and deploy your website to your new bucket. 

 - Happy coding!! 😎


*Note* README files for each module can be found inside of their respective modules directory.

[ACM Cert Module](./modules/acm/README.md)

[S3 Bucket Module](./modules/s3_static_website/README.md)