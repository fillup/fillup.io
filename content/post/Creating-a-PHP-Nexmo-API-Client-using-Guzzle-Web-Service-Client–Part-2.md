+++
title = "Creating A PHP Nexmo API Client Using Guzzle Web Service Client – Part 2"
date = 2015-04-08T10:43:14-04:00
draft = false
categories = ["code"]
tags = ["php", "nexmo", "api"]
description = ""
thumbnail = "/img/guzzle-nexmo.png"
+++

<blockquote>This is Part 2 in a series, you can <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-1.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 1">read Part 1 here</a>.</blockquote>

In Part 1 of this series we laid a foundation for consuming the Nexmo SMS API and covered a few ways to interact with it. In this part we'll create the actual Guzzle Web Service Client to interact with it to demonstrate how simple it can be.

The first thing we'll do is get our project space ready by creating a folder (these steps assume you're working on a Mac or Linux based system):

{{< highlight text >}}
$ mkdir nexmo
$ cd nexmo/
{{< /highlight >}}

Next thing we need to do is make sure we have <a href="https://getcomposer.org/" title="Get Composer" target="_blank">Composer</a> for installing Guzzle dependencies and make it globally available on the command line:

{{< highlight text >}}
$ curl -sS https://getcomposer.org/installer | php
$ mv composer.phar /usr/local/bin/composer
{{< /highlight >}}

Now let's create a very simple composer.json file that will get the Guzzle libraries we need:

{{< highlight text >}}
$ vi composer.json
{{< /highlight >}}

Insert these contents:

{{< highlight javascript >}}
{
  "require": {
    "guzzlehttp/guzzle": "~5.0",
    "guzzlehttp/guzzle-services": "*",
    "guzzlehttp/retry-subscriber": "*",
    "guzzlehttp/log-subscriber": "*"
  }
}
{{< /highlight >}}

Great, now we've told Composer that we need, so let's install them:

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

  - Installing guzzlehttp/command (0.7.1)
    Loading from cache

  - Installing guzzlehttp/guzzle-services (0.5.0)
    Loading from cache

  - Installing guzzlehttp/retry-subscriber (2.0.2)
    Loading from cache

Writing lock file
Generating autoload files
$
{{< /highlight >}}

So composer got the packages we required as well as any packages they required and put them into the vendor/ folder:

{{< highlight text >}}
$ ls -al vendor/
total 8
drwxr-xr-x  7 phillip  staff  238 Apr  8 19:54 .
drwxr-xr-x  6 phillip  staff  204 Apr  8 19:54 ..
-rw-r--r--  1 phillip  staff  183 Apr  8 19:54 autoload.php
drwxr-xr-x  9 phillip  staff  306 Apr  8 19:54 composer
drwxr-xr-x  9 phillip  staff  306 Apr  8 19:54 guzzlehttp
drwxr-xr-x  3 phillip  staff  102 Apr  8 19:54 psr
drwxr-xr-x  3 phillip  staff  102 Apr  8 19:54 react
{{< /highlight >}}

Ok, at this point we have all the dependencies we need, so we're ready to do our part in writing the description of the API. Because we'll want to share this library with others let's make sure the source is structured well and update our composer.json to be ready to share:

{{< highlight text >}}
$ mkdir src
$ mkdir src/descriptions
$ vi composer.json
{{< /highlight >}}

Update composer.json to look like (update to use your own name and such):

{{< highlight javascript >}}
{
    "name": "fillup/nexmo",
    "description": "Nexmo API client built with Guzzle Web Service descriptions",
    "require": {
        "guzzlehttp/guzzle": "~5.0",
        "guzzlehttp/guzzle-services": "*",
        "guzzlehttp/retry-subscriber": "*",
        "guzzlehttp/log-subscriber": "*"
    },
    "license": "MIT",
    "authors": [
        {
            "name": "Your Name",
            "email": "Your Email"
        }
    ],
    "autoload": {
        "psr-4": {
            "Nexmo\\": "src/"
        }
    }
}
{{< /highlight >}}

Now let's describe the Nexmo SMS API based on <a href="https://docs.nexmo.com/index.php/sms-api/send-message" title="Nexmo SMS API Documentation" target="_blank">the documentation</a>:

{{< highlight text >}}
$ vi src/descriptions/Sms.php
{{< /highlight >}}

As you can see, the description is pretty simple, we just need to enter each API (in this case just Send), all the parameters, whether or not they are required, their data type, and where in the request to put them. In this case they all went into a json body.

