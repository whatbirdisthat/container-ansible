item = ansible
image = wbit/image-$(item)
baseimage = base-$(item)
basedef = ${PWD}/imagedef/$(baseimage)
container = container-$(item)
version = 0.1

force-shutdown:
	docker ps -a | grep wbit/image-ansible | awk '{ print $$1 }' | xargs -n1 docker kill

rebuild: force-shutdown clean clean-base-image install

clean:
	@rm -f "/usr/local/bin/$(item)"
	@if [ "$(image)" == "$$(docker images $(image) --format {{.Repository}})" ] ; then docker rmi $(image) ; else echo "Image '$(image)' not found. No need to clean." ; fi

clean-base-image:
	@if [ "$(baseimage)" == "$$(docker images $(baseimage) --format {{.Repository}})" ] ; then docker rmi $(baseimage) ; else echo "Base image '$(baseimage)' not found. No need to clean." ; fi

build-base-image:
	@if [ "$(baseimage)" != "$$(docker images $(baseimage) --format {{.Repository}})" ] ; then cd $(basedef) && docker build --rm --squash -t $(baseimage) . ; fi

install: build-base-image create-command
	@cd ${PWD}/imagedef/$(item) && docker build -t $(image) --build-arg SOE=$(baseimage) .

define RUN_COMMAND

#!/bin/bash
docker run -it --rm           \
	-v `pwd`:`pwd` -w `pwd`     \
	-v ~/.ssh/id_rsa:/home/ansible/.ssh/id_rsa \
	-h $(item).local   \
	--env MACUSER=`whoami` \
	$(image) "$$@"

endef

export RUN_COMMAND

create-command:
	@echo "$$RUN_COMMAND" > "/usr/local/bin/${item}"
	@chmod u+x "/usr/local/bin/${item}"


uninstall: clean clean-base-image
	@echo "Removed."

