### Docker  + Kubernetes This repository is dedicated to personally docker related work and projects
### For kube-setup.sh
### Please make sure this before using kube-setup.sh script file
# ----------------------------------------------------------------------------------------------------------------------------------------
Based on the provided requirements, you can create a checklist for verifying the instance configuration:

1. Ensure that the instance type is at least T2.medium.
2. Verify that the instance's volume storage is at least 20 GiB.
3. Set up proper hostnames for each machine and ensure that you can establish a ping connection between all machines and vice versa.
4. Disable or stop SELinux and the firewall on each machine.
5. chmod a+x script.sh
6. ./script.sh

By following this checklist, you can confirm that the instances meet the specified requirements.
