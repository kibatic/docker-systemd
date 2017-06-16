test:
	@sudo docker run -it --rm -v ${PWD}:/app/roles/docker-systemd -w /app/roles/docker-systemd/tests kitpages/docker-ansible:${ANSIBLE_VERSION} ansible-playbook test.yml -i inventory --syntax-check
