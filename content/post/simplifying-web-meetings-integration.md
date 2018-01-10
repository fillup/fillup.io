+++
title = "Simplifying Web Meetings Integration"
date = 2013-02-13T11:41:36-04:00
draft = false
categories = ["code"]
tags = ["php", "webex"]
description = ""
+++

For must of my time working at WebEx I was either support or developing with their APIs. The [WebEx APIs](https://developer.cisco.com/site/webex-developer/web-conferencing/) are used to schedule meetings, create users, gather history information, etc. I can't tell you how many times I wrote new code to do the same things.

So when my current project with Sumilux came about to write integrations for [Cisco WebEx](https://www.webex.com), [GoToMeeting](https://www.gotomeeting.com/), and [BigBlueButton](https://bigbluebutton.org/) APIs we decided to just write one library to integrate with them all. We also knew this would be very helpful for others and decided to write develop it as an open source library.

The library is called Smx\SimpleMeetings. The source and documentation is available on GitHub at https://github.com/fillup/Smx_Simple_Meetings. Our initial plan is to develop adapters for WebEx Meeting Center, Citrix GoToMeeting, and BigBlueButton. We'd like to add more beyond that and we hope that other developers will join the project and contribute adapters as well.

Check out https://github.com/fillup/Smx_Simple_Meetings to learn more about using and contributing and let me know if you have any questions about or suggestions for the library.
