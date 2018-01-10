+++
title = "Realtime Translation Adapter For Zend Translate"
date = 2011-01-13T10:06:15-04:00
draft = false
categories = ["code"]
tags = ["code", "php", "Shipley_Translate_Adapter_Realtime", "zend", "framework"]
description = "This gave me an idea about writing a Zend_Translate_Adapter that can do the same when the requested content is not found for the given language in local translation sources."
+++

A couple weeks ago I saw a tweet come across the screen by Derick Rethans (the guy behind xdebug) about how he is translating tweets related to xdebug to better understand what people are saying about it:

{{< tweet 22593378604552192 >}}

This gave me an idea about writing a Zend_Translate_Adapter that can do the same when the requested content is not found for the given language in local translation sources.

We use Zend Framework and `Zend_Translate` a lot on my team at work to localize customer facing applications like our free trial signup flow and our marketing webinars platform. For these applications we of course go through a rigorous translation process and review cycle, so translations from a service like Google or Yahoo would probably never fly, but the concept was intriguing none the less. Plus we could potentially use this to translate some internal tools and applications with very little effort and cost.

After a few days of dinking around in my spare time, I have a first version working. At this point it does not check local sources first, it just goes straight to google for the translation. Unfortunately to do this required that I override the translate() method from Zend_Translate_Adapter in my adapter, `Shipley_Translate_Adapter_Realtime`. My adapter is based on Zend Framework 1.11.2, and I haven't compared `Zend/Translate/Adapter.php` with any other versions to know if my adapter would work there also, but as the adapter develops further I'll be sure to document compatibility. The modification is actually really minor, so perhaps it could be considered for a core patch some day, we'll see.

Longer term, here are some of the features I'm hoping to add:

 - Support checking local sources first, using existing adapters like Tmx
 - On look-up miss, use Google or other service for real-time translate (working now)
 - After translation via external service, store translation to local source file, so that subsequent requests for same text do not invoke api call.
 - Controller to manage recent translations. Since translations from service may not be the best, having the ability to edit source files through your own application would be nice.
 - Implement additional adapters for other translation services.
 - An example for a multi-user application which could support unique API tokens per use to help prevent hitting daily limits of services.

I've posted the source to my github account: https://github.com/fillup, please check it out and suggest any other features you think would be useful. If you're interested in contributing that would be awesome too.
