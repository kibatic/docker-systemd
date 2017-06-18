ANSIBLE_VERSION ?= 2.0
ANSIBLE_PLAYBOOK := sudo docker run -it --rm -v ${PWD}:/app/roles/docker-systemd -w /app/roles/docker-systemd/tests kitpages/docker-ansible:${ANSIBLE_VERSION} ansible-playbook

syntax-check:
	@sudo $(ANSIBLE_PLAYBOOK) test.yml -i inventory --syntax-check

test: clean syntax-check run-test

run-test:
	@echo "Copy default template to test folder"
	cp templates/default.service.j2 tests/templates/
	@echo "Installing goss"
	stat /usr/local/bin/goss || curl -fsSL https://goss.rocks/install | sudo sh
	@echo "Building systemd image"
	@sudo docker build -f tests/Dockerfile-debian8 -t systemd tests/
	@echo "Run systemd image"
	@docker run --name systemd -v /usr/bin/docker:/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock:ro --tmpfs /run --tmpfs /run/lock -d --privileged=true -v /sys/fs/cgroup:/sys/fs/cgroup:ro systemd
	# Ping docker systemd container
	@docker run -it --link systemd:systemd debian ping systemd -c 5
	@echo "Run ansible test playbook"
	@sudo docker run --link systemd:systemd -it --rm -v ${PWD}:/app/roles/docker-systemd -w /app/roles/docker-systemd/tests kitpages/docker-ansible:${ANSIBLE_VERSION} ansible-playbook test.yml -i inventory
	sleep 10
	@echo "Run final tests"
	goss -g tests/goss.yaml v

clean:
	-@docker kill systemd nginx
	-@docker rm systemd nginx