{{< highlight php >}}
<?php return [
    'baseUrl' => 'https://rest.nexmo.com',
    'operations' => [
        'Send' => [
            'httpMethod' => 'POST',
            'uri' => '/sms/json',
            'responseModel' => 'SendResult',
            'parameters' => [
                'api_key' => [
                    'required' => true,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'api_secret' => [
                    'required' => true,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'from' => [
                    'required' => true,
                    'type'     => 'string',
                    'location' => 'json',
                ],
                'to' => [
                    'required' => true,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'type' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'text' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'status-report-req' => [
                    'required' => false,
                    'type' => 'int',
                    'location' => 'json',
                ],
                'client-ref' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'network-code' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'vcard' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'vcal' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'ttl' => [
                    'required' => false,
                    'type' => 'int',
                    'location' => 'json',
                ],
                'message-class' => [
                    'required' => false,
                    'type' => 'int',
                    'location' => 'json',
                ],
                'udh' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'body' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'json',
                ],
            ]
        ],
    ],
    'models' => [
        'SendResult' => [
            'type' => 'object',
            'properties' => [
                'statusCode' => ['location' => 'statusCode']
            ],
            'additionalProperties' => [
                'location' => 'json'
            ]
        ]
    ]
];
{{< /highlight >}}

I'm still learning about the models definition, but in this example the response will just be an associative array matching the API response plus the addition of ['statusCode'] which will have the HTTP Status Code that was returned (hopefully 200).

The src/descriptions/Sms.php file just returns an array that describes the API. Now we need to write a basic class that can instantiate the Guzzle Web Service Client with this description to enable the interface we want. To keep the code organized and interfaces clean we'll create a BaseClient that takes care of common tasks and extend it for each API we want to implement a client for:

{{< highlight text >}}
$ vi src/BaseClient.php
{{< /highlight >}}

Contents:

{{< highlight php >}}
<?php
namespace Nexmo;

use GuzzleHttp\Client as HttpClient;
use GuzzleHttp\Command\Guzzle\GuzzleClient;
use GuzzleHttp\Command\Guzzle\Description;
use GuzzleHttp\Subscriber\Retry\RetrySubscriber;

/**
 * Nexmo SMS API Client implemented with Guzzle Web Service
 *
 * @method array send(array $config = [])
 */
class BaseClient extends GuzzleClient
{
    /**
     * @param array $config
     */
    public function __construct(array $config = [])
    {
        // Apply some defaults.
        $config += [
            'max_retries'      => 3,
        ];

        // Create the Smartsheet client.
        parent::__construct(
            $this->getHttpClientFromConfig($config),
            $this->getDescriptionFromConfig($config),
            $config
        );

        // Ensure that the credentials are set.
        $this->applyCredentials($config);

        // Ensure that ApiVersion is set.
        $this->setConfig(
            'defaults/ApiVersion',
            $this->getDescription()->getApiVersion()
        );
    }

    private function getHttpClientFromConfig(array $config)
    {
        // If a client was provided, return it.
        if (isset($config['http_client'])) {
            return $config['http_client'];
        }

        // Create a Guzzle HttpClient.
        $clientOptions = isset($config['http_client_options'])
            ? $config['http_client_options']
            : [];
        $client = new HttpClient($clientOptions);

        // Attach request retry logic.
        $client->getEmitter()->attach(new RetrySubscriber([
            'max' => $config['max_retries'],
            'filter' => RetrySubscriber::createChainFilter([
                RetrySubscriber::createStatusFilter(),
                RetrySubscriber::createCurlFilter(),
            ]),
        ]));

        return $client;
    }

    private function getDescriptionFromConfig(array $config)
    {
        // If a description was provided, return it.
        if (isset($config['description'])) {
            return $config['description'];
        }

        // Load service description data.
        $data = is_readable($config['description_path'])
            ? include $config['description_path']
            : null;

        // Override description from local config if set
        if(isset($config['description_override'])){
            $data = array_merge($data, $config['description_override']);
        }

        return new Description($data);
    }

    private function applyCredentials(array $config)
    {
        // Ensure that the credentials have been provided.
        if (!isset($config['api_key'])) {
            throw new \InvalidArgumentException(
                'You must provide an Api Key.'
            );
        }
        if (!isset($config['api_secret'])) {
            throw new \InvalidArgumentException(
                'You must provide an Api Secret.'
            );
        }

        // Set credentials in default variables so that we don't
        // have to pass them to every method individually
        $this->setConfig(
            'defaults/api_key',
            $config['api_key']
        );
        $this->setConfig(
            'defaults/api_secret',
            $config['api_secret']
        );
    }
}
{{< /highlight >}}

And now let's extend it for an Sms client:

{{< highlight text >}}
$ vi src/Sms.php
{{< /highlight >}}

Contents:

{{< highlight php >}}
<?php
namespace Nexmo;

use Nexmo\BaseClient;

/**
 * Nexmo SMS API Client implemented with Guzzle Web Service
 *
 * @method array send(array $config = [])
 */
class Sms extends BaseClient
{
    /**
     * @param array $config
     */
    public function __construct(array $config = [])
    {
        // Set description_path.
        $config += [
            'description_path' => __DIR__ . '/descriptions/Sms.php',
        ];

        // Create the Smartsheet client.
        parent::__construct(
            $config
        );
    }

}
{{< /highlight >}}

"Wait a minute, I thought you said this was the easy route!" Well, as you can see there is actually a decent amount going on in that class, but it really is quite simple. We have a constructor that accepts a configuration array that must contain at least api_key and api_secret, but in an example by <a href="https://twitter.com/jeremeamia" title="Jeremy's Twitter Stream" target="_blank">Jeremy Lindblom</a> I learned how to make it a bit more robust and support dependency injection of an alternate service description and/or HttpClient, so the methods getHttpClientFromconfig and getDescriptionFromConfig could be removed and a more basic version of their logic put into the constructor, but basically I just copy/paste these few methods into each client I need to write to keep it simple. An importent method in this client is the applyCredentials method. It checks the config for api_key and api_secret and if present it sets them as defaults in the clients requests so they are available when we make individual API calls.

"Again, I thought you said this was an easier way to implement an API client." Relax dude, we'll get to how this method of client development makes life easier a bit later. But just a hint: we did a decent amount of ground work in that client, and for this particular API with a single method of Send it seems like overkill, but most of that work is a one time thing, for each method we want to add we just have to describe it.

Now we have an SMS Client that we can use to make calls to the Nexmo API. To test it out we need to setup a config file to store things like key/secret and other variables for examples and create an example script to actually send a message.

<blockquote>
<strong>Notice</strong> The following examples will require that you've <a href="https://dashboard.nexmo.com/register" title="Nexmo Developer Registration" target="_blank">registered for a Nexmo Developer</a> account and have an api_key, api_secret, and a phone number you can send messages from.
</blockquote>

Create config file:

{{< highlight text >}}
$ vi config-local.php
{{< /highlight >}}

Contents:

{{< highlight text >}}
<?php return [
    'api_key' => '',
    'api_secret' => '',
    'from' => '',
    'to' => '',
    'text' => '',
];
{{< /highlight >}}

And now create the example file:

{{< highlight text >}}
$ vi examples/sms.php
{{< /highlight >}}

Contents:

{{< highlight php >}}
<?php
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
 * Now let's send a message
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

Now run it!

{{< highlight text >}}
$ php src/examples/sms.php
Array
(
    [statusCode] => 200
    [message-count] => 1
    [messages] => Array
        (
            [0] => Array
                (
                    [to] => 14085559876
                    [message-id] => 0300000071BCAA3C
                    [status] => 0
                    [remaining-balance] => 15.23280000
                    [message-price] => 0.00480000
                    [network] => US-VOIP
                )

        )

)
{{< /highlight >}}

There you have it, a working Nexmo SMS client! It doesn't do a whole lot at this point since it only covers one API, but in Part 3 I'll fill it out a bit more to show how easy it is now to add support for additional Nexmo APIs to this library. If you want to grab the source for project it is on github at <a href="https://github.com/fillup/nexmo" title="This code on GitHub" target="_blank">https://github.com/fillup/nexmo</a>

Links in this post:
<ul>
	<li><a href="https://getcomposer.org/" title="Get Composer" target="_blank">Composer</a></li>
	<li><a href="https://docs.nexmo.com/index.php/sms-api/send-message" title="Nexmo SMS API Documentation" target="_blank">Nexmo SMS API Documentation</a></li>
	<li><a href="https://dashboard.nexmo.com/register" title="Nexmo Developer Registration" target="_blank">Nexmo Developer Registration</a></li>
	<li><a href="https://github.com/fillup/nexmo" title="Nexmo library on GitHub" target="_blank">This library on GitHub</a></li>
	<li><a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-1.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 1">Part 1 of this series</a></li>
</ul>
