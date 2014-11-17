/* for Hue */
var ip   = "192.168.1.100";
var user = "newdeveloper";
var hue  = new HueController(ip, user);
/* for dancer.js */
var AUDIO_FILE = null;
var dancer     = null;
var kick       = null;

$(function() {
  dancer = new Dancer();
  kick = dancer.createKick({
    onKick:  function() {
      hue.changeBri(1, 255)
        .then(function(result) {
          console.log('onKick');
          setTimeout(function() {
            hue.changeBri(1, 0)
              .then(function(result) {
                console.log('bri off');
              }).fail(function(err) {
                console.log(err);
              });
          }, 200);
        }).fail(function(err) {
          console.log(err);
        });
    },
    offKick: function() {
      console.log('offKick');
    }
  }).on();

  $('.go').click(function() {
    var music = $("select[name='music']").val();
    var url = '/music/' + music;
    dancer.load({
      src: url,
      codexs: ['mp3']
    });
    dancer.play();
  });
});
