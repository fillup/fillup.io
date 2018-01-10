+++
title = "Creating A PHP Nexmo API Client Using Guzzle Web Service Client – Part 4"
date = 2015-04-14T13:24:48-04:00
draft = false
categories = ["code"]
tags = ["php", "nexmo", "api"]
description = ""
thumbnail = "/img/guzzle-nexmo.png"
+++

<blockquote>
This is Part 4 in a series, you can <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-1.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 1">read Part 1 here</a> or <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-2.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 2">Part 2 here</a> or <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-3.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 3">Part 3 here</a> or <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-3.5.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 3.5">Part 3.5 here</a>.
</blockquote>

At this point in this series we have a complete PHP client for the Nexmo APIs. Hopefully I've been able to teach some good practices and designs in the process of developing it, but I know many of you test-driven-development advocates are probably screaming that I've left out the most important part: testing, and testing early. Well, in order to keep these tutorials focused I've saved the testing to the end, and actually when testing API clients I find it easier to write the tests afterwards, but I'll get into that later.

Testing API clients can be a bit awkward because we generally don't want to call live APIs during testing. So I usually use a couple different methods of testing the client depending on which part of the client I want to test. I'm sure there are more ways and I'd love to hear about them so please share if you have a technique you like.

The first method I like to use is to create mock responses in Guzzle and attach them to my client so that when my client thinks it makes a request it gets back a real response object, but with the data I've provided. The second method is to make real HTTP requests to a mock API service like <a href="https://www.mockable.io/" title="Mockable.io - Create REST and SOAP services which mimic your external providers." target="_blank">https://www.mockable.io</a>. There are pros and cons of each approach so lets go over how to do each of them.

## Setting up Test Environment
Before we can write and run unit tests we need to setup a few things. First thing is update our <code>composer.json</code> file to require <a href="https://phpunit.de/" title="PHPUnit Homepage" target="_blank">phpunit</a> as a dev dependency. So edit <code>composer.json</code> and make sure you have at least:
{{< highlight javascript >}}
{
  "require": {
    "php": ">=5.4.0",
    "guzzlehttp/guzzle": "~5.0",
    "guzzlehttp/guzzle-services": "*",
    "guzzlehttp/retry-subscriber": "*",
    "guzzlehttp/log-subscriber": "*"
  },
  "require-dev": {
    "phpunit/phpunit": "~4.0"
  },
}
{{< /highlight >}}
Now install phpunit by running <code>composer update</code>.

Next create a <code>tests/</code> folder at the same level as <code>src/</code>. We need a configuration to give to our client with the key/secret, so lets just create a simple <code>tests/config-test.php</code> file for our tests to use:
{{< highlight php >}}
&lt;?php return [
    'api_key' => 'abc123',
    'api_secret' => 'zxy098',
];
{{< /highlight >}}

Okay, that should be sufficient for now.

<h2>Using Guzzle mock responses</h2>
Using Guzzle Mock Responses is easy and execute very fast. If you want your tests to complete very quickly, this is the way to go since it does not involve making any actual HTTP requests. Create <code>tests/SmsTest.php</code> with the following contents:
{{< highlight php >}}
&lt;?php
namespace tests;

include __DIR__ . '/../vendor/autoload.php';

use Nexmo\Sms;
use GuzzleHttp\Subscriber\Mock;
use GuzzleHttp\Message\Response;
use GuzzleHttp\Stream\Stream;

class SmsTest extends \PHPUnit_Framework_TestCase
{
    public function testSendSmsMockResponse()
    {
        // Include config file with test data
        $config = include 'config-test.php';

        // Create Mock response
        $mockBody = Stream::factory(json_encode([
            'message-count' => 1,
            'messages' => [
                [
                    'to' => '14085559876',
                    'message-id' => '0300000071BCAA3C',
                    'status' => 0,
                    'remaining-balance' => '15.23280000',
                    'message-price' => '0.00480000',
                    'network' => 'US-VOIP',
                ]
            ]
        ]));
        $mock = new Mock([new Response(200, [], $mockBody)]);

        // Create SMS object with our test config data
        $sms = new Sms($config);

        // Add the mock subscriber to the client.
        $sms->getHttpClient()->getEmitter()->attach($mock);

        // Send a message
        $results = $sms->send([
            'from' => '17045551234',
            'to' => '14085559876',
            'text' => 'test message',
        ]);

        // Make sure results match what we expect
        $this->assertEquals(200,$results['statusCode']);
        $this->assertEquals(1,$results['message-count']);
        $this->assertEquals('14085559876',$results['messages'][0]['to']);
    }
}
{{< /highlight >}}
As you can see in the test above I needed to know the response format in order to set up the mock. Part of the reason I write tests after the API code is so that I can call the api, get the resulting data, scrub sensitive information, and use it to setup my mock so that I can be sure my test data is based on real data structure. I'll also sometimes use the Advanced Rest Client extension for Chrome to run the test and get the data, but either way, the point is having real response data to ensure our tests are accurate.

