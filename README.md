# minecraft-terraform

This repository is intended to deploy a Minecraft Server on Google Cloud Platform, install all the dependencies and do the first run.


**Terraform deployment creates:**

- VPC Network 'mc-net'

- Firewall rule allowing ports 22 and 25565

- e2-standard-2 instance running Debian 11 with a 50GB ssd persistent disk, where the server files are allocated.


**The installation script does the following:**

- Create '/home/minecraft' directory

- gives format to the extra disk

- install all the dependecies

- download Minecraft Server .jar file

- runs the server for first time

- Agree EULA file

- leaves the server running in a background process with screen. Process name called 'mcs'


**To be done:**

- Variabilize Terraform manifest as much as possible

- Allow to select Minecraft Server version to be installed

- add automatic backups

- add option to customize server.properties file


