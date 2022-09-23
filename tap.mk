tap_dir := $(abspath ./tap)
$(tap_dir):
	mkdir -p $@

tap.namespace.file := $(tap_dir)/tap.namespace
$(tap.namespace.file): $(kubectl) | $(tap_dir)
	$(kubectl) create namespace $(tap.namespace) || true
	@printf '%s' '$(tap.namespace)' > $@

packages.migrate := $(tap_dir)/packages.$(tap.version).migrated
packages.source := $(tanzu.registry.hostname)/tanzu-application-platform/tap-packages:$(tap.version)
packages.dest := $(my.registry.hostname)/$(my.registry.packages.repository)/packages
$(packages.migrate): $(imgpkg) | $(tap_dir)
	$(imgpkg) copy -b $(packages.source) --to-repo $(packages.dest)
	@touch $@

install.tanzu.secrets: $(tanzu) $(tap.namespace.file) $(tanzu.registry.username.file) $(tanzu.registry.password.file)
	$(tanzu) secret registry add tap-registry --yes \
		--namespace "$$(<'$(tap.namespace.file)')" \
		--server '$(tanzu.registry.hostname)' \
		--username "$$(<'$(tanzu.registry.username.file)')" \
		--password-file '$(tanzu.registry.password.file)' \
		--export-to-all-namespaces \

# install.tanzu.secrets: $(tanzu) $(tap.namespace.file) $(my.registry.username.file) $(my.registry.password.file)
# 	$(tanzu) secret registry add tap-registry --yes \
# 		--namespace "$$(<'$(tap.namespace.file)')" \
# 		--server '$(my.registry.hostname)' \
# 		--username "$$(<'$(my.registry.username.file)')" \
# 		--password-file '$(my.registry.password.file)' \
# 		--export-to-all-namespaces \

install.tanzu.repository: $(tanzu) $(tap.namespace.file)
	$(tanzu) package repository add tanzu-tap-repository \
		--namespace "$$(<'$(tap.namespace.file)')" \
		--url '$(packages.source)' \

# install.tanzu.repository: $(tanzu) $(tap.namespace.file) $(packages.migrate)
# 	$(tanzu) package repository add tanzu-tap-repository \
# 		--namespace "$$(<'$(tap.namespace.file)')" \
# 		--url '$(packages.dest):$(tap.version)' \

tap.values := $(tap_dir)/tap-values.yaml
tap.profiles.full := config/full/
$(tap.values): $(ytt) $(tap.profiles.$(tap.profile)) $(tap.profiles.$(tap.profile))/* | $(tap_dir)
	$(ytt) -f $(tap.profiles.$(tap.profile)) \
		-v 'registry.server=$(my.registry.hostname)' \
		-v 'registry.repository.build=$(my.registry.build.repository)' \
		-v 'registry.repository.workload=$(my.registry.workload.repository)' \
		-v "registry.username=$$(<$(my.registry.username.file))" \
		-v "registry.password=$$(<$(my.registry.password.file))" \
		-v "tanzunet.username=$$(<$(tanzu.registry.username.file))" \
		-v "tanzunet.password=$$(<$(tanzu.registry.password.file))" > $@

install.profile.full: $(tanzu) $(tap.values) $(tap.namespace.file)
	$(tanzu) package install tap \
    -n "$$(<'$(tap.namespace.file)')" \
    -p 'tap.tanzu.vmware.com' \
    -v '$(tap.version)' \
    --values-file "$(tap.values)"

tap.clean:
	rm -rf $(tap_dir)

clean: tap.clean
