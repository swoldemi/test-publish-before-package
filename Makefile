.PHONY: build
build: clean
	 go build -v -a -installsuffix cgo -tags netgo -ldflags '-w -extldflags "-static"' main.go

.PHONY: sam-package
sam-package:
	sam package --template-file template.yaml --s3-bucket swoldemi-tmp --output-template-file packaged.yaml

.PHONY: clean
clean:
	rm -f main packaged.yaml profile.out
