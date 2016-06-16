# Marketo Mobile SDK for PhoneGap

The Marketo Mobile SDK allows integration with Marketo Mobile Engagement (MME).  

## Change Log

v0.6.0

- InApp Notifications

v0.5.0

- All features available from MME SDK version 0.5.x
- Small bug fixes

## Contributing Code

We accept pull requests! Please raise a merge request.

## Issues

Please contact <developerfeedback@marketo.com> for any issues integrating or using this plugin.

## Marketo PhoneGap Plugin Installation Guide 

### Prerequisites 
1.  Register an application in Marketo Admin portal, get your application secret key and munchkin id.
2.  Configure Android Push access [learn here](https://docs.marketo.com/display/public/DOCS/Configure+Mobile+App+iOS+Push+Access)
3.  Configure iOS Push access [learn here](https://docs.marketo.com/display/public/DOCS/Configure+Mobile+App+iOS+Push+Access)

### Plugin Setup
1.  Install Marketo PhoneGap Plugin using PhoneGap/Cordova CLI: Please follow below steps or ensure you have latest cordova version installed on the system [learn more](https://cordova.apache.org/docs/en/latest/guide/cli/)
2.  Once it’s ready go to your PhoneGap application directory and run following command.

cordova plugin add https://github.com/Marketo/PhoneGapPlugin.git --variable APPLICATION_SECRET_KEY="YOUR_APPLICATION_SECRET"

This will add Marketo Plugin into your phonegap application.

### Initialize Marketo Framework
1.  After successful installation, you need to initialize Marketo framework.
2.  Open your main js file and Add the following code under “onDeviceReady: function()”. 

```javascript
// This method will Initialize the Marketo Framework using Your MunchkinId and secret key
marketo.initialize(
  	function() { console.log("MarketoSDK Init done."); } ,
  	function(error) { console.log("an error occurred:" + error); },
  	'YOUR_MUNCHKIN_ID', 'YOUR_SECRET_KEY'
);
```

