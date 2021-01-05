.PHONY: all builder push clean commit
.SECONDARY: stage-6.tgz stage-7.tgz stage-6/.sentinel stage-7/.sentinel

EXT?=tgz

all:     builder
push:    builder
	docker push     innovanon/$<
builder: stage-6.$(EXT) stage-7.$(EXT)
	docker build -t innovanon/$@ $(TEST) .
commit:
	git add .
	git commit -m '[Makefile] commit'
	git pull
	git push

stage-6.$(EXT): stage-6/.sentinel
	cd $(shell dirname $<) && \
	tar acvf ../$@ # --owner=0 --group=0 .
stage-7.$(EXT): stage-7/.sentinel
	cd $(shell dirname $<) && \
	tar acvf ../$@ # --owner=0 --group=0 .

stage-6/.sentinel: $(shell find stage-6 -type f)
	openssl rand -out $@ $(shell echo '2 ^ 10' | bc )
stage-7/.sentinel: $(shell find stage-7 -type f)
	openssl rand -out $@ $(shell echo '2 ^ 10' | bc )

clean:
	rm -vf stage-*.$(EXT) */.sentinel .sentinel

