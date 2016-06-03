function show_test_trace() {
  var oReq = new XMLHttpRequest();
  oReq.open("GET", "/api/source_images/50/trace_file", true);
  oReq.responseType = "arraybuffer";

  oReq.onload = function (oEvent) {
    console.log("received trace response");
    var arrayBuffer = oReq.response; // Note: not oReq.responseText
    if (arrayBuffer) {
      var byteArray = new Uint8Array(arrayBuffer);
      console.log(byteArray.byteLength);
      var deflated = pako.inflateRaw(byteArray);
      console.log("deflated size: " + deflated.length);

      var string = new TextDecoder('utf-8').decode(deflated);
      console.log(string.length);
      console.log(string.slice(0, 100));

      var parsed = JSON.parse(string);
      console.log(parsed);
    }
  };

  oReq.send(null);
}
