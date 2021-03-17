# AO-TEST

Setup:

Follow the steps below to have a custom built Packer image and have Terraform build some infrastructure from the newly built ami.

Update Packer file with your aws security keys
Use the command "AWS configure" in the terminal to insert in your public and private aws keys
CD into the "packer" directory and run "packer validate ami-image.json" and then "packer build ami-image.json"
And finally, CD into the "Terraform" directory and run "terraform init", "terraform plan" and "terraform apply"
Use the outputted elb ip address in the terminal to view the different instance's ip addresses.

Once done, run the command "terraform destroy" in the terminal.
