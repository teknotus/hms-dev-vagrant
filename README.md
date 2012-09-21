# Easy development environment for HMS

HMS, or Health Message Service is a combination of two rails apps run on different machines, and depends on a third rails app. As all rails apps it is somewhat complicated to setup a development environment. The goal of this small project is to turn getting the develpment environment working as close to a one step process as possible. It may further be adapted in the future to a full production install, but this project currently only aims to setup the develpment environment. 
## Setup

1. Install git http://git-scm.com/
2. Install Vagrant http://vagrantup.com/
3. Run the following command
    `git clone --recursive https://github.com/teknotus/hms-dev-vagrant.git && cd hms-dev-vagrant && vagrant up`
4. Setup config files
5. Setup git remotes

## What's working

That should get you as far as downloading all software, and creating datbases for the notifier, and hotline. All of the ruby gems for those two apps should be installed too. Virtual machines for both the notifier, and hub should be setup too with networkig between them. 

## What's not working

The hotline seems to have additional requirements in the setup process that haven't been addressed yet, and the setup for the hub is barely started. The default config files will not work out of the box. 

