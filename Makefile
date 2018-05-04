
RELEASE = 1480

build:
	docker build --build-arg "TAG=$(RELEASE)" -f Dockerfile --force-rm -t eyedeekay/freenet .

clean:
	docker rm -f freenet; true

run: build clean
	docker run -t -i -d --name freenet \
		--user freenet \
		-p 127.0.0.1:9481:9481 \
		-p 127.0.0.1:8888:8888 \
		--restart always \
		--volume freenet-vol:/var/lib/freenet/ \
		eyedeekay/freenet

follow:
	docker logs -f freenet

deb: build-deb run-deb copy-deb clean-deb

build-deb:
	docker build --build-arg "TAG=$(RELEASE)" -f Dockerfile.debian-package --force-rm -t eyedeekay/freenet-deb .

clean-deb:
	docker rm -f freenet-deb; true

run-deb: build-deb clean-deb
	docker run -t -d --name freenet-deb \
		eyedeekay/freenet-deb

copy-deb:
	docker cp freenet-deb:/var/lib/*.deb .

surf:
	surf -d -a a -c cookies.txt -g -i -p -m 127.0.0.1:8888

control:
	surf -d -a a -c cookies.txt -g -i -p -m 127.0.0.1:9481
