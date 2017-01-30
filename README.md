# Marketo Mobile SDK for PhoneGap

The Marketo Mobile SDK allows integration with Marketo Mobile Engagement (MME).  

## Change Log

v0.7.3 - v0.7.4 (Upcoming)

- Exposed removeDevicePushToken() method
- Notifications are now dismissed from the notification center after tap (Android 4.0)
- Custom large notification icon no longer shows default image (Android 4.0)

v0.7.2
- Fixed bug when using Priority method in Android versions previous to 5.0
- Default sound in Android is now on when user receives a notification
- Android Push Notification text now wrap to make it more readable
- Migrated from HttpClient to HttpURLConnection

v0.7.1
- No longer stacking push notifications
- Catching client protocol exception

v0.7.0

- Supporting Android Version 7.0
- In iOS Using UNNotification to handle push received while app is in foreground with a local notificaiton

v0.6.4

- Exposed method reportAll to immediately send events

v0.6.3

- InApp Notifications display once supported added
- fixed issue with PhoneGap android

v0.6.0

- InApp Notifications

v0.5.0

- All features available from MME SDK version 0.5.x
- Small bug fixes

## Contributing Code

We accept pull requests! Please raise a merge request.

## Issues

If you encounter issues using or integrating this plugin, please file a support ticket at support.marketo.com

## Marketo PhoneGap Plugin Installation Guide

### Prerequisites
1.  Register an application in Marketo Admin portal, get your application secret key and munchkin id.
2.  Configure Android Push access [learn here](http://docs.marketo.com/display/public/DOCS/Configure+Mobile+App+Android+Push+Access)
3.  Configure iOS Push access [learn here](https://docs.marketo.com/display/public/DOCS/Configure+Mobile+App+iOS+Push+Access)

### Setup Marketo PhoneGap plugin

1.  Install Marketo PhoneGap Plugin using PhoneGap/Cordova CLI: Please follow below steps or ensure you have latest cordova version installed on the system [learn more](https://cordova.apache.org/docs/en/latest/guide/cli/)
2.  Once it’s ready go to your PhoneGap application directory and run following command.

```javascript
cordova plugin add https://github.com/Marketo/PhoneGapPlugin.git --variable APPLICATION_SECRET_KEY="YOUR_APPLICATION_SECRET"
```

### Migrate to newer version

```javascript
// This command will remove existing marketo plugin
cordova plugin remove com.marketo.plugin

// This command will add it again.
cordova plugin add https://github.com/Marketo/PhoneGapPlugin.git --variable APPLICATION_SECRET_KEY="YOUR_APPLICATION_SECRET"
```

This will add Marketo Plugin into your phonegap application.

## Initialize Marketo Framework
1.  After successful installation, you need to initialize Marketo framework.
2.  Open your main js file and Add the following code under “onDeviceReady: function()”.

```javascript
// This method will Initialize the Marketo Framework using Your MunchkinId and secret key
marketo.initialize(
  	function() { console.log("MarketoSDK Init done."); } ,
  	function(error) { console.log("an error occurred:" + error); },
  	'YOUR_MUNCHKIN_ID', 'YOUR_SECRET_KEY'
);

// For session tracking, please add following.
marketo.onStart(
  function(){console.log("onStart.");},
  function(error){console.log("Failed to report onStart." + error);}
);
```
### Initialize Marketo Push Notification :
1.  After Initializing Marketo SDK successfully , you need to setup push notification.
2.  Open your main js file and Add the following code under “onDeviceReady: function()” after marketo.initialize function.

```javascript
// This function will Enable user notifications (will prompt the user to accept push notifications in iOS)
marketo. initializeMarketoPush(
  function() { console.log("Marketo push successfully initialized."); } ,
  function(error) { console.log("an error occurred:" + error); },
  GCM_PROJECT_ID // this is required for Android and will be ignored in iOS
);
```
Note: You can get your GCM Project ID from Google Developer Console https://console.developers.google.com/

### Marketo Associate Lead:
1.  You can create a Marketo Lead by calling associate lead method.

```javascript
  // First create a lead as below
  var lead_obj = {};
  lead_obj[marketo.KEY_FIRST_NAME]= "John";
  lead_obj[marketo.KEY_LAST_NAME]= "Erickson";
  lead_obj[marketo.KEY_EMAIL]= "johnE@marketo.com";
  lead_obj[marketo.KEY_ADDRESS]= "901 Mariners Island Boulevard";
  lead_obj[marketo.KEY_CITY]= "San Mateo";
  lead_obj[marketo.KEY_STATE]= "CA";
  lead_obj[marketo.KEY_COUNTRY]= "USA";
  lead_obj[marketo.KEY_POSTAL_CODE]= "94404";
  lead_obj[marketo.KEY_GENDER]= "Male";

  // Use associate function to associate it.
  marketo.associateLead(
    function() {
      console.log("MarketoSDK : Lead Associated");
    },
    function(error) {
      console.log("an error occurred:" + error);
    },
    JSON.stringify(lead_obj)
  );
```

### Marketo Report Action:
1.  You can report any user performed action by calling the reportaction method.

```javascript
  // First create an event as below
  var event = {
    "Action Type":"Add To Cart",
    "Action Details":"Adding Product in cart",
    "Action Metric":"10",
    "Action Length":"1"
  }

  marketo.reportaction(
    function(){console.log("Reported Action Successfully.");},
    function(error){console.log("Failed to report Action." + error);},
    "Add To Cart",
    JSON.stringify(event)
  );
```

###Marketo Report All Actions:
1.  You can report any user performed action by calling the reportaction method.

```javascript
  marketo.reportAll(
    function(){console.log("Reported All Actions Successfully.");},
    function(error){console.log("Failed to report Actions." + error);}
  );
```

### Marketo session reporting
1.  Bind pause and resume events as show below to report Start and stop to track time spent in mobile application.(Note this is required in android)
.
```javascript
  //Add the following code in your www/js/index.js

  bindEvents: function() {
     document.addEventListener('deviceready', this.onDeviceReady, false);
     document.addEventListener('pause', this.onStop, false);
     document.addEventListener('resume', this.onStart, false);
  },
  onStop: function() {
     marketo.onStop(
     function(){console.log("onStop");},
     function(error){console.log("Failed to report onStop." + error);});
  },
  onStart: function() {
     marketo.onStart(
     function(){console.log("onStart.");},
     function(error){console.log("Failed to report onStart." + error);});
  },
  ```
