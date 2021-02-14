// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require bootstrap-sprockets
//= require infinite-scroll.pkgd.min
//= require_tree .

document.addEventListener("tweet-loaded", function(event) {
  new InfiniteScroll('.tweet-container.infinite_scroll', {
    path: "a.next",
    append: ".tweet",
    history: false,
    prefill: true,
    scrollThreshold: 400,
    loadOnScroll: true,
  })
});

var getNotice = function(){
  $.getJSON(
    '/notification',
    function(data) {
      //console.log(data);
      $('.notice_count').text(data.notice? data.notice : "");
      $('.message_count').text(data.message? data.message : "");
      $('.res_count').text(data.res? data.res : "");

      notifyTitle = data.notice + data.message + data.res
      $('title').text(notifyTitle? "(" + notifyTitle + ") チラウラリア" : "チラウラリア");
    }
  );
}

getNotice();
$(function(){
  setInterval(getNotice, 60000);
});
