/* functions of WebAudioAPI */
init = function() {
  var dfd = $.Deferred();
  try {
    var AudioContext = new window.AudioContext() || new window.webkitAudioContext();
    dfd.resolve(AudioContext);
    return dfd.promise();
  } catch(e) {
    dfd.reject(e);
    return dfd.promise();
  }
}

loadSound = function(context, url) {
  return new Promise(function(resolve, reject) {
  var request = new XMLHttpRequest();
    request.open('GET', url, true);
    request.responseType = 'arraybuffer';
    request.send();
    request.onload = function() {
      context.decodeAudioData(request.response, function(buffer) {
        resolve(buffer);
      });
    }
  });
}

makeSource = function(context, buffer, analyser) {
  source = context.createBufferSource();
  source.buffer = buffer;
  source.connect(context.destination);
  source.connect(analyser);
  return source;
}

playSound = function(source) {
  source.start(0);
}

stopSound = function(source) {
  source.stop();
}

/* for Hue */
ip   = "192.168.1.100";
user = "newdeveloper";
hue  = new HueController(ip, user);
/* for WebAudioAPI */
context  = null;
source   = null;
buffer   = null;
url      = null;
analyser = null;
getFreq  = null;
mode     = 0;

getFreq = function() {
  data = new Uint8Array(256);
  if(mode===1) analyser.getByteFrequencyData(data);
  var sum = 0;
  for(var i=0;i<256;i++) {
    sum += data[i];
  }
  console.log(sum/256);
  hue.changeBri(1, sum/256);
}

window.onload = function() {
  init()
    .then(function(result) {
      context = result;
      analyser = context.createAnalyser();
      analyser.fftsize = 1024;
      analyser.smoothingTimeContant = 0.9;
    })
    .fail(function(error) {
      console.log(error);
    });
}

$(function() {
  $('.go').click(function() {
    var music = $("select[name='music']").val();
    var url = location.origin + '/music/' + music;
    loadSound(context, url)
      .then(function(buf) {
        buffer = buf;
        source = makeSource(context, buffer, analyser);
        playSound(source);
        mode = 1;
      })
      .catch(function(error) {
        console.log(error);
      });
  });
});

setInterval(getFreq, 1000);
