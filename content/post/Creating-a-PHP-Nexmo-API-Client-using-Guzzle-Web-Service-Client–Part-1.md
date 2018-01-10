+++
title = "Creating A PHP Nexmo API Client Using Guzzle Web Service Client – Part 1"
date = 2015-04-07T21:00:24-04:00
draft = false
categories = ["code"]
tags = ["php", "nexmo", "api"]
description = ""
thumbnail = "/img/guzzle-nexmo.png"
+++

Phew. That was a long title. Sorry about that, just wanted to try to be clear on what this post (series of posts) is about.

Recently I've had the need to write several API clients to simplify integrating with services like CrashPlan, Smartsheet, Trello, etc. Initially I started writing a client library that used the standard Guzzle features. After writing a couple of them I remembered a talk by Jeremy Lindblom [@jeremeamia](https://twitter.com/jeremeamia) at last years php[tek] conference. He mentioned a descriptive way to write API clients so that you didn't need to write each one from scratch, like I had just done a couple times.

I did some digging around in the [Guzzle Docs](http://docs.guzzlephp.org/en/latest/) but unfortunately they do not cover what may be the most awesome capability of the library: Web Service Clients. So you might be thinking, "what is a Web Service Client and why do you care?" Why not just use the awesome and simple HttpClient features of Guzzle? Well, to put it simply, the Web Service Client capability allows you to basically copy API documentation into an array format and let Guzzle dynamically generate an object for you that has methods for every API you describe. You don't have to write every detail of every request, you can just tell Guzzle what parameters are expected, which are required, where they go, and what method to use and Guzzle takes care of the grunt work.

For this series of posts I'm going to develop a robust yet elegant API client for the Nexmo API. [Nexmo](https://www.nexmo.com/) provides APIs that allow your code to send/receive SMS messages, make/receive phone calls, gain insights into a phone number, and provide user verification services. Today in fact they [announced](http://www.prnewswire.com/news-releases/nexmo-disrupts-consumer-experience-by-enabling-brands-to-engage-consumers-through-chat-applications-300059049.html) a new API coming soon for integrating with chat clients which sounds quite interesting too.

Enough background? Ready for code? Ok, lets dig in.

First off, lets look at what an API call to send an SMS message looks like using just curl (split to multiple lines for easier reading):

{{< highlight text >}}
curl -H 'Content-type: application/json' \
     -d '{"api_key": "apikey", "api_secret": "apisecret", "from": "17045551234", "to": "14085559876", "text": "happy birthday bro"}' \
     -X POST https://rest.nexmo.com/sms/json
{{< /highlight >}}

You have a few options for how to call the API, for this example I put the content into a JSON object and posted it to the API.
Response:

{{< highlight javascript >}}
{
  "message-count": "1",
  "messages": [
    {
      "to": "14085559876",
      "message-id": "0300000071BCAA3C",
      "status": "0",
      "remaining-balance": "15.25680000",
      "message-price": "0.00480000",
      "network": "US-VOIP"
    }
  ]
}
{{< /highlight >}}

Pretty simple actually for just testing the API out. So what if we wanted to interact with it a bit more programmatically and use Guzzle to handle the HTTP requests for us (because working with curl directly is not very fun). Here is an example of how you would make that same call with Guzzle:

{{< highlight php >}}
<?php
use GuzzleHttp\Client;

$client = new Client();
$response = $client->post('https://rest.nexmo.com/sms/json', [
    'headers' => ['Content-type' => 'application/json'],
    'json' => [
        'api_key' => 'apikey',
        'api_secret' => 'apisecret',
        'from' => '17045551234',
        'to' => '14085559876',
        'text' => 'happy birthday bro',
    ],
]);
$results = $response->json();
echo $results['messages'][0]['message-id'];
// 0300000071BCAA3C
{{< /highlight >}}

Well that is definitely nicer and it is easy to see how that could be abstracted to a reusable function for easier reuse. So what if with very little code on your part, not having to interact directly with $client->get or $client->post or others you could get an interface like:

{{< highlight php >}}
<?php
use Nexmo\Sms;

$sms = new Sms([
    'api_key' => 'apikey',
    'api_secret' => 'apisecret',
]);

$results = $sms->send([
    'from' => '17045551234',
    'to' => '14085559876',
    'text' => 'happy birthday bro',
]);

echo $results['messages'][0]['message-id'];
// 0300000071BCAA3C
{{< /highlight >}}

Now that looks like a nice interface to work with. In Part 2 of this series we'll work through exactly how to have such a simple interface and you'll be surprised how little code you actually need to write to do so. I'll try to have Part 2 online in the next day or two. I'll be sure to tweet when the next post is ready so you can follow me on Twitter for updates: [@phillipshipley](https://twitter.com/phillipshipley).

Links in this post:

 - [Nexmo](https://www.nexmo.com/)
 - [Guzzle](http://docs.guzzlephp.org/en/latest/)
 - [Jeremy Lindblom](https://twitter.com/jeremeamia) - Developer of the [AWS PHP SDK](https://aws.amazon.com/sdk-for-php/)
 - [Nexmo Chat API Announcement](http://www.prnewswire.com/news-releases/nexmo-disrupts-consumer-experience-by-enabling-brands-to-engage-consumers-through-chat-applications-300059049.html)
 - [My Twitter Stream](https://twitter.com/phillipshipley)
