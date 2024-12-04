kubectl exec -n digitalai -c release -it dai-xlr-digitalai-release-0 -- cat /opt/xebialabs/xl-release-server/conf/deployit-defaults.properties | grep ansible.RunPlaybook.ansibleCmd=ansible-playbook