Now run the test:
{{< highlight text >}}
$ ./vendor/bin/phpunit tests/
PHPUnit 4.6.4 by Sebastian Bergmann and contributors.

.

Time: 83 ms, Memory: 5.50Mb

OK (1 test, 3 assertions)
{{< /highlight >}}
I told you this method was fast right? 83ms is quite nice.

I mentioned that this method of testing does not actually make any HTTP requests out an API. On one hand this is great because it is fast and works even if you are working from the beach without a connection or if you have Time Warner Cable as your ISP and it often feels like you don't have a connection. The down side is you're not actually making any HTTP requests, so how do you know the client is even capable of it or that it formats the request properly and what not?

Well, thats where using a service like mockable.io can come in handy...

<h2>Using a mock API service</h2>

Mockable gives you a unique domain name and the ability to setup APIs and responses. You can select what method it should respond on, what the exact path and query string should be, and select the response code, set response headers, and provide the raw response body. Here is a screenshot of what that looks like:

{{< figure src="/img/mockable-nexmo-send-sms-1024x771.png" title="Screenshot of using Mockable to mock Nexmo API" >}}

Going this route however requires that we provide some override configuration data to our client so that we can change the endpoint url, so lets create another test in our <code>tests/SmsTest.php</code> file that tests using this mock url instead:
{{< highlight php >}}
<?php
//...

class SmsTest extends \PHPUnit_Framework_TestCase
{
    public function testSendSmsMockApi()
    {
        // Include config file with test data
        $config = include 'config-test.php';
        // Override baseUrl
        $config += [
            'description_override' => [
                'baseUrl' => 'https://demo4023939.mockable.io',
                'operations' => [
                    'Send' => [
                        'uri' => '/nexmo/sms/json'
                    ]
                ]
            ]
        ];

        // Create SMS object with our test config data
        $sms = new Sms($config);

        // Send a message
        $results = $sms->send([
            'from' => '17045551234',
            'to' => '14085559876',
            'text' => 'test message',
        ]);

        // Make sure results match what we expect
        $this->assertEquals(200,$results['statusCode']);
        $this->assertEquals(1,$results['message-count']);
        $this->assertEquals('14085559876',$results['messages'][0]['to']);
    }

    //...
{{< /highlight >}}
You'll see in that test we've provided an array of configuration data that should replace what is in the original <code>descriptions/Sms.php</code> file. Now run the tests again:
{{< highlight text >}}
$ ./vendor/bin/phpunit tests/
PHPUnit 4.6.4 by Sebastian Bergmann and contributors.

..

Time: 497 ms, Memory: 5.75Mb

OK (2 tests, 6 assertions)
{{< /highlight >}}
This time it ran two tests, the mock object response and the mock api response. The mock object test earlier took only 83ms, but now adding an actual http request took that up to 497ms. So if you want to test a lot of calls the time can really add up with actual requests. But at least now we know the client can make an actual API call, parse/process the response, and give it back to us the way we expect.

<h2>Wrapping up</h2>
Well, I think that is it for this series (unless I think of things I missed or just other helpful content to add). In <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-1.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 1">Part 1</a> we set the stage for how to make API calls and why a client is helpful. In <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-2.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 2">Part 2</a> we started our client using Guzzle Services and were able to send an SMS with it. In <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-3.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 3">Part 3</a> we showed how using the service description method of client development makes it really easy to add support for more APIs. In <a href="{{< relref "post/Creating-a-PHP-Nexmo-API-Client-using-Guzzle-Web-Service-Client–Part-3.5.md" >}}" title="Creating a PHP Nexmo API Client using Guzzle Web Service Client – Part 3.5">Part 3.5</a> we finished describing all the RESTful APIs Nexmo has to offer (until they release that <a href="https://www.nexmo.com/blog/2015/04/07/introducing-nexmo-chat-app-api-2/" title="Nexmo Chat App API" target="_blank">sweet sounding Chat API</a>). Finally in Part 4 we went over how to test the client.

I hope you've found this tutorial useful and educational. Please send me any feedback you have, whether you want to tell me I've done it all wrong like my team usually does, or if you just have questions or ideas for more posts, holla at me.

Links in this article:
<ul>
	<li><a href="https://www.mockable.io/" title="Mockable.io" target="_blank">Mockable.io</a></li>
	<li><a href="https://phpunit.de/" title="PHPUnit Homepage" target="_blank">PHPUnit</a></li>
	<li><a href="https://www.nexmo.com/blog/2015/04/07/introducing-nexmo-chat-app-api-2/" title="Nexmo Chat App API" target="_blank">Nexmo Chat App API</a></li>
	<li><a href="https://github.com/fillup/nexmo" title="GitHub repo for this library" target="_blank">GitHub repo for this library</a></li>
</ul>

Follow me on Twitter: <a href="https://twitter.com/phillipshipley" title="Follow me on Twitter" target="_blank">@phillipshipley</a>
