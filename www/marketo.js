/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

var marketo = {
  /**
   * Call this method when user wants to initialize marketo application
   * Action name should be
   *
   * @param success the message if successful
   * @param fail the message if the action fails
   * @param secret_key provided by Marketo
   * @param muchkin_id provided by Marketo
   */
    initialize: function (success, fail, muchkin_id, secret_key) {
        return cordova.exec( success, fail,
            "MarketoPlugin",
            "initialize", [muchkin_id, secret_key]);
    },

    /**
     * Call this method when user wants to add support to the push notification
     *
     * @param success the message if successful
     * @param fail the message if the action fails
     * @param project_id represents the applications Google Developers Console's project id
     */
    initializeMarketoPush: function (success, fail, project_id) {
        return cordova.exec( success, fail,
            "MarketoPlugin",
            "initializeMarketoPush", [project_id]);
    },

    /**
     * Call this method when user wants to create a lead.
     *
     * @param success the message if successful
     * @param fail the message if the action fails
     * @param lead_data represents the lead data in Json format
     */
    associateLead: function (success, fail, lead_data) {
        return cordova.exec( success, fail,
            "MarketoPlugin",
            "associateLead", [lead_data]);
    },

    /**
     * Call this method when user wants to log users activity in his application.
     *
     * @param success the message if successful
     * @param fail the message if the action fails
     */
    onStop: function (success, fail) {
        return cordova.exec( success, fail,
            "MarketoPlugin",
            "onStop", []);
    },

    /**
     *  Call this method when user wants to log users activity in his application.
     *
     * @param success the message if successful
     * @param fail the message if the action fails
     */
    onStart: function (success, fail) {
        return cordova.exec( success, fail,
            "MarketoPlugin",
            "onStart", []);
    },

    /**
     * Call this method when user hits the reportAction .
     * Action name should be
     *
     * @param success the message if successful
     * @param fail the message if the action fails
     * @param action represents the action name in string format
     * @param action_metadata represents the actions data in Json format.
     */
    reportaction: function (success, fail, reportAction, action_metadata) {
        return cordova.exec( success, fail,
            "MarketoPlugin",
            "reportaction", [reportAction, action_metadata]);
    },

    /**
     * Call this method when user wants to set the request's timeout
     *
     * @param success the message if successful
     * @param fail the message if the action fails
     * @param timeout represents the time in integer.
     */
    settimeout: function (success, fail, timeout){
      return cordova.exec(success, fail,
        "MarketoPlugin",
        "settimeout", [timeout]);
    }
}
module.exports = marketo;
