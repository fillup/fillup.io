build:
	hugo

deploy: build
	aws --profile=theshipleys s3 sync ./public/ s3://phillipshipley.com/public/
	aws --profile=theshipleys s3 sync ./public/ s3://fillup.io/public/

server:
	hugo server -D

csinstallhugo:
	curl -LO https://github.com/gohugoio/hugo/releases/download/v0.32.2/hugo_0.32.2_Linux-64bit.tar.gz
	tar -vzxf hugo_0.32.2_Linux-64bit.tar.gz
	chmod a+x hugo

csbuild:
	./hugo
