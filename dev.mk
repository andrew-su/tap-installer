dev_dir := $(abspath ./dev)
$(dev_dir):
	mkdir -p $@

dev.namespace.file-prefix := $(dev_dir)/namespace
$(dev.namespace.file-prefix).%: $(kubectl) | $(dev_dir)
	$(kubectl) create namespace $* || true
	@printf '%s' '$*' > $@

dev.secret.file-prefix := $(dev_dir)/secret
$(dev.secret.file-prefix).%: $(tanzu) $(dev.namespace.file-prefix).% $(my.registry.username.file) $(my.registry.password.file)
	$(tanzu) secret registry add registry-credentials --yes \
		--namespace "$$(<'$(dev.namespace.file-prefix).$*')" \
		--server '$(my.registry.hostname)' \
		--username "$$(<'$(my.registry.username.file)')" \
		--password-file '$(my.registry.password.file)'
	@touch $@

dev.create.%: $(kubectl) $(dev.namespace.file-prefix).% $(dev.secret.file-prefix).% config/dev.yaml
	$(kubectl) -n $* apply -f config/dev.yaml
	@printf 'Dev namespace %s created' '$*'

dev.clean:
	rm -rf $(dev_dir)

clean: dev.clean
