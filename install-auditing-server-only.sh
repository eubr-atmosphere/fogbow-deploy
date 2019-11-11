#!/bin/bash
#!/bin/bash
HOSTS_CONF_FILE="$(pwd)/conf-files/hosts.conf"
ANSIBLE_HOSTS_FILE="ansible-playbook/auditing-server-only/hosts"
ANSIBLE_CFG_FILE="ansible-playbook/auditing-server-only/ansible.cfg"
# setup hosts
AUDITING_SERVER_VM_IP=$(grep ^auditing_server_host_ip $HOSTS_CONF_FILE | awk -F "=" '{print $2}')
PATTERN_HELPER="\[auditing-server-machine\]"
AUDITING_SERVER_VM_IP_PATTERN=$(grep -A1 $PATTERN_HELPER $ANSIBLE_HOSTS_FILE | tail -n 1)
sed -i "s/$AUDITING_SERVER_VM_IP_PATTERN/$AUDITING_SERVER_VM_IP/" $ANSIBLE_HOSTS_FILE

ANSIBLE_SSH_PRIVATE_KEY_FILE=$(grep ^ansible_ssh_private_key_file $HOSTS_CONF_FILE | awk -F "=" '{print $2}')
PRIVATE_KEY_FILE_PATH_PATTERN="ansible_ssh_private_key_file"
sed -i "s#.*$PRIVATE_KEY_FILE_PATH_PATTERN=.*#$PRIVATE_KEY_FILE_PATH_PATTERN=$ANSIBLE_SSH_PRIVATE_KEY_FILE#g" $ANSIBLE_HOSTS_FILE

#setup ansible.cfg
REMOTE_USER=$(grep ^remote_hosts_user $HOSTS_CONF_FILE | awk -F "=" '{print $2}')
PATTERN_HELPER="remote_user"
sed -i "s#.*$PATTERN_HELPER = .*#$PATTERN_HELPER = $REMOTE_USER#g" $ANSIBLE_CFG_FILE

DEPLOY_FOGBOW_FILE_PATH="auditing-server-only/deploy-server.yml"

(cd ansible-playbook && ansible-playbook -vvv $DEPLOY_FOGBOW_FILE_PATH)

chmod -R go-rw conf-files
chmod -R go-rw services

find ./* -type f -name "secrets" -exec rm {} \;


