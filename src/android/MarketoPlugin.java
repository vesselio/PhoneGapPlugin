package com.marketo.plugin;

import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.Iterator;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;

import android.app.Activity;

import com.marketo.Marketo;
import com.marketo.MarketoActionMetaData;
import com.marketo.MarketoConfig;
import com.marketo.MarketoLead;
import com.marketo.errors.MktoException;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

public class MarketoPlugin extends CordovaPlugin {
    public static final String KEY_ACTION_TYPE = "Action Type";
    public static final String KEY_ACTION_DETAILS = "Action Details";
    public static final String KEY_ACTION_METRIC = "Action Metric";
    public static final String KEY_ACTION_LENGTH = "Action Length";

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

    public static final String KEY_FOR_NOTIFICATION_ICON = "notification.icon_path";
    private CallbackContext callbackContext;
    private Activity activityContext;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext _callbackContext) throws JSONException {
        try {
            callbackContext = _callbackContext;
            activityContext = this.cordova.getActivity();
            final Marketo marketo = Marketo.getInstance(activityContext);
            Log.d("MarketoSDK", "Action " + action);
            if ("initialize".equals(action)) {
                final String MUCHKIN_ID = args.optString(0);
                final String SECRET_KEY = args.optString(1);
                this.cordova.getThreadPool().execute(new Runnable() {

                    @Override
                    public void run() {
 			marketo.setPhonegapCurrentActivity(activityContext);
                        marketo.initializeSDK(MUCHKIN_ID, SECRET_KEY);
                        callbackContext.success();
                    }
                });
                return true;
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
            } else if ("associateLead".equals(action)) {
                final JSONObject jsonObject = new JSONObject(args.optString(0));
                this.cordova.getThreadPool().execute(new Runnable() {

                    @Override
                    public void run() {
                        marketo.associateLead(getLeaad(jsonObject));
                        callbackContext.success();
                    }
                });
                return true;
            } else if ("onStop".equals(action)) {
                this.cordova.getThreadPool().execute(new Runnable() {

                    @Override
                    public void run() {
                        Marketo.onStop(activityContext);
                        callbackContext.success();
                    }
                });
                return true;
            } else if ("onStart".equals(action)) {
                this.cordova.getThreadPool().execute(new Runnable() {

                    @Override
                    public void run() {
                        Marketo.onStart(activityContext);
                        callbackContext.success();
                    }
                });
                return true;
            } else if ("reportaction".equals(action)) {
                final String REPORT_ACTION = args.optString(0);
                final JSONObject json = new JSONObject(args.optString(1));
                this.cordova.getThreadPool().execute(new Runnable() {

                    @Override
                    public void run() {
                        Marketo.reportAction(REPORT_ACTION, getMetadata(json));
                        callbackContext.success();
                    }
                });
                return true;
            } else if ("removeSecureSignature".equals(action)) {
                this.cordova.getThreadPool().execute(new Runnable() {

                    @Override
                    public void run() {
                        marketo.removeSecureSignature();
                        callbackContext.success();
                    }
                });
                return true;
            } else if ("isSecureModeEnabled".equals(action)) {
                this.cordova.getThreadPool().execute(new Runnable() {

                    @Override
                    public void run() {
                        callbackContext.success(Marketo.isSecureModeEnabled() ? 1 : 0);
                    }
                });
                return true;
            } else if ("setSecureSignature".equals(action)) {
                final String accessKey = args.optString(0);
                final String signature = args.optString(1);
                final String email = args.optString(2);
                final long timestamp = args.optLong(3);
                this.cordova.getThreadPool().execute(new Runnable() {

                    @Override
                    public void run() {
                        MarketoConfig.SecureMode secureMode = new MarketoConfig.SecureMode();
                        secureMode.setAccessKey(accessKey);
                        secureMode.setEmail(email);
                        secureMode.setSignature(signature);
                        secureMode.setTimestamp(timestamp);
                        marketo.setSecureSignature(secureMode);
                        callbackContext.success();
                    }
                });
                return true;
            } else if ("getDeviceId".equals(action)) {
                this.cordova.getThreadPool().execute(new Runnable() {

                    @Override
                    public void run() {
                        callbackContext.success(marketo.getDeviceId());
                    }
                });
                return true;
            } else if ("setNotificationConfig".equals(action)) {
                final Bitmap bitmap = getBitMap(args.optString(0));
                final int id = getResourceID(args.optString(1));
                this.cordova.getThreadPool().execute(new Runnable() {

                    @Override
                    public void run() {
                        MarketoConfig.Notification config = new MarketoConfig.Notification();
                        config.setNotificationLargeIcon(bitmap);
                        config.setNotificationSmallIcon(id);
                        marketo.setNotificationConfig(config);
                        callbackContext.success();
                    }
                });
                return true;
            } else if ("getNotificationConfig".equals(action)) {
                this.cordova.getThreadPool().execute(new Runnable() {

                    @Override
                    public void run() {
                        MarketoConfig.Notification config = marketo.getNotificationConfig();
                        JSONArray object = new JSONArray();
                        object.put(BitMapPath());
                        object.put(getResourseName(config.getNotificationSmallIcon()));
                        callbackContext.success(object);
                    }
                });
                return true;
            } else if ("settimeout".equals(action)) {
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
        } catch (Exception e) {
            e.printStackTrace();
            callbackContext.error(e.getMessage());
            return false;
        }
    }

    public int getResourceID(String resourceName) {
        return activityContext.getResources().getIdentifier(resourceName, "drawable", activityContext.getPackageName());
    }

    public String getResourseName(int resoirceID) {
        return activityContext.getResources().getResourceEntryName(resoirceID);
    }

    public Bitmap getBitMap(String filePath) {
        Bitmap bitmap = null;
        try {
            SharedPreferences settings = activityContext.getSharedPreferences("com.mkt.phonegap", 0);
            SharedPreferences.Editor editor = settings.edit();
            editor.putString(KEY_FOR_NOTIFICATION_ICON, filePath);
            editor.commit();
            AssetManager assetManager = activityContext.getAssets();
            InputStream istr = null;
            istr = assetManager.open(filePath);
            bitmap = BitmapFactory.decodeStream(istr);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            callbackContext.error("Failed to locate asset file");
        } catch (Exception e) {
            e.printStackTrace();
            callbackContext.error(e.getMessage());
        }
        return bitmap;
    }

    public String BitMapPath() {
        String result = null;
        if (activityContext != null) {
            SharedPreferences settings = activityContext.getSharedPreferences("com.mkt.phonegap", 0);
            try {
                result = settings.getString(KEY_FOR_NOTIFICATION_ICON, "");
            } catch (ClassCastException ex) {
            }
        }
        return result;
    }

    private MarketoActionMetaData getMetadata(JSONObject json) {
        MarketoActionMetaData actionMetaData = new MarketoActionMetaData();
        try {
            Iterator<String> items = json.keys();
            for (; items.hasNext(); ) {
                String key = items.next();
                String value = json.optString(key);
                if (key.equals(KEY_ACTION_TYPE)) {
                    actionMetaData.setActionType(value);
                } else if (key.equals(KEY_ACTION_DETAILS)) {
                    actionMetaData.setActionDetails(value);
                } else if (key.equals(KEY_ACTION_LENGTH)) {
                    actionMetaData.setActionLength(value);
                } else if (key.equals(KEY_ACTION_METRIC)) {
                    actionMetaData.setActionMetric(value);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return actionMetaData;
    }

    private MarketoLead getLeaad(JSONObject object) {
        MarketoLead lead = new MarketoLead();
        try {
            @SuppressWarnings("unchecked")
            Iterator<String> items = object.keys();
            for (; items.hasNext(); ) {
                String key = items.next();
                String value = object.optString(key);
                if (key.equals(KEY_FIRST_NAME)) {
                    lead.setFirstName(value);
                } else if (key.equals(KEY_LAST_NAME)) {
                    lead.setLastName(value);
                } else if (key.equals(KEY_ADDRESS)) {
                    lead.setAddress(value);
                } else if (key.equals(KEY_CITY)) {
                    lead.setCity(value);
                } else if (key.equals(KEY_STATE)) {
                    lead.setState(value);
                } else if (key.equals(KEY_COUNTRY)) {
                    lead.setCountry(value);
                } else if (key.equals(KEY_POSTAL_CODE)) {
                    lead.setPostalCode(value);
                } else if (key.equals(KEY_GENDER)) {
                    lead.setGender(value);
                } else if (key.equals(KEY_EMAIL)) {
                    try {
                        lead.setEmail(value);
                    } catch (MktoException e) {
                        e.printStackTrace();
                    }
                } else if (key.equals(KEY_TWITTER)) {
                    lead.setTwitterId(value);
                } else if (key.equals(KEY_FACEBOOK)) {
                    lead.setFacebookId(value);
                } else if (key.equals(KEY_LINKEDIN)) {
                    lead.setLinkedinId(value);
                } else if (key.equals(KEY_LEAD_SOURCE)) {
                    lead.setLeadSource(value);
                } else if (key.equals(KEY_BIRTHDAY)) {
                    lead.setBirthDay(value);
                } else if (key.equals(KEY_FACEBOOK_PROFILE_PIC)) {
                    lead.setFacebookProfilePicURL(value);
                } else if (key.equals(KEY_FACEBOOK_PROFILE_URL)) {
                    lead.setFacebookProfileURL(value);
                } else {
                    lead.setCustomField(key, value);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lead;
    }
}


