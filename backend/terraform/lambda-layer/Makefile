PACKAGE_NAME := anthropic-layer
VERSION := 0.49.0

.PHONY: build clean

build:
#	mkdir -p python
#	python3 -m pip install requests==$(VERSION) -t python
	zip -r ${PACKAGE_NAME}.zip python

clean:
	rm -rf python ${PACKAGE_NAME}.zip