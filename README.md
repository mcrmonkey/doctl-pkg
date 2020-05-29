# doctl-pkg

Downloads the doctl tool and creates packages for installation via yum or apt

**Please note**: This tool is _not_ created, supported and/or endorsed by DigitalOcean. Use at your own risk etc. 


### Why

DigitalOcean distribute the doctl tool in .zip and tar files which need extracting and
putting in to the correct place to run.

This can be a bit of faf when updates are released and existing systems need
to be updated.

Plugging the tools in to a users package manager can help keep things up to
date and ensure an consistent installation environment.

I also didn't want to use snap or brew.


## How

For ease all operations are triggered via a `Makefile`

To avoid adding extra junk to your system this makes use of a docker container with packaging tools installed in to it.

To build the image run the following on your system:

```shell
make build
```

To get the latest doctl and turn it in to a package run the following:

```shell
make go
```

To get an older version of doctl specify the version, like so:

```shell
make VERSION="1.42.0" go
```

The `VERSION` can be specified to get specific versions of doctl.
If the variable is not specified it will default to getting and packaging the latest version of doctl


### Output

The packages will be dropped in to the output directory: `output/doctl/`
packages for debian and redhat bases will be dropped in to the `deb` and `rpm`
directories respectively


## Todo

There are some things to be aware of:

* Due to the format of the changelog being different to what the RPM builder
  tool expects so is not included in the RPM package.
* The Docker image is probably a little larger than it should be due to the
  repo building tools that aren't currently used

