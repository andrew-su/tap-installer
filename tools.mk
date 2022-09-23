bin_dir := $(abspath ./bin)
$(bin_dir):
	mkdir -p $@

os.name := $(shell uname -s | tr A-Z a-z)

ytt := $(bin_dir)/ytt.$(ytt.version).$(os.name)
ytt.$(ytt.version).url := https://github.com/vmware-tanzu/carvel-ytt/releases/download/$(ytt.version)/ytt-$(os.name)-amd64
ytt.latest.url := https://github.com/vmware-tanzu/carvel-ytt/releases/latest/download/ytt-$(os.name)-amd64
ytt.url := $(ytt.$(ytt.version).url)
$(ytt): | $(bin_dir)
	curl -sLo $@ $(ytt.url) && chmod +x $@

kapp := $(bin_dir)/kapp.$(kapp.version).$(os.name)
kapp.$(kapp.version).url := https://github.com/k14s/kapp/releases/download/$(kapp.version)/kapp-$(os.name)-amd64
kapp.latest.url := https://github.com/k14s/kapp/releases/latest/download/kapp-$(os.name)-amd64
kapp.url := $(kapp.$(kapp.version).url)
$(kapp): | $(bin_dir)
	curl -sLo $@ $(kapp.url) && chmod +x $@

imgpkg := $(bin_dir)/imgpkg.$(imgpkg.version).$(os.name)
imgpkg.$(imgpkg.version).url := https://github.com/k14s/imgpkg/releases/download/$(imgpkg.version)/imgpkg-$(os.name)-amd64
imgpkg.latest.url := https://github.com/k14s/imgpkg/releases/latest/download/imgpkg-$(os.name)-amd64
imgpkg.url := $(imgpkg.$(imgpkg.version).url)
$(imgpkg): | $(bin_dir)
	curl -sLo $@ $(imgpkg.url) && chmod +x $@

kubectl := $(bin_dir)/kubectl.$(kubectl.version).$(os.name)
kubectl.$(kubectl.version).url := https://dl.k8s.io/release/$(kubectl.version)/bin/$(os.name)/amd64/kubectl
kubectl.latest.url := https://dl.k8s.io/release/$$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/$(os.name)/amd64/kubectl
kubectl.url := $(kubectl.$(kubectl.version).url)
$(kubectl): | $(bin_dir)
	curl -Lo $@ $(kubectl.url) && chmod +x $@

# TODO: Download specific version of Tanzu CLI.
tanzu := /usr/local/bin/tanzu
$(tanzu):

tools.clean:
	rm -rf $(bin_dir)

clean: tools.clean
