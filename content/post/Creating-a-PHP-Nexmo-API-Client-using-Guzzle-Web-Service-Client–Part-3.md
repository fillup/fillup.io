+++
title = "Creating A PHP Nexmo API Client Using Guzzle Web Service Client – Part 3"
date = 2015-04-09T10:55:16-04:00
draft = false
categories = ["code"]
tags = ["php", "nexmo", "api"]
description = ""
thumbnail = "/img/guzzle-nexmo.png"
+++

<blockquote>
This is Part 3 in a series, you can <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-1.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 1">read Part 1 here</a> or <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-2.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 2">Part 2 here</a>.
</blockquote>

Ok, quick recap: in <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-1.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 1">part 1</a> we explored what API calls to the Nexmo API look like to send an SMS and a few ways we could write them. Then in <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-2.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 2">part 2</a> we built out the ground work for a Guzzle web service client and implemented the Send SMS API with it. Now let's go ahead and add another SMS related API to show how easy it is since we already have the base client and description in place.

Nexmo also has APIs to search for a specific message, multiple messages based on some criteria, as well as for rejected messages. Let's go ahead and add these three interfaces to our SMS description and see what it takes.

Edit src/descriptions/Sms.php and add the following inside operations:
{{< highlight php >}}
        'SearchMessage' => [
            'httpMethod' => 'GET',
            'uri' => '/search/message',
            'responseModel' => 'Result',
            'parameters' => [
                'api_key' => [
                    'required' => true,
                    'type' => 'string',
                    'location' => 'query',
                ],
                'api_secret' => [
                    'required' => true,
                    'type' => 'string',
                    'location' => 'query',
                ],
                'id' => [
                    'required' => true,
                    'type'     => 'string',
                    'location' => 'query',
                ],
            ]
        ]
{{< /highlight >}}
Also, in part 2 I only had one model defined for the response of SendResult, but that name doesn't really make sense for the response of this API, so I just added a generic Result model until I dig in and learn more about how to better use them, add this in models:
{{< highlight php >}}
        'Result' => [
            'type' => 'object',
            'properties' => [
                'statusCode' => ['location' => 'statusCode']
            ],
            'additionalProperties' => [
                'location' => 'json'
            ]
        ]
{{< /highlight >}}

This is where some of the magic starts to shine. We only updated the description file and did not touch our client class, but thats fine, the client is really built dynamically so we just added a new method to it called searchMessage(), just like that.

Quick tip: If you use an IDE like PhpStorm that has autocomplete and type hinting, update the src/Sms.php client class and add a comment about this new method:
{{< highlight php >}}
<?php
/**
 * Nexmo SMS API Client implemented with Guzzle Web Service
 *
 * @method array send(array $config = [])
 * @method array searchMessage(array $config = [])
 */
class Sms extends BaseClient
{{< /highlight >}}

Now we'll test it out. The Search Message API can take a few minutes before data for a given message is available, so we'll have to use a message ID from a previous run of send() to see what it returns (create new file src/examples/search.php):
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
 * api_key, api_secret
 */
$config = include __DIR__.'/../../config-local.php';

/**
 * Get an SMS client object
 */
$sms = new Sms($config);

/**
 * Now let's search for a message
 */
$results = $sms-&gt;searchMessage([
    'id' => '0300000071BCAA3C',
]);

/**
 * Dump out results
 */
print_r($results);
{{< /highlight >}}
Run it:
{{< highlight text >}}
$ php src/examples/search.php
Array
(
    [statusCode] => 200
    [message-id] => 0300000071BCAA3C
    [account-id] => f1632862
    [network] => US-VOIP
    [from] => 17045551234
    [to] => 14085559876
    [body] => Example text[Nexmo DEMO]
    [price] => 0.00480000
    [date-received] => 2015-04-09 01:40:12
    [status] => ACCEPTD
    [error-code] => 1
    [error-code-label] => Unknown
    [type] => MT
)
{{< /highlight >}}

