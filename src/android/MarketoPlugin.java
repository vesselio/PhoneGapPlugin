package com.marketo.plugin;

import android.util.Log;
import java.util.Iterator;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import android.app.Activity;

import com.marketo.Marketo;
import com.marketo.MarketoActionMetaData;
import com.marketo.MarketoLead;
import com.marketo.errors.MktoException;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

/**
 * MarketoPlugin is a CordovaPlugin class which
 * recive all evnets / actions from
 * @author manish
 */
public class MarketoPlugin extends CordovaPlugin {

//Constants for Custom Actions
public static final String KEY_ACTION_TYPE = "Action Type";
public static final String KEY_ACTION_DETAILS = "Action Details";
public static final String KEY_ACTION_METRIC = "Action Metric";
public static final String KEY_ACTION_LENGTH = "Action Length";

//Constants for Associate Lead
public static final String KEY_FIRST_NAME = "firstName";
public static final String KEY_LAST_NAME = "lastName";
public static final String KEY_ADDRESS = "address";
public static final String KEY_CITY = "city";
public static final String KEY_STATE = "state";
public static final String KEY_COUNTRY = "country";
public static final String KEY_POSTAL_CODE = "postalCode";
public static final String KEY_GENDER = "gender";
public static final String KEY_EMAIL = "email";
public static final String KEY_TWITTER = "twitterId";
public static final String KEY_FACEBOOK = "facebookId";
public static final String KEY_LINKEDIN = "linkedinId";
public static final String KEY_LEAD_SOURCE = "leadSource";
public static final String KEY_BIRTHDAY = "dateOfBirth";
public static final String KEY_FACEBOOK_PROFILE_URL = "facebookProfileURL";
public static final String KEY_FACEBOOK_PROFILE_PIC = "facebookPhotoURL";
private CallbackContext callbackContext;
private Activity activityContext;

/*
* execute is a method which will be
* called when some action is been called from cordova
*
* @param action is a action in String
* @param args is a jeson object from the calling statement
* @param _callbackContext is the context of the activity
*/
@Override
public boolean execute(String action, JSONArray args, CallbackContext _callbackContext) throws JSONException {
  try {
    callbackContext = _callbackContext;
    activityContext = this.cordova.getActivity();
    final Marketo marketo = Marketo.getInstance(activityContext);
    Log.d("MarketoSDK", "Action "+action);
    //if action is initialize then it will initialize the marketo SDK
    if ("initialize".equals(action)) {
      final String MUCHKIN_ID = args.optString(0);
      final String SECRET_KEY = args.optString(1);
      this.cordova.getThreadPool().execute(new Runnable() {

        @Override
        public void run() {
          marketo.initializeSDK(MUCHKIN_ID, SECRET_KEY);
          callbackContext.success();
        }
      });
      return true;
      //if action is initializeMarketoPush then it will initialise the application for push notification
    } else if ("initializeMarketoPush".equals(action)) {
      final String PROJECT_ID = args.optString(0);
      this.cordova.getThreadPool().execute(new Runnable() {

        @Override
        public void run() {
            marketo.initializeMarketoPush(PROJECT_ID);
            callbackContext.success();
          }
      });
      return true;
      //if action is associateLead then it will create a Lead for this device.
    } else if ("associateLead".equals(action)) {
      final JSONObject jsonObject =  args.getJSONObject(0);
      this.cordova.getThreadPool().execute(new Runnable() {

        @Override
        public void run() {
          marketo.associateLead(getLead(jsonObject));
          callbackContext.success();
          }
      });
      return true;
      //if action is onStop then it will send the onStop action to MarketoSDK
    } else if ("onStop".equals(action)) {
      this.cordova.getThreadPool().execute(new Runnable() {

        @Override
        public void run() {
              Marketo.onStop(activityContext);
              callbackContext.success();
        }
      });
      return true;
      //if action is onStart then it will send the onStart action to MarketoSDK
    } else if ("onStart".equals(action)) {
      this.cordova.getThreadPool().execute(new Runnable() {

        @Override
        public void run() {
          Marketo.onStart(activityContext);
          callbackContext.success();
        }
      });
      return true;
        //if action is reportaction then it will send the respective action to MarketoSDK
    } else if("reportaction".equals(action)){
      final String REPORT_ACTION = args.optString(0);
      final JSONObject json = args.optJSONObject(1);
      this.cordova.getThreadPool().execute(new Runnable() {

        @Override
        public void run() {
          Marketo.reportAction(REPORT_ACTION, getMetadata(json));
          callbackContext.success();
        }
      });
        return true;
        //if action is settimeout then it will det the default time out to the value from json
    } else if("settimeout".equals(action)){
      final int TIME_OUT = args.optInt(0);
      this.cordova.getThreadPool().execute(new Runnable() {

        @Override
        public void run() {
          Marketo.setNetworkTimeout(TIME_OUT);
          callbackContext.success();
        }
      });
      return true;
    }
    return false;
  } catch(Exception e) {
    e.printStackTrace();
    callbackContext.error(e.getMessage());
    return false;
  }
}

/*
* getMetadata is a method which will create a MarketoActionMetaData object
* out of the JSONObject passed as a parameter
*
* @param JSONObject is a json data of Custom Action
* @return MarketoActionMetaData object created from the json passes
*/
private MarketoActionMetaData getMetadata(JSONObject json) {
  MarketoActionMetaData actionMetaData = new MarketoActionMetaData();
 try {
   Iterator<String> items = json.keys();
   for (Iterator<String> iterator = items; iterator.hasNext(); ) {
     String key = iterator.next();
     String value = json.optString(key);
     switch (key) {
       case KEY_ACTION_TYPE:
         actionMetaData.setActionType(value);
         break;
       case KEY_ACTION_DETAILS:
         actionMetaData.setActionDetails(value);
         break;
       case KEY_ACTION_LENGTH:
         actionMetaData.setActionLength(value);
         break;
       case KEY_ACTION_METRIC:
         actionMetaData.setActionMetric(value);
         break;
     }
   }
 }catch(Exception e){
   e.printStackTrace();
 }
  return actionMetaData;
}

/*
* getLead is a method which will create a MarketoLead object
* out of the JSONObject passed as a parameter
*
* @param JSONObject is a json data related to lead
* @return MarketoLead object created from the json passes
*/

private MarketoLead getLead(JSONObject object) {
    MarketoLead lead = new MarketoLead();
  try {
    @SuppressWarnings("unchecked")
    Iterator<String> items = object.keys();
    for (Iterator<String> iterator = items; iterator.hasNext(); ) {
      String key = iterator.next();
      String value = object.optString(key);
      switch (key) {
        case KEY_FIRST_NAME:
          lead.setFirstName(value);
          break;
        case KEY_LAST_NAME:
          lead.setLastName(value);
          break;
        case KEY_ADDRESS:
          lead.setAddress(value);
          break;
        case KEY_CITY:
          lead.setCity(value);
          break;
        case KEY_STATE:
          lead.setState(value);
          break;
        case KEY_COUNTRY:
          lead.setCountry(value);
          break;
        case KEY_POSTAL_CODE:
          lead.setPostalCode(value);
          break;
        case KEY_GENDER:
          lead.setGender(value);
          break;
        case KEY_EMAIL:
          try {
            lead.setEmail(value);
          } catch (MktoException e) {
            e.printStackTrace();
          }
          break;
        case KEY_TWITTER:
          lead.setTwitterId(value);
          break;
        case KEY_FACEBOOK:
          lead.setFacebookId(value);
          break;
        case KEY_LINKEDIN:
          lead.setLinkedinId(value);
          break;
        case KEY_LEAD_SOURCE:
          lead.setLeadSource(value);
          break;
        case KEY_BIRTHDAY:
          lead.setBirthDay(value);
          break;
        case KEY_FACEBOOK_PROFILE_PIC:
          lead.setFacebookProfilePicURL(value);
          break;
        case KEY_FACEBOOK_PROFILE_URL:
          lead.setFacebookProfileURL(value);
          break;
        default:
          lead.setCustomField(key, value);
          break;
      }
    }
  }catch (Exception e){
    e.printStackTrace();
  }
  return lead;
}
}
