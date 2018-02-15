item = ansible
repo = tqxr-$(item)
baseimage = $(repo)/base-$(item)
image = $(repo)/$(item)
basedef = ${PWD}/imagedef/base-$(item)
container = container-$(item)
version = 0.1

force-shutdown:
	docker ps -a | grep '$(image)' | awk '{ print $$1 }' | xargs -n1 docker kill

rebuild: force-shutdown clean clean-base-image install

uninstall: clean force-shutdown clean-base-image
	@echo "Removed."

clean: force-shutdown
	@{                                                                           \
	rm -f /usr/local/bin/$(item) ;                                               \
	DOCKER_IMG=`docker images $(image) --format {{.Repository}}` ;               \
	if [ "$(image)" == "$${DOCKER_IMG}" ] ; then                                 \
		docker rmi $(image) ;                                                      \
	else                                                                         \
		echo "Image '$(image)' not found. No need to clean." ;                     \
	fi                                                                           \
	}

clean-base-image:
	@{ \
	DOCKER_BASE=`docker images $(baseimage) --format {{.Repository}}` ;          \
	if [ "$(baseimage)" == "$$DOCKER_BASE" ] ; then                              \
		docker rmi $(baseimage) ;                                                  \
	else                                                                         \
	 echo "Base image '$(baseimage)' not found. No need to clean." ;             \
	fi                                                                           \
	}

build-base-image:
	@{                                                                           \
	DOCKER_BASE=`docker images $(baseimage) --format {{.Repository}}` ;          \
	if [ "$(baseimage)" != "$$DOCKER_BASE" ] ; then                              \
		cd $(basedef) && docker build --rm --squash -t $(baseimage) . ;            \
	fi                                                                           \
	}

install: build-base-image
	@:

build: install create-command
	@{                                                                           \
	cd ${PWD}/imagedef/$(item) &&                                                \
	docker build -t $(image) --build-arg SOE=$(baseimage) . ;                    \
	}

define RUN_COMMAND
#!/bin/bash
docker run -it --rm                                                            \
-v `pwd`:`pwd` -w `pwd`                                                        \
-v ~/.ssh/id_rsa:/home/ansible/.ssh/id_rsa                                     \
-h $(item).local                                                               \
--env MACUSER=`whoami`                                                         \
$(image) "$$@"
endef

export RUN_COMMAND
create-command:
	@echo "$$RUN_COMMAND" > "/usr/local/bin/${item}"
	@chmod u+x "/usr/local/bin/${item}"

define HELP_TEXT
ANSIBLE CONTAINER

A lightweight (?), up-to-date container for holding
ansible and keeping the underlying system "clean".


endef

help:
	@:
$(info $(HELP_TEXT))
