# MacGyver

_*What Would MacGyver Do?*_

MacGyver is a container image that contains a few key configuration and network utilities that allow the easy setup and troubleshooting of custom networking within OpenShift.

MacGyver was built to provide a method of running tools such as `ethtool` on Red Hat Enterprise Linux CoreOS (RHCOS) systems, as used for worker/compute nodes within OpenShift, by leveraging the default Machine Config Operator method of managing underlying system resources.

Simple examples are available in the `examples` directory.


## Usage

Using the pre-built image available at `quay.io/danhawker/macgyver`

```
$ podman run -v ${pwd}/macgyver.conf:/opt/macgyver/macgyver.conf:Z quay.io/danhawker/macgyver
```

This will mount the provided sample configuration file `macgyver.conf` in the present working dir and apply any configs defined.

Adjust `macgyver.conf` to suit your requirements.

## Configuration

Currently MacGyver only applies network config using `ethtool`.

To define configs you wish to apply, simply adjust the `ETHTOOL_OPTS` variable. MacGyver leverages the same syntax used by the RHEL sysconfig options for ethtool, so provide a semi-colon (;) delimited list of ethtool options/parameters.

For example

```
ETHTOOL_OPTS="-K DEVICE tso on;-K DEVICE gro on;-K DEVICE lro on"
```

Note the use of `DEVICE`, rather than individual NIC name (eg eth0). MacGyver adds an additional var of `MACGYVER_NICS` which is a simple list of NICs to target. 

For example

```
MACGYVER_NICS='eth0 eth1'
```

MacGyver iterates over each NIC in turn, applying each ethtool option. 

## Examples

### `machineconfig-macgyver.yaml`

This is a sample machineconfig resource for applying MacGyver within OpenShift4.

This example has the sample `macgyver.conf` file provided in this repo, embedded within the machineconfig file.

Deploy to your OpenShift cluster as normal using the usual `oc` commands. For example...

```
$ oc apply -f machineconfig-macgyver.yaml
```

To apply a different set of ethtool options, simply create a new `macgyver.conf` file, base64 encode it, and replace the base64 contents of the file in line 14 of the sample.

The example targets the `worker` machine config pool by default. Adjust to suit your environment and/or deployment needs.


