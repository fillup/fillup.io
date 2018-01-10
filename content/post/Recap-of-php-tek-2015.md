+++
title = "Recap Of php[tek] 2015"
date = 2015-05-23T15:18:07-04:00
draft = false
categories = [""]
tags = ["phptek"]
description = ""
thumbnail = "img/php-tek-2015.png"
+++

This was my second php[tek] and I was not disappointed. I've attended other tech conferences but this one seems to have the greatest sense of community. It only makes since that the overall theme of this years conference was Open Source and community in general. There were also a lot of PHP "celebrities" attending and speaking at the conference which was neat to see that while to many of us they are above this sort of thing they were just as engaged and present as us normal folk.

{{< figure src="/img/phptek2015-cards.jpg" >}}
The folks at php[architect] are great at coming up with fun ways to engage participants and this year was no let down. This year we had a murder mystery in the style of Clue to solve with many speakers as suspects and local places as locations.

Of particular interest for me were many different talks around testing. There were talks about mocking dependencies in unit tests, using behat to generate code and tests for you, using phantomjs to speed up functional tests, a slew of tools for testing APIs, and a deep dive into understanding code coverage.

Perhaps one of the most interesting talks I went to was one I did not expect to be so interesting. <a href="https://twitter.com/tjlytle" target="_blank">Tim Lytle</a> gave a presentation titled "Building PHP Daemons and Long Running Processes". I've been developing with PHP for 12 years and that whole time I've always heard you never want to use PHP for long running processes, so I was intrigued by the title. Tim gave a great overview of why you might want to use PHP for writing a daemon and then gave a solid example of how to do it. And his reasoning made sense. The gist of it was if all your other business logic and models exist in PHP and it is the language you're most familiar with, it might just be the best option for a daemon. This makes sense, I wouldn't want to rewrite my models into another language that might be more apt for daemon usage and there are times when cron just isn't right for your situation. Anyway, whether you'd want to do it or not is up to you but I enjoyed learning about the process control features in PHP and how to use them to write robust daemons.

Another key message of the conference was that PHP7 is coming and may be coming sooner than you think. There was a strong emphasis on starting to test it and get involved early in testing and reporting issues. This inspired me to create a <a href="https://registry.hub.docker.com/u/silintl/php7/" target="_blank">docker image for PHP7</a> that I could start testing with right away and share with others to make it easier to test with. So during the "hackathon" (not really a hackathon being only 1.5 hours, but I appreciated their intent to connect open source projects with people interested in learning how to contribute) I was able to create a working docker image for PHP7. I'll write another post focused on that soon to explain how you can and should use it to start testing your apps now.

Finally, it was announced that next years php[tek] will be moved to St. Louis to accommodate the growth the conference has seen in attendance. They also announced php[cruise] for summer 2016. That just sounds awesome, a geek cruise. I recommend you check out <a href="http://tek.phparch.com/">http://tek.phparch.com/</a> and follow them on twitter <a href="https://twitter.com/phparch">@phparch</a> to stay up to date on news from them.

Oops, I almost forgot to thank all the sponsors, without them either the conference wouldn't happen or I wouldn't be able to afford the registration cost. Plus my son would be disappointed if I didn't bring back a bunch of swag for him!

{{< figure src="/img/Hunter-phptek-swag.jpg" >}}
