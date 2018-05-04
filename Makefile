
DISPLAY = ":0"
RELEASE = 1480

build:
	docker build --build-arg "TAG=$(RELEASE)" -f Dockerfile --force-rm -t eyedeekay/freenet .

deb: build-deb run-deb copy-deb clean-deb

clean:
	docker rm -f freenet; true

run: clean
	docker run -t -i -d --name freenet \
		-e DISPLAY=$(DISPLAY) \
		-p :9481 \
		-p 127.0.0.1:8888:8888 \
		--restart always \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		eyedeekay/freenet

build-deb:
	docker build --build-arg "TAG=$(RELEASE)" -f Dockerfile.debian-package --force-rm -t eyedeekay/freenet-deb .

clean-deb:
	docker rm -f freenet-deb; true

run-deb: clean-deb
	docker run -t -d --name freenet-deb \
		eyedeekay/freenet-deb

copy-deb:
	docker cp freenet-deb:/var/lib/*.deb .
