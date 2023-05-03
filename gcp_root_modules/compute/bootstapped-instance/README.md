######################## Terraform Bootstrapped Instance Modules ####################################

Terraform root module which help to create an vm instance and run custom script inside VM.

Feature:
----------

This module is quite compact due to usage of instance terraform modules.

1: Create instance with floating IP if required.

2: Copy script to instance and execute them.

3: Also execute set of commands into instance.



Module Version 0.1  <Mendatory Need to pass as Reference in your .tf file in child modules>
------------------
gcp/compute/bootstrapped-instance 0.1


Terraform Version:
------------------
Latest or 0.13.05+


Followin example to consume root module in your child module.

vm.tf:

module "testvm" {

source = "git::ssh://git@github.com/gcp_root_modules.git/compute/bootstrapped-instance?ref=0.1  <where 0.1 will be git tag which will refer latest root module>
name  = "var.vm_name"
network =   module.main_network.vpn.name
subnetwork =  module.main_subnetwork.subnet.name

}



