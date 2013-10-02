/**
 * vesselab.js
 *  
 * Phonegap VesselAB Instance plugin
 * Copyright (c) Vessel.io 2013
 *
 */
  

var vesselab = {

    // Initialize the Vessel framework
    initialize: function (success, fail, secret_key) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "initialize", [secret_key]);
    },

    /**
     * This method reloads the test data, if its updated.
     */
    reloadTest: function (success, fail) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "reloadTest",[]);
    },  
    
    /**
     * Helper method to notify app is paused
     */
    pause: function (success, fail) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "pause",[]);
    },

    /** Helper method to notify app is resumed
     */
    resume: function (success, fail) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "resume",[]);
    },

    /**
     * This method start the session & starts tracking session time.
     */
    startSession: function (success, fail, session_name) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "startSession",[session_name]);
    },

    /**
     * This method pauses the current session & stops session if any.
     * 
     * @param session_name
     */
    endSession: function (success, fail,session_name) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "endSession",[session_name]);
    },

    /**
     * Call this method when user hits the checkpoint in test variation.
     * Checkpoint name must match with associated AB Test on Platform.
     * 
     * @param checkpoint
     */
    reportCheckpoint: function (success, fail,checkpoint) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "checkPointVisited",[checkpoint]);
    },

    /**
     * This method set ABListener and gives call back when test is loaded or failed.
     * 
     */
    setABListener: function (success, fail) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "setABListener",[]);
    },

    /***
     * Helper method to get value for given key.
     * 
     * @param key
     * @param defaultValue
     * @return value for given key | return default value if key is missing.
     */
    getValue:function(success, fail, key, default_value){
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "getValue",[key, default_value]);
    }
}
module.exports = vesselab;