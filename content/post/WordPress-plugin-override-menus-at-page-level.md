+++
title = "WordPress Plugin - Override Menus At Page Level"
date = 2013-09-03T20:53:43-04:00
draft = false
categories = ["code"]
tags = ["php", "wordpress"]
description = ""
+++

Wordpress is pretty awesome, but sometimes it just doesn't do exactly what you want. Thankfully the API is pretty extensible and you can change just about anything you want. Right now I'm working on a site for a department at our organization and for their site they really need to host four sites (sections) in a single install. They would like to have a global navigation element to click between the sections but then they want each section to have its own main navigational menu. Unfortunately not many themes support this and the theme they selected does not. Not really a problem though because we can write a plugin to offer this functionality.

[Menu Override](https://wordpress.org/plugins/menu-override/) - I wrote this plugin in just a couple hours today to solve this problem. It allows me at a page level to choose which predefined wordpress menu should be used on the page. My options are to leave it at the default, inherit from the parent page, or use a specific menu. So my site setup now is that I have the "global nav" as the default, which is used on the site homepage, and then for each section homepage I selected the section appropriate menu. Then for each child page within the section I set them to inherit from the parent. It's working like a champ!

I've just submitted the plugin for review by wordpress to get into the plugin directory, but if you want it before it is available you can clone the repo at https://github.com/fillup/wordpress-menu-override. Just drop the MenuOverride.php file in your wp-content/plugins folder and activate it in the admin console and you're set.
