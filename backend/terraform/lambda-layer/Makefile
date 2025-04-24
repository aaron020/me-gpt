PACKAGE_NAME := database-layer
VERSION := 2.0.40

.PHONY: build clean

build:
	mkdir -p python
	python3 -m pip install sqlalchemy==$(VERSION) -t python
	python3 -m pip install mysql-connector-python -t python
	zip -r ${PACKAGE_NAME}.zip python

clean:
	rm -rf python ${PACKAGE_NAME}.zip