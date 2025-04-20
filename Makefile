install:
	sudo apt-get update -y && sudo apt-get upgrade -y &&\
	sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa

install-flutter:
	curl https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.3-stable.tar.xz -o flutter.tar.xz &&\
	tar -xf ~/flutter.tar.xz -C ~/ &&\
	sudo mv flutter /opt/flutter &&\
	echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.bashrc &&\
	source ~/.bashrc	

install-gcp:
	pip install --upgrade pip &&\
		pip install -r requirements-gcp.txt

install-aws:
	pip install --upgrade pip &&\
		pip install -r requirements-aws.txt

install-amazon-linux:
	pip install --upgrade pip &&\
		pip install -r amazon-linux.txt
lint:
	pylint --disable=R,C hello.py

format:
	black *.py

test:
	python -m pytest -vv --cov=hello test_hello.py
