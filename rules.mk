$(info loaded rules.mk)
creds_dir := $(abspath ./creds)

imgpkg.version := latest
kapp.version := latest
kubectl.version := latest
ytt.version := latest

kapp-controller.version := latest
secretgen-controller.version := latest

# The values file is prepared for 1.3.0+ so yeah.
tap.version := 1.3.1-build.3
# Only full is supported at the moment.
tap.profile := full
tap.namespace := tap-install

tanzu.registry.hostname := registry.tanzu.vmware.com
tanzu.registry.username.file := $(creds_dir)/tanzu.registry.username
tanzu.registry.password.file := $(creds_dir)/tanzu.registry.password

my.registry.hostname := gcr.io
my.registry.username.file := $(creds_dir)/my.registry.username
my.registry.password.file := $(creds_dir)/my.registry.password
my.registry.packages.repository := suan-vmware/tap
my.registry.build.repository := suan-vmware/build
my.registry.workload.repository := suan-vmware/workload

