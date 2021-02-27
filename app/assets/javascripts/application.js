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
//= require popper
//= require bootstrap
//= require infinite-scroll.pkgd.min
//= require_tree .

// 無限スクロール
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

// 未読通知
unread = 0;
var getNotice = function(){
  $.getJSON(
    '/notification',
    function(data) {
      //console.log(data);
      $('.notice_count').text(data.notice? data.notice : "");
      $('.message_count').text(data.message? data.message : "");
      $('.res_count').text(data.res? data.res : "");

      $('.unread_count').text(data.unread? data.unread : "");
      unread_count = data.unread? data.unread : 0
      if(unread < unread_count){
        unread = unread_count
        $('#toast1').toast('show')
      }

      notifyTitle = data.notice + data.message + data.res
      $('title').text(notifyTitle? "(" + notifyTitle + ") チラウラリア" : "チラウラリア");
    }
  );
}

// 言語選択
var setLocaleSelect = function(){
  $("#set_locale_select").change(function(){
    locale = $("#set_locale_select").val();
    $.post("/set_locale", {locale: locale}).done(function() {
        location.reload()
    })
  });
};

$(function(){
  getNotice();
  setInterval(getNotice, 20000);

  setLocaleSelect();
});
