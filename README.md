# Recursive Packages Script

This script is used to download all dependencies of a list of linux (debian) packages so that they can be uploaded to an offline computer. The script will create a new directory named `packages/`, fetch all dependencies and save the remote URLs to a file in the directory, then download all `.deb` packages to the directory. Examples of usage below:

```
./get_depends.sh g++ gcc
```

```
./get_depends.sh linux-azure linux-base magic
```

On the offline computer, run `sudo dpkg -i *.deb` in the `packages/` directory to install all libraries.
