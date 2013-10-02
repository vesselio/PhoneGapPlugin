Vessel A/B testing plugin for Phonegap
==============

Welcome to Vessel phonegap plugin. Add this plugin to your project and start A/B Testing your app.

A simple use case would be:

1. Landing Screen A/B test
2. UI labels, colors A/B test
3. app messaging A/B test

Using the plugin
Step 1: Register your application
==============
	1. Login to Vessel Command Center
	2. Add your application get Vessel Secret Key

Step 2: Initlize Vessel A/B plugin.
==============

After adding plugin open your main / index.html file and attach Event listener on "deviceready" method as follows

document.addEventListener("deviceready", onDeviceReady, false);

// Inside onDeviceReady initialize Vessel Plugin
```
function onDeviceReady() {
    // Now safe to use the PhoneGap API

    // Initialize Vessel A/B testing platform. You can simply initialize it once.
    var YOUR_SECRET_KEY = 'YOUR_APP_KEY';
    vesselab.initialize(
            function(){console.log("VesselSDK Init done.");},
            function(error){ console.log("an error occurred:" + error); },
            YOUR_SECRET_KEY
    );
}
```
Step 3: Instruments A/B Tests
==============
Let's assume, you want to A/B Test landing screen then 

//attach Event listener on "deviceready" method as follows
document.addEventListener("deviceready", onDeviceReady, false);

```
function onDeviceReady() {

    // Set Vessel AB listener, in other pages.
    vesselab.setABListener(function(testVariation){

            // Now test is available you can check which variation is looded 
            // and decide 
            console.log("Test is available");
    
        }, function(error){
            console.log("Test is not available");

            // Show default screen 
    });
}

```



To learn more visit http://docs.vessel.io/getting-started/


##Resources:
###[vessel.io](https://vessel.io/)
###[License and Terms](https://www.vessel.io/tos/)
