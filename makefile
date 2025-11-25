.PHONY: build deploy clean

build:
	hugo --minify

deploy: build
	./deploy.sh

clean:
	rm -rf public/

dev:
	hugo server -D