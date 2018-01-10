+++
title = "Creating A PHP Nexmo API Client Using Guzzle Web Service Client – Part 3.5"
date = 2015-04-12T11:07:56-04:00
draft = false
categories = ["code"]
tags = ["php", "nexmo", "api"]
description = ""
thumbnail = "/img/guzzle-nexmo.png"
+++

<blockquote>
This is a small follow up on <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-3.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 3">Part 3</a> in a series, you can <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-1.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 1">read Part 1 here</a> or <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-2.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 2">Part 2 here</a>.
</blockquote>

In Part 3 of this series we completed API clients for Nexmo's <a href="https://docs.nexmo.com/index.php/sms-api" title="Nexmo SMS API" target="_blank">SMS</a> and <a href="https://docs.nexmo.com/index.php/number-insight" title="Nexmo Number Insight API" target="_blank">Number Insight</a> APIs. Today I implemented the rest of the clients for <a href="https://docs.nexmo.com/index.php/voice-api" title="Nexmo Voice API" target="_blank">Voice</a>, <a href="https://docs.nexmo.com/index.php/verify" title="Nexmo Number Verify API" target="_blank">Number Verify</a>, and <a href="https://docs.nexmo.com/index.php/developer-api" title="Nexmo Developer API" target="_blank">Developer</a> APIs.

As I've hit on several times, using the Guzzle Web Service description way of developing an API client can save a lot of time. It took me a little less than an hour to finish adding support for these three sets of APIs. If I was writing every Guzzle client initialization and call individually it would have taken a lot longer I'm sure.

I also made the library available on Packagist for easy install. So now you can include and use this library in any of your projects with just a few simple steps:

1. <a href="https://getcomposer.org/doc/00-intro.md#installation-linux-unix-osx" title="Install Composer" target="_blank">Install Composer</a>:
{{< highlight text >}}
$ curl -sS https://getcomposer.org/installer | php
{{< /highlight >}}
2. Create/update your composer.json file to have at least:
{{< highlight javascript >}}
{
  "require": {
    "fillup/nexmo": "dev-master"
  }
}
{{< /highlight >}}
3. Have composer install the library:
{{< highlight text >}}
$ composer install
Loading composer repositories with package information
Installing dependencies (including require-dev)
  - Installing psr/log (1.0.0)
    Loading from cache

  - Installing react/promise (v2.2.0)
    Loading from cache

  - Installing guzzlehttp/streams (3.0.0)
    Loading from cache

  - Installing guzzlehttp/ringphp (1.0.7)
    Loading from cache

  - Installing guzzlehttp/guzzle (5.2.0)
    Loading from cache

  - Installing guzzlehttp/log-subscriber (1.0.1)
    Loading from cache

  - Installing guzzlehttp/retry-subscriber (2.0.2)
    Loading from cache

  - Installing guzzlehttp/command (0.7.1)
    Loading from cache

  - Installing guzzlehttp/guzzle-services (0.5.0)
    Loading from cache

  - Installing fillup/nexmo (dev-master 39e829b)
    Cloning 39e829b4c859f5b64d99afec41d05ef49504b795

Writing lock file
Generating autoload files
{{< /highlight >}}
4. Include it in your code and use it (below is found in examples/sms.php):
{{< highlight php >}}
&lt;?php
/**
 * Include Composer autoloader
 */
require_once __DIR__.'/../../vendor/autoload.php';

/**
 * Import Sms client
 */
use Nexmo\Sms;

/**
 * Load config, expecting an array with:
 * api_key, api_secret, to, from, text
 */
$config = include __DIR__.'/../../config-local.php';

/**
 * Get an SMS client object
 */
$sms = new Sms($config);

/**
 * Now lets send a message
 */
$results = $sms->send([
    'from' => $config['from'],
    'to' => $config['to'],
    'text' => $config['text'],
]);

/**
 * Dump out results
 */
print_r($results);
{{< /highlight >}}

The clients available in this library are <code>Nexmo\Developer</code>, <code>Nexmo\Insight</code>, <code>Nexmo\Sms</code>, <code>Nexmo\Verify</code>, and <code>Nexmo\Voice</code>. They cover all of the outbound REST APIs but do not help with the inbound calls that Nexmo makes for certain APIs. I considered writing some kind of client to help there but since every application may handle inbound requests differently and the request would be so simple I probably couldn't add any value there.

Well, thats it for Part 3.5 of this series. In Part 4 we'll start building tests for the client so we can look at a couple strategies for testing API clients.

Links in this article:
<ul>
	<li><a href="https://docs.nexmo.com/" title="Nexmo APIs" target="_blank">Nexmo API (many)</a></li>
	<li><a href="https://packagist.org/" title="Packagist - PHP Packages" target="_blank">Packagist</a></li>
	<li><a href="https://getcomposer.org" title="Composer - Dependency Manager for PHP" target="_blank">Composer</a></li>
	<li><a href="https://github.com/fillup/nexmo" title="GitHub Repo" target="_blank">GitHub Repo for fillup/nexmo</a></li>
</ul>
