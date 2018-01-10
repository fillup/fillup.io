+++
title = "Minor Update To Shipley_Translate_Adapter_Realtime"
date = 2011-01-19T19:52:54-04:00
draft = false
categories = ["code"]
tags = ["code", "php", "Shipley_Translate_Adapter_Realtime", "zend", "framework"]
description = ""
+++

I've been working on refactoring my adapter to prepare for supporting many of the features I discussed in my [previous post]({{< relref "post/realtime-translation-adapter-for-zend-translate.md" >}}). Involved in the refactor was moving code that should be common to any of the realtime translation adapters to a common parent class, Shipley_Translate_Adapter_Realtime. So now the usage is a little different when creating the Zend_Translate object, but the usage within the view remains the same.

Also in this update I've added some Zend_Log support for Zend_Log_Writer_Firebug so that I could easily do some debugging while moving all this code around.

Support for existing translation sources is on its way, and implementation within Shipley_Translate_Realtime_Adapter has started, but I haven't tested it at all yet so I assume it doesn't work. Although my wife and son are at Disneyland for the next few days so I'll probably have some time to get it working by this weekend.

If you would like to try using the adapter, you can either download and run the source available at https://github.com/fillup, or download just the library/Shipley folder and drop it into your existing Zend Framework application.

Add the following to your controller (assuming $logger is an instance of Zend_Log):
{{< highlight php >}}
<?php
$this->view->tl = new Zend_Translate(
    array(
      'adapter' => 'Shipley_Translate_Adapter_Realtime',
      'realtimeTranslator' => 'Shipley_Translate_Adapter_Realtime_Google',
      'apiToken' => 'INSERT_GOOGLE_TRANSLATE_API_TOKEN',
      'debugMode' => true,
      'logger' => $logger,
      'locale' => 'en'
    )
);
?>
{{< /highlight >}}
Then, in your view, add:
{{< highlight php >}}
<?php
    echo $this->tl->translate('ADD_SOME_TEXT_HERE','SOURCE_LOCALE_HERE');
?>
{{< /highlight >}}
Anyway, I'll get back to implementing support for existing translation sources and post again when it is working.
