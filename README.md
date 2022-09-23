# tap-installer

# Prerequisites
* A kubernetes cluster that you want to install to.
* Tanzu CLI.
* Some coffee
* Access to TAP 1.3.0+

# How to use
1. Open `rules.mk` and update the versions you want to install.
1. Create files containing your credentials under the `creds` folder.
    You can choose to either name them the names you see in `rules.mk` or you can update `rules.mk` to point to your credential files.

    **WARNING:** Make sure you don't have extra new lines at the end of your files as it will cause authentication errors.

    The expected files are:
    * `creds/tanzu.registry.username`: Your Tanzu Network username
    * `creds/tanzu.registry.password`: Your Tanzu Network password
    * `creds/my.registry.username`: Your own writable registry's username
    * `creds/my.registry.password`: Your own writable registry's password
1. Install the essentials (kapp-controller and secretgen-controller):
    ```
    make install.essentials
    ```
1. Install TAP:
    ```
    make install.tanzu.secrets
    make install.tanzu.repository
    ```
1. Install the profile:
    ```
    make install.profile.full
    ```
    Right now there's only support for the full profile. Maybe I'll add more later. Additionally to speed this up, I've excluded a lot of packages. Modify `config/full/full.yaml` to re-include what you want. You may need to add the appropriate settings too.
1. Go have a coffee break. This take a while.
1. Install your dev namespace:
    ```
    make dev.create.<namespace_you_want>
    ```

# Run a sample
1. Go to `samples/python-function`
1. From this folder run the following:
    ```
    tanzu apps workload create <your-workload-name> \
      --namespace <your-dev-namespace> \
      -s <location-to-store-your-source-bundle> \
      --local-path . \
      --label "apps.tanzu.vmware.com/workload-type=web"
    ```
1. Profit!
