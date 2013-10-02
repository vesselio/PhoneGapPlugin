var vesselab = {
    // Initialize the Vessel SDK
    initialize: function (success, fail, secret_key) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "initialize", [secret_key]);
    },

    reloadTest: function (success, fail) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "reloadTest",[]);
    },  
    pause: function (success, fail) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "pause",[]);
    }, 
    resume: function (success, fail) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "resume",[]);
    },
    startSession: function (success, fail, session_name) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "startSession",[session_name]);
    },
    endSession: function (success, fail,session_name) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "endSession",[session_name]);
    },
    reportCheckpoint: function (success, fail,checkpoint) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "checkPointVisited",[checkpoint]);
    },
    setABListener: function (success, fail) {
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "setABListener",[]);
    },
    getValue:function(success, fail, key, default_value){
        return cordova.exec( success, fail,
            "VesselABPlugin",
            "getValue",[key, default_value]);
    }
}
module.exports = vesselab;