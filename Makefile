item = ansible
image = wbit/image-$(item)
container = container-$(item)
version = 0.1

clean:
	rm -f "/usr/local/bin/$(item)"
	if [ "$(image)" == "$$(docker images $(image) --format {{.Repository}})" ] ; then docker rmi $(image) ; fi

install: create-command
	docker build -t $(image) .

define RUN_COMMAND

#!/bin/bash
docker run -it --rm         \
	-v `pwd`:`pwd` -w `pwd`     \
	-h $(image).local  \
	$(image) "$$@"

endef

export RUN_COMMAND

create-command:
	echo "$$RUN_COMMAND" > "/usr/local/bin/${item}"
	chmod u+x "/usr/local/bin/${item}"

