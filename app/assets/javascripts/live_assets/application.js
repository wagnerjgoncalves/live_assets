window.onload = function () {
  var source = new EventSource('/live_assets/sse');

  source.addEventListener('reloadCSS', function (e) {
    var sheets = document.querySelectorAll("[rel=stylesheet]"),
        forEach = Array.prototype.forEach;

    forEach.call(sheets, function (sheet) {
      var clone = sheet.cloneNode();
      clone.addEventListener('load', function () {
        sheet.parentNode.removeChild(sheet);
      });

      document.head.appendChild(clone);
      document.body.innerHTML += "<br /><span>" + e.data + "</span>";
    });
  });

  source.addEventListener('ping', function (e) {
    document.body.innerHTML += "<br /><span>New ping: " + new Date()  + "</span>";
  });
};
