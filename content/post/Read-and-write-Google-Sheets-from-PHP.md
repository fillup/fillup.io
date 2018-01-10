+++
title = "Read And Write Google Sheets From PHP"
date = 2017-05-30T15:25:37-04:00
draft = false
categories = ["code"]
tags = ["php", "google"]
description = ""
thumbnail = "img/php-google-sheets.png"
+++

This past week I needed to be able to read some data from a Google Sheet and then update a column for each row after processing it. This sort of thing should be simple, Google is built on APIs and has client SDKs for just about every language. I've also integrated with several Google Admin APIs previously so I expected this to be a breeze. I was wrong.

I started out by reading the <a href="https://developers.google.com/sheets/api/quickstart/php" target="_blank" rel="noopener noreferrer">Quickstart for Sheets API with the PHP Client</a>, but almost immediately I could tell it was not written for my use case. It is written for an app that wants to access a sheet on behalf of an end user with a web interface and is able to do the OAuth2 dance. My use case is to use a backend process to function as a service account and batch process data. So the whole API credentials process was wrong for me. I tried all sorts of things with creating a service account, giving it domain wide delegation, adding it via Google Apps Admin interface to allowed API clients to the Sheets scope, but still I was not allowed to read the spreadsheet.

Finally out of a random guess I thought "hmm, the service account credentials I registered in the Google Developer Console for my project has a <em>client_email</em> field, I wonder if I can just share access to the spreadsheet with that email address". Sure enough, that did it! Apparently these credential accounts can be used similarly to normal Google accounts when it comes to sharing access to Google Docs/Sheets/etc.

So for my own documentation sake, assuming I'll forget this in the coming weeks, here is the process to use the PHP Google Client to read/write a Google Sheet.
<ol>
 	<li>Update <em>composer.json</em> to require <em>"google/apiclient": "^2.0"</em> and run <em>composer update</em></li>
 	<li>Create project on <a href="https://console.developers.google.com/apis/dashboard" target="_blank" rel="noopener noreferrer">https://console.developers.google.com/apis/dashboard</a>.</li>
 	<li>Click <em>Enable APIs</em> and enable the Google Sheets API</li>
 	<li>Go to <em>Credentials</em>, then click <em>Create credentials</em>, and select <em>Service account key</em></li>
 	<li>Choose <em>New service account</em> in the drop down. Give the account a name, anything is fine.</li>
 	<li>For <em>Role</em> I selected <em>Project</em> -&gt; <em>Service Account Actor</em></li>
 	<li>For <em>Key type</em>, choose <em>JSON</em> (the default) and download the file. This file contains a private key so be very careful with it, it is your credentials after all</li>
 	<li>Finally, edit the sharing permissions for the spreadsheet you want to access and share either View (if you only want to read the file) or Edit (if you need read/write) access to the <em>client_email</em> address you can find in the JSON file.</li>
</ol>
That should be all the setup needed to authenticate and edit a Google Sheet. Below is some sample code for how to use this in PHP.
{{< highlight php >}}
<?php
require __DIR__ . '/vendor/autoload.php';


/*
 * We need to get a Google_Client object first to handle auth and api calls, etc.
 */
$client = new \Google_Client();
$client->setApplicationName('My PHP App');
$client->setScopes([\Google_Service_Sheets::SPREADSHEETS]);
$client->setAccessType('offline');

/*
 * The JSON auth file can be provided to the Google Client in two ways, one is as a string which is assumed to be the
 * path to the json file. This is a nice way to keep the creds out of the environment.
 *
 * The second option is as an array. For this example I'll pull the JSON from an environment variable, decode it, and
 * pass along.
 */
$jsonAuth = getenv('JSON_AUTH');
$client->setAuthConfig(json_decode($jsonAuth, true));

/*
 * With the Google_Client we can get a Google_Service_Sheets service object to interact with sheets
 */
$sheets = new \Google_Service_Sheets($client);

/*
 * To read data from a sheet we need the spreadsheet ID and the range of data we want to retrieve.
 * Range is defined using A1 notation, see https://developers.google.com/sheets/api/guides/concepts#a1_notation
 */
$data = [];

// The first row contains the column titles, so lets start pulling data from row 2
$currentRow = 2;

// The range of A2:H will get columns A through H and all rows starting from row 2
$spreadsheetId = getenv('SPREADSHEET_ID');
$range = 'A2:H';
$rows = $sheets->spreadsheets_values->get($spreadsheetId, $range, ['majorDimension' => 'ROWS']);
if (isset($rows['values'])) {
    foreach ($rows['values'] as $row) {
        /*
         * If first column is empty, consider it an empty row and skip (this is just for example)
         */
        if (empty($row[0])) {
            break;
        }

        $data[] = [
            'col-a' => $row[0],
            'col-b' => $row[1],
            'col-c' => $row[2],
            'col-d' => $row[3],
            'col-e' => $row[4],
            'col-f' => $row[5],
            'col-g' => $row[6],
            'col-h' => $row[7],
        ];

        /*
         * Now for each row we've seen, lets update the I column with the current date
         */
        $updateRange = 'I'.$currentRow;
        $updateBody = new \Google_Service_Sheets_ValueRange([
            'range' => $updateRange,
            'majorDimension' => 'ROWS',
            'values' => ['values' => date('c')],
        ]);
        $sheets->spreadsheets_values->update(
            $spreadsheetId,
            $updateRange,
            $updateBody,
            ['valueInputOption' => 'USER_ENTERED']
        );

        $currentRow++;
    }
}

print_r($data);
/* Output:
Array
(
    [0] => Array
        (
            [col-a] => 123
            [col-b] => test
            [col-c] => user
            [col-d] => test user
            [col-e] => usertest
            [col-f] => email@domain.com
            [col-g] => yes
            [col-h] => no
        )

    [1] => Array
        (
            [col-a] => 1234
            [col-b] => another
            [col-c] => user
            [col-d] =>
            [col-e] => another
            [col-f] => another@eom.com
            [col-g] => no
            [col-h] => yes
        )

)
 */
{{< /highlight >}}

The output from that example came from the following Google Sheet:
{{< figure src="/img/example-sheet-1024x109.png" >}}

Well, hopefully that'll save someone else some time someday.
