// A Javscript Rest-ish interface to the Cloud Recorder Proxy (see recording_controller)
//
// Classes:
//  CloudrecorderManager - an instance that talks to the cloud recorder proxy
//  CloudrecorderRecording - a specific recording on the cloud recorder
//
// URLS:  Proxy URLs on the local server
//    createurl - ex: POST /recording
//    detailurl - EX: GET  /recording/{id}
//  
// SightCall (c) 2015
//

// The UPLOAD URL on the actual cloud-recorder (not the local proxy)
var CLOUDRECORDER_UPLOAD_URL = "https://recording.sightcall.com/api/recordings/upload";


var CloudrecorderRecording = function(jdata) {

  // extract fields from the json data returned from the cloud recorder
  var that = this;

  this.id = jdata.id;
  this.upload_key = jdata.upload_key;
  this.upload_url = CLOUDRECORDER_UPLOAD_URL + "/" + jdata.upload_key;

  // update a cloud recording with new data - usually from polling GET
  function update(jdata) {
    that.status= jdata.status;
    that.webm_duration = jdata.webm_duration;
    that.webm_s3url = jdata.webm_s3url;
    that.mp4_duration = jdata.mp4_duration;
    that.mp4_s3url = jdata.mp4_s3url;
    that.vb_mediaid = jdata.vb_mediaid;
    that.vb_fileurl = jdata.vb_fileurl;
  }

  // exports
  this.update = update;
  
}

var CloudrecorderManager = function(createurl, detailurl) {

  // set some defaults
  var that = this;

  // Override this after instantiation if desired
  this.debug = true;

  // createurl - the cloud recorder 'create' method on the proxy server
  // detailurl - the cloud recoder 'get ID' method on the proxy server

  function create(title, success, failure) {
    if (that.debug == true) {
      console.log(["CloudrecorderManager: POST"]);
    }
    $.ajax({
      type: "POST",
      url: createurl,
      data: { "title" : title },
      cache: false,
      dataType: "JSON"
    }).success(function(jdata) {
      if (that.debug == true) {
        console.log(["CloudrecorderManager: create", jdata]);
      }

      var error = jdata.error;

      if (error != undefined) {
        alert("Recording Error: " + error);
        err = new Error("CloudrecorderManager Error: " + error)
        failure(err);
      }
     else {
        var recording = new CloudrecorderRecording(jdata);
        success(recording);
      }
    }).error(function(e) {
      if (that.debug == true) {
        console.log(["RtccRecording Error", e]);
      }
    });
  }


  // Get the details of a cloud recording by id
  
  function detail(recording, success, failure) {

    if (that.debug == true) {
      console.log(["CloudrecorderManager: GET"]);
    }

    $.ajax({
      type: "GET",
      url: detailurl,
      data: { "id" : recording.id },
      cache: false,
      dataType: "JSON"
    }).success(function(jdata) {
      if (that.debug == true) {
        console.log(["CloudrecorderManager:detail", jdata]);
      }
      recording.update(jdata);
      success(recording);
    }).error(function(e) {
      if (that.debug == true) {
        console.log(["CloudrecorderManager: detail error", e]);
      }
      failure(e);
    });

  }
    
  // exports
  this.create = create;
  this.detail = detail;
}

  
