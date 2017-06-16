ANSIBLE_VERSION ?= 2.0
ANSIBLE_PLAYBOOK := sudo docker run -it --rm -v ${PWD}:/app/roles/docker-systemd -w /app/roles/docker-systemd/tests kitpages/docker-ansible:${ANSIBLE_VERSION} ansible-playbook

syntax-check:
	@sudo $(ANSIBLE_PLAYBOOK) test.yml -i inventory --syntax-check

test: syntax-check run-test clean

run-test:
	@echo "Building systemd image"
	@sudo docker build -f tests/Dockerfile-debian8 -t systemd tests/
	@docker run --rm --name systemd -d --privileged=true -v /sys/fs/cgroup:/sys/fs/cgroup:ro systemd
	# Ping docker systemd container
	@docker run -it --link systemd:systemd debian ping systemd -c 2
	@sudo $(ANSIBLE_PLAYBOOK) test.yml -i inventory

clean:
	-docker kill systemd
