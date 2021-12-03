# docker-hadoop

Apache Hadoop in Docker made easy

- [Overview](#overview)
- [Installation](#installation)
- [Running the project](#running-the-project)
- [FAQ](#faq)
- [Additional info](#additional-info)

## Overview

So you probably wanted to dip your toes into Hadoop but got discouraged by its complexity.\
Yeah, me too.

I wanted to run Hadoop in Docker to avoid installing it locally, since a single stray command can send you on a very long journey to fix the installation. Alas, I didn't find a single GitHub repository that is up-to-date and builds on the ARM architecture, so I decided to create my own.

## Installation

You'll need to [install Docker](https://www.docker.com/get-started), obviously.\
Due to some problems with name resolution, you'll also need to add the following line to your `/etc/hosts`:
```
127.0.0.1 datanode datanode1 datanode2 datanode3
```

You're all set!

## Running the project

Once you're done with the setup, clone the repository and decide whether you want to run a cluster with 1 or 3 datanodes (`make 1dn` and `make 3dn`, respectively).

Here's a basic `docker-hadoop` workflow:
1. move your input files to the `input` folder
2. submit your `.jar` to the cluster by running `make submit` in the project's root directory
3. open `localhost:80` and stare in awe at the program output
4. prepare for the next submission by running `make clean`
5. create several GitHub account to bless the project with multiple **☆ Stars** (optional, but recommended)

To make working with the project a little more enjoyable, I created a simple Java project template using Gradle in the `submit` directory. Write your own code, package it by running `gradle jar` in the `submit/project/` folder and repeat the basic workflow - your shiny new `.jar` will become the new target automatically.

Oh, and you can find a prebuilt WordCount binary in `submit/project/MapReduce/build/libs/`, along with a full implementation in `submit/project/MapReduce/src/main/java/mapreduce/`.

Enjoy!

## FAQ

### \# I can't preview / download / upload files in the web GUI!

Edit your `/etc/hosts` as described above.

### \# I ran `make submit` and it crashed with `Output directory hdfs://namenode:9000/output already exists`!

Run `make clean`.

### \# Some inexplicable demonic force possessed my installation!

Ah, a classic. That happens sometimes. Try running `make down` (which will delete the entire Compose container, along with HDFS!) and reinstall with either `make 1dn` or `make 3dn`.

If that didn't work... How about `make nuke`? Beware - it will literally nuke all your Docker images, containers and volumes. Handle with EXTREME caution!

### \# Why aren't you using `image: {name}:{tag}` in `docker-compose.yml`?

It's a temporary workaround for `aarch64` machines; refer to [this issue](https://github.com/docker/compose/issues/8804) for more info.

## Additional info
The project was tested using Docker Desktop 4.2.0 (70708) on macOS 12.0.1 Monterey (arm64).