(function () {
    window.comicBaker = {};
    var $page = $('#page'),
        $hidden = $('#hidden'),
        pageURLs = [],
        imgs = [],
        index = 0,
        $rightButton = $('.change-page.right'),
        $leftButton = $('.change-page.left');

    $page.on('swipeleft', function () {
        showPage(++index);
        return false;
    });

    $page.on('swiperight', function () {
        showPage(--index);
        return false;
    });

    $rightButton.click(function () {
        showPage(++index);
        return false;
    });

    $leftButton.click(function () {
        showPage(--index);
        return false;
    });

    function showPage(i) {
        if (i < 0) {
            index = 0;
        } else if (i >= pageURLs.length) {
            index = pageURLs.length - 1;
        } else {
          for (var n = index - 1; n <= index + 2; n++) {
            if (index >= 0 && index < pageURLs.length) {
              if (!imgs[n]) {
                imgs[n] = $('<img />').attr('src', pageURLs[n]);
              }

              if (n == index) {
                $page.empty().append(imgs[n]);
                $.ajax(pageURLs[n].split("/page/").join("/save/"));
              }
            }
          }
        }

        if (index === 0) {
            $leftButton.addClass("disabled");
        } else if (index == 1) {
            $leftButton.removeClass("disabled");
        }

        if (index === pageURLs.length - 1) {
            $rightButton.addClass("disabled");
        } else if (index ==  pageURLs.length - 2) {
            $rightButton.removeClass("disabled");
        }
    }

    comicBaker.read = function (apiURL) {
      $.ajax(apiURL).then(function (response) {
        pageURLs = response.urls;
        index = response.page;
        showPage(index);
      });
    };

    $(document).keydown(function (e) {
        if (e.keyCode == 37) {
            showPage(--index);
            return false;
        } else if (e.keyCode == 39) {
            showPage(++index);
            return false;
        }
    });
})();
