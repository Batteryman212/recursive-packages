# Recursive Packages Script

This script is used to download all dependencies of a list of linux (debian) packages so that they can be uploaded to an offline computer. The script will create a new directory named `packages/`, fetch all dependencies and save the remote URLs to a file in the directory, then download all `.deb` packages to the directory. Examples of usage below:

```
./get_depends.sh g++ gcc
```

```
./get_depends.sh linux-azure linux-base magic
```

You can then copy/move the `packages/` directory to a storage device, plug in the device to the offline computer, then run `sudo dpkg -i *.deb` in `packages/` in the offline computer to install all libraries.

**Beware: in order to ensure all \*.deb packages are downloaded, this script will delete all \*.deb files in /var/cache/apt/archive. This should be harmless, but save the files somewhere else if you wish to preserve them.**