So that was pretty easy to add support for another API to this client. That is what I love so much about this way of developing clients, I hate writing all the logic for each API call separately and this makes it easy for me to build as needed and tweak as needed. While we're updating the description file let's go ahead and describe Search Messages and Search Rejected as well:
{{< highlight php >}}
        'SearchMessages' => [
            'httpMethod' => 'GET',
            'uri' => '/search/messages',
            'responseModel' => 'Result',
            'parameters' => [
                'api_key' => [
                    'required' => true,
                    'type' => 'string',
                    'location' => 'query',
                ],
                'api_secret' => [
                    'required' => true,
                    'type' => 'string',
                    'location' => 'query',
                ],
                'ids' => [
                    'required' => false,
                    'type'     => 'array',
                    'location' => 'query',
                ],
                'date' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'query'
                ],
                'to' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'query'
                ],
            ]
        ],
        'SearchRejections' => [
            'httpMethod' => 'GET',
            'uri' => '/search/messages',
            'responseModel' => 'Result',
            'parameters' => [
                'api_key' => [
                    'required' => true,
                    'type' => 'string',
                    'location' => 'query',
                ],
                'api_secret' => [
                    'required' => true,
                    'type' => 'string',
                    'location' => 'query',
                ],
                'date' => [
                    'required' => true,
                    'type' => 'string',
                    'location' => 'query'
                ],
                'to' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'query'
                ],
            ]
        ],
{{< /highlight >}}
And again let's add comments to src/Sms.php for code completion:
{{< highlight php >}}
<?php
/**
 * Nexmo SMS API Client implemented with Guzzle Web Service
 *
 * @method array send(array $config = [])
 * @method array searchMessage(array $config = [])
 * @method array searchMessages(array $config = [])
 * @method array searchRejections(array $config = [])
 */
{{< /highlight >}}
Great, our SMS client is complete. Let's move on and create a client for the <a href="https://docs.nexmo.com/index.php/number-insight" title="Number Insights API" target="_blank">Nexmo Number Insights API</a>. Number Insights let's you gather information about a given phone number, like whether it is a mobile or landline, the carrier, etc. It can be very handy for making sure that the phone number a user is giving you is capable of whatever feature you want to use it for (like sending SMS notifications).

First let's create src/descriptions/Insight.php:
{{< highlight php >}}
<?php return [
    'baseUrl' => 'https://rest.nexmo.com',
    'operations' => [
        'Request' => [
            'httpMethod' => 'POST',
            'uri' => '/ni/json',
            'responseModel' => 'Result',
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
                'number' => [
                    'required' => true,
                    'type'     => 'string',
                    'location' => 'json',
                ],
                'features' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'callback' => [
                    'required' => true,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'callback_timeout' => [
                    'required' => false,
                    'type' => 'int',
                    'location' => 'json',
                ],
                'callback_method' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'json',
                ],
                'client_ref' => [
                    'required' => false,
                    'type' => 'string',
                    'location' => 'json',
                ],
            ]
        ],
    ],
    'models' => [
        'Result' => [
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
We also need to create a new client class to segment this API call, so create src/Insight.php:
{{< highlight php >}}
<?php
namespace Nexmo;

use Nexmo\BaseClient;

/**
 * Nexmo Insight API Client implemented with Guzzle Web Service
 *
 * @method array request(array $config = [])
 */
class Insight extends BaseClient
{
    /**
     * @param array $config
     */
    public function __construct(array $config = [])
    {
        // Set description_path.
        $config += [
            'description_path' => __DIR__ . '/descriptions/Insight.php',
        ];
        // Create the Insight client.
        parent::__construct($config);
    }
}
{{< /highlight >}}
This API is a bit harder to test and demo because it requires that they will callback a URL you provide with the information they gather on the phone number. The response you receive from the API will include the request_id though and you can store that to match up again when the callback comes in.

Well, in this part we've completed our SMS client and created at least the requesting portion of the Insight client. Nexmo has several more APIs though that I intend to continue building out, although probably not in individual posts like this. On second thought, now that you know how to build these out perhaps you want to take care of some of them and submit a pull request? Huh? Maybe? Come on, let's embrace open source and all work on this together, I promise it will turn out better if you help me out :-) Well, either way I'll keep working on it so you can <a href="https://github.com/fillup/nexmo" title="GitHub repo for this client" target="_blank">follow the repo on GitHub</a> too.

In Part 4 I'll go over how to test these clients. Let me know if there are other related topics you'd like to see on here too. No promises that I'll have any idea about them, but it's always fun to learn so we can give it a shot.

Links in this article:
<ul>
	<li><a href="https://docs.nexmo.com/index.php/number-insight" title="Nexmo Number Insights API" target="_blank">Nexmo Number Insights API</a></li>
	<li><a href="https://github.com/fillup/nexmo" title="GitHub repo for this client" target="_blank">GitHub Repo for this client</a></li>
	<li><a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-1.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 1">Part 1 of this series</a></li>
	<li><a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-2.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 2">Part 2 of this series</a></li>
</ul>
