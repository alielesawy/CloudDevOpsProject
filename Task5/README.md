
# Ansible Configuration Management for EC2 Instances

This README outlines the steps taken to complete **Task 5: Configuration Management with Ansible**, as part of provisioning and configuring EC2 instances created with Terraform. The goal was to deliver Ansible playbooks to configure EC2 instances with Git, Docker, Java, Jenkins, and SonarQube, using roles and dynamic inventory.

![](/assets/icons8-ansible-144.png)

![](/assets/icons8-git-144.png) ![](/assets/icons8-java-144.png) ![](/assets/icons8-docker-96.png) ![](/assets/icons8-jenkins-144.png) ![](/assets/sonarqube.svg)
---

## Project Overview

Task 5 required configuring EC2 instances (previously created with Terraform) to:
- Install required packages: Git, Docker, Java.
- Install prerequisites for Jenkins and SonarQube.
- Set up necessary environment variables.
- Use Ansible roles for modularity.
- Leverage AWS dynamic inventory to target instances.

The Ansible setup is stored in the `ansible/` directory of this repository, with roles and playbooks designed to be reusable and maintainable.

---

## Prerequisites

Before starting, ensure the following:
- **Terraform Setup**: EC2 instances are running with public IPs and an SSH key pair (e.g., `my-key-pair.pem`), as configured in `terraform_project/`.
- **Ansible Installed**: Available on the control node (e.g., `pip install ansible`).
- **AWS CLI**: Configured with credentials to access EC2 instances.
- **SSH Key**: The private key file (e.g., `~/.ssh/my-key-pair.pem`) is accessible.

---

## Steps to Create Ansible Roles and Solve Task 5

### 1. Set Up Project Structure
- Created an `ansible/` directory with a clear structure:
  - `inventory/`: Holds the dynamic inventory configuration.
  - `roles/`: Contains modular roles for `common`, `jenkins`, and `sonarqube`.
  - `site.yml`: The main playbook tying everything together.
  - `ansible.cfg`: Configuration file for Ansible settings.
- Refer to the repository’s `ansible/` directory for the full layout.
#### Project Structure
- [inventory](/Task5/inventory/)
    - [aws_ec2.yml](/Task5/inventory/aws_ec2.yml) : Dynamic inventory configuration.
- [roles](/Task5/roles/)
    - [common](/Task5/roles/common/)
        - [tasks](/Task5/roles/common/tasks)
            - [main.yml](/Task5/roles/common/tasks/main.yml) : Installs Git, Docker, and Java 17.
    - [jenkins](/Task5/roles/jenkins/)
        - [tasks](/Task5/roles/jenkins/tasks)
            - [main.yml](/Task5/roles/jenkins/tasks/main.yml) : Configures Jenkins with Java 17.
        - [handler](/Task5/roles/jenkins/handlers/) 
            - [main.yml](/Task5/roles/jenkins/handlers/main.yml)   
    - [sonarqube](/Task5/roles/sonarqube/)
        - [tasks](/Task5/roles/sonarqube/tasks)
            - [main.yml](/Task5/roles/sonarqube/tasks/main.yml)  :  Sets up SonarQube.  
- [ansible.cfg](/Task5/ansible.cfg) :   Ansible configuration settings.
- [site.yml](/Task5/site.yml) :         Main playbook orchestrating the roles.
### 2. Configure Dynamic Inventory
- Used the AWS EC2 dynamic inventory plugin to automatically discover Terraform-created instances.
- Configured `inventory/aws_ec2.yml` to filter instances by region (`us-east-1`) and tags (`Name: app-instance-*`).
- Installed required Python libraries: `pip install boto3 botocore` and `ansible-galaxy collection install amazon.aws`.
- Tested with `ansible-inventory --list` to confirm instance detection.

### 3. Create the Common Role
- Developed `roles/common/tasks/main.yml` to install base packages and configure the environment:
  - Updated package cache and installed Git, Docker, and Java 17 (initially Java 11, later upgraded).
  - Started the Docker service and added the `ubuntu` user to the Docker group.
  - Set `JAVA_HOME` to `/usr/lib/jvm/java-17-openjdk-amd64` in `/etc/environment`.

### 4. Create the Jenkins Role
- Built `roles/jenkins/tasks/main.yml` to install and configure Jenkins:
  - Added the Jenkins repository and apt key.
  - Installed Jenkins and set `JAVA_HOME` in `/etc/default/jenkins`.
  - Configured the systemd service file to run Jenkins with Java 17.
  - Ensured proper permissions for the Jenkins WAR file and home directory.
  - Enabled logging to `/var/log/jenkins/jenkins.log`.

### 5. Create the SonarQube Role
- Designed `roles/sonarqube/tasks/main.yml` to install and configure SonarQube:
  - Installed `unzip` and downloaded SonarQube 9.9.0.
  - Extracted it to `/opt/sonarqube` and set permissions for the `ubuntu` user.
  - Created a systemd service to run SonarQube.

### 6. Write the Main Playbook
- Created `site.yml` to orchestrate the roles:
  - Targeted EC2 instances using the dynamic inventory tag `tag_Name_app_instance_*`.
  - Applied the `common`, `jenkins`, and `sonarqube` roles in sequence.

### 7. Configure Ansible Settings
- Updated `ansible.cfg` with:
  - `remote_user = ubuntu` (default Ubuntu EC2 user).
  - `private_key_file = ~/.ssh/my-key-pair.pem` (path to the Terraform key).
  - `host_key_checking = False` for simplicity.

### 8. Test and Troubleshoot
- Tested connectivity: `ansible all -m ping`.
- Ran the playbook: `ansible-playbook site.yml`.
- Encountered issues:
  - **Java Version**: Jenkins required Java 17, not 11. Updated the `common` role accordingly.
  - **Jenkins Service Failure**: Fixed by overriding the systemd service in the `jenkins` role.
  - **Syntax Errors**: Corrected YAML syntax in `roles/jenkins/tasks/main.yml` (handlers section).

### 9. Verify the Setup
- Confirmed Java 17: `java -version` on each instance.
- Checked Jenkins: `systemctl status jenkins` and accessed `http://<PUBLIC_IP>:8080`.
- Verified SonarQube: `systemctl status sonarqube` and accessed `http://<PUBLIC_IP>:9000`.
![](/assets/task5-javaDocker.png)
![](/assets/task5-jenkisAccsess.png)
![](/assets/task5-sonarqupe.png)
---

## Running the Playbook

1. Navigate to the `ansible/` directory:
   ```bash
   cd ansible/
   ```
2. Test connectivity:
   ```bash
   ansible all -m ping
   ```
3. Apply the configuration:
   ```bash
   ansible-playbook site.yml
   ```
![](/assets/task5-ansibleLog.png)
---


## Notes

- **Java Upgrade**: Initially used Java 11, but upgraded to Java 17 due to Jenkins requirements.
- **Instance spec**: Ensure the EC2 is t2.small or higher
- **Dynamic Inventory**: Ensures flexibility by targeting instances based on AWS tags.
- **Troubleshooting**: Key fixes included adjusting the Jenkins service file and ensuring proper permissions.
