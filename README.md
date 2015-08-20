Marketo PhoneGap – Plugin

	1.	Initialize Marketo Framework : To make sure that Marketo framework gets initiated on app startup. Add the following code under “onDeviceReady: function()”. Also you can add this code to any of your own functions.

	@Syntax :
    		marketo.initialize(
                       function() { console.log("MarketoSDK Init done."); } ,
                       function(error) { console.log("an error occurred:" + error); },
                       'YOUR_MUNCHKIN_ID', 'YOUR_SECRET_KEY'
                       );

	@ parameters :

	•	Success call back : set of extra instruction to be executed if Marketo framework got initialized successfully.  
	•	Failure call back : set of extra instruction to be executed if Marketo framework got failed to initialize.
	•	MUNCKIN ID : munchkin id which you received from Marketo at time of registration.
	•	SECRET KEY : secret key which you received from Marketo at time of registration.


	1.	Add Lead  : To associate new Lead in Marketo server call this code in any of your own functions.

	@ Syntax :
    		marketo.addlead(function(){console.log("MarketoSDK : Lead Added");},
                                     function(error){ console.log("an error occurred:" + error); },
                                     'Lead_JSON_String'
                                     );

	@ parameters :

	•	Success call back : set of extra instruction to be executed if Marketo framework got initialized successfully.  
	•	Failure call back : set of extra instruction to be executed if Marketo framework got failed to initialize.
	•	Lead Data : Lead data in Json string format ,
		Sample Lead Data (with default attributes , you can add custom fields ):
			 var lead = {
                    				'firstName': 'first name',
                    				'lastName': 'last name',
                    				'address': 'demo address',
                    				'city': 'city',
                    				'state': 'state',
                    				'country': 'country',
                    				'postalCode': 'postalCode',
                    				'gender': 'gender',
                    				'email': 'email',
                    				'twitterId': 'twitterId',
                    				'facebookId': 'facebookId',
                    				'linkedInId': 'linkedInId',
                    				'leadSource': 'leadSource',
                    				'dateOfBirth': 'dateOfBirth',
                    				'facebookProfileURL': 'facebookProfileURL',
                    				'facebookPhotoURL': 'facebookPhotoURL'
             				}

	1.	Report Action  : To report new action to Marketo server call this code in any of your own functions.

	@ Syntax :
    	marketo.reportaction(function(){console.log("MarketoSDK : New event sent ");},
                                 function(error){ console.log("an error occurred:" + error); },
                                 'custome_report_name','custome_report_data'
                                 );

	@ parameters :

	•	Success call back : set of extra instruction to be executed if Marketo framework got initialized successfully.  
	•	Failure call back : set of extra instruction to be executed if Marketo framework got failed to initialize.
	•	Action Name : Action name for the report.
	•	Action Data : report data in Json string format ,
		Sample report Data (with default attributes , you can add custom fields ):
			var event = {
                   				'Action Type':'push',
                    				'Action Details':'event Details',
                    				'Action Metric':'metric',
                    				'Action Length':'length'
            			       }

	1.	Http Time Out  : To change default http timeout in Marketo sdk call this code to any of your own function.

	@ Syntax :

            marketo.settimeout(function(){console.log("MarketoSDK : Timeout Changed");},
                            function(error){ console.log("an error occurred:" + error); }, 10 );

	@ parameters :

	•	Success call back : set of extra instruction to be executed if Marketo framework got initialized successfully.  
	•	Failure call back : set of extra instruction to be executed if Marketo framework got failed to initialize.
	•	Timeout integer value  :  timeout Value in integer.
