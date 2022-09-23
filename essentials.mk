essentials_dir := $(abspath ./essentials)
$(essentials_dir):
	mkdir -p $@

kapp-controller.$(kapp-controller.version).yaml := https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/$(kapp-controller.version)/release.yml
kapp-controller.latest.yaml := https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
kapp-controller.yaml := $(kapp-controller.$(kapp-controller.version).yaml)
kapp-controller.install := $(essentials_dir)/kapp-controller.$(kapp-controller.version)

$(kapp-controller.install): $(kapp) | $(essentials_dir)
	$(kapp) deploy -y -a kapp-controller -f $(kapp-controller.yaml)
	@touch $@

secretgen-controller.$(secretgen-controller.version).yaml := https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/$(secretgen-controller.version)/release.yml
secretgen-controller.latest.yaml := https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/latest/download/release.yml
secretgen-controller.yaml := $(secretgen-controller.$(secretgen-controller.version).yaml)
secretgen-controller.install := $(essentials_dir)/secretgen-controller.$(secretgen-controller.version)

$(secretgen-controller.install): $(kapp) | $(essentials_dir)
	$(kapp) deploy -y -a secretgen-controller -f $(secretgen-controller.yaml)
	@touch $@


install.essentials: $(kapp-controller.install) $(secretgen-controller.install)

essentials.clean:
	rm -rf $(essentials_dir)
clean: essentials.clean
