docker_repo:
  pkg.installed:
    - pkgs:
      - yum-utils
      - device-mapper-persistent-data
      - lvm2

  cmd.run:
    - name: dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
    - unless: test -f /etc/yum.repos.d/docker-ce.repo

docker_packages:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    - require:
      - cmd: docker_repo

docker_service:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: docker_packages

docker_compose:
  file.managed:
    - name: /usr/local/bin/docker-compose
    - source: https://github.com/docker/compose/releases/latest/download/docker-compose-{{ grains.kernel }}-{{ grains.arch }}
    - mode: 0755

project_dir:
  file.directory:
    - name: /opt/mephi
    - makedirs: True

html_dir:
  file.directory:
    - name: /opt/mephi/html
    - makedirs: True

docker_compose_file:
  file.managed:
    - name: /opt/mephi/docker-compose.yml
    - source: salt://mephi_stack/files/docker-compose.yml

index_html:
  file.managed:
    - name: /opt/mephi/html/index.html
    - source: salt://mephi_stack/files/index.html

run_compose:
  cmd.run:
    - name: docker-compose up -d
    - cwd: /opt/mephi
    - env:
      - COMPOSE_PROJECT_NAME: mephi
    - unless: docker ps --format "{{.Names}}" | grep mephi