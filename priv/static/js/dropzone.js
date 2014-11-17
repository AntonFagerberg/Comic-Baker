(function () {
  window.comicBaker = window.comicBaker || {};

  window.comicBaker.dropZone = function (postURL) {
    var dropZone = $('#dropZone'),
        container = $('#dropZoneContainer');

    dropZone.on('dragleave', function (e) {
      container.removeClass('hover');
      e.preventDefault();
      e.stopPropagation();
    });

    dropZone.on('dragover', function (e) {
      container.addClass('hover');
      e.preventDefault();
      e.stopPropagation();
    });

    dropZone.on('drop', function (e) {
      if (e.originalEvent.dataTransfer && e.originalEvent.dataTransfer.files.length) {
        e.preventDefault();
        e.stopPropagation();

        var data = new FormData();

        jQuery.each(e.originalEvent.dataTransfer.files, function(i, file) {
          data.append('files[' + i + ']', file);
        });

        $.ajax({
          url: postURL,
          data: data,
          cache: false,
          contentType: false,
          processData: false,
          type: 'POST'
        }).done(function (redirectURL) {
          window.location = redirectURL;
        });
      }
    });
  };
})();
