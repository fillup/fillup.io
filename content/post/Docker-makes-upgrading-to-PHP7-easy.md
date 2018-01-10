+++
title = "Docker Makes Upgrading To PHP7 Easy"
date = 2017-04-22T15:13:45-04:00
draft = false
categories = ["code"]
tags = ["php", "Docker"]
description = ""
thumbnail = "img/php7-logo.png"
+++

Last year at <a href="{{< relref "post/Recap-of-php-tek-2015.md" >}}" target="_blank">php[tek] 2015</a> during the hack time I messed around and created a <a href="https://hub.docker.com/r/silintl/php7/" target="_blank">Docker image to run and test PHP7</a>. It was surprisingly easy and I quickly learned that the app I was working on at the time ran fine in PHP7, good deal. So since then I've been awaiting the general availability release of PHP7 to move forward with upgrading my apps.

The main thing holding me back was I just didn't want to maintain an image based on compiling from source. Not that it's a problem, it just didn't feel as clean and simple as using supported packages. Well good news is <a href="https://insights.ubuntu.com/2016/04/20/canonical-unveils-6th-lts-release-of-ubuntu-with-16-04/" target="_blank">Ubuntu 16.04 was released yesterday</a> and with it PHP7 is the new standard version. Today I updated my <a href="https://bitbucket.org/silintl/docker-php7/src/master/Dockerfile?fileviewer=file-view-default" target="_blank">Dockerfile</a> to use 16.04 and just install official packages instead of compile from source. It took about 15 minutes and I was running my unit tests with it, thankfully getting a bunch of nice green check marks too :-)

When I tried to run the app in the browser it just spit out code though, so obviously I missed something. In doing a little searching on the <a href="http://packages.ubuntu.com/xenial/php/" target="_blank">Ubuntu packages list for PHP related packages</a> I found the package libapache2-mod-php. Ok, so I just needed to install the apache module as well, no biggie, and that fixed it right up.

With a functioning base image for running PHP7 apps, it is easy to test each of my applications with it and see if they work and roll out updated images as ready. In the past this process would be really time consuming and manual. I'd have to create a new VM, install and configure all packages, load my app into it and run all the tests, and then work with my operations team to provision new servers in the various environments to repeat. Sure Ansible could help there too, but check out what it takes with Docker:

For the main application I'm working on right now my Dockerfile starts with:

{{< highlight text >}}
FROM silintl/php-web:latest
{{< /highlight >}}

That image is a Ubuntu 14.04 system with PHP 5.5.9, so my application builds on that and adds in its own files and configurations, etc.

Now that I have a php7 image, I change that line to:
{{< highlight text >}}
FROM silintl/php7:latest
{{< /highlight >}}

And done. When I build and run my app it is now on PHP 7.0.4 and I can find out pretty quick if it all works or not by running my automated tests, interacting with the app, etc. And since my application is deployed as a Docker image I just need to push the updated image to my Docker registry and <a href="https://blog.codeship.com/easy-blue-green-deployments-on-amazon-ec2-container-service/" target="_blank">deploy the updated service</a>.

If you're not already using Docker, I highly recommend investing the time to learn it and adapt it in your processes, it's pretty awesome that such a significant upgrade can be done so easily and rolled out in whatever fashion I choose.
