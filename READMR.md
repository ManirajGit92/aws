#Microsoft AWS utility 
#Build AWS image using Packer

Switch to AWS utility directory.
$ cd <PROJECT_ROOT_DIR>

Initialize Packer module.
$ packer init AWS/image/alma-linux-9.pkr.hcl

Validate Packer module.
$ packer validate AWS/image/alma-linux-9.pkr.hcl

Build VM image using Packer module.
$ packer build AWS/image/alma-linux-9.pkr.hcl