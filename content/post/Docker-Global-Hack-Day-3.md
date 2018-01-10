+++
title = "Docker Global Hack Day #3"
date = 2015-09-21T14:52:14-04:00
draft = false
categories = ["code"]
tags = ["code", "Docker", "golang"]
description = ""
thumbnail = "img/docker-global-hack-day-3.png"
+++

This year I decided to try to participate in the Global Hack day for Docker. Most of the Docker ecosystem of tools are based on the Go language and I've never worked with Go before.

At work we run a private Docker registry to store some of our Docker images, but unfortunately it does not come with an easy to use interface for browsing the images stored in it or deleting them.

So I thought I'd take a stab at writing a CLI in Go to perform these tasks. I knew that Go was strongly typed and strict, but I really didn't realize how strict it was and how used to a forgiving language like PHP I've gotten. After lots and lots of compile errors due to silly mistakes I managed to hack my way through it and come up with at least a semi-functional client. Right now it can list repositories (images), list tags for a repository, and delete repository layer blobs and manifest for a given tag. It still has a ways to go, but with just six hours or so of work I think its a decent start.

Project is hosted at <a href="https://github.com/fillup/docker-registry-cli" target="_blank">https://github.com/fillup/docker-registry-cli</a> with usage and examples.
