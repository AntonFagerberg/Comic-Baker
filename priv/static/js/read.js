(function () {
    window.comicBaker = {};
    var $page = $('#page'),
        $img = $('<img />'),
        pageURLs = [],
        index = 0,
        $rightButton = $('.change-page.right'),
        $leftButton = $('.change-page.left'),
        $pageDisplay = $("#page-number-display");

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
            $img.attr('src', pageURLs[i]);
            $page.append($img);
        }

        $pageDisplay.text('Page ' + (index + 1) + ' of ' + pageURLs.length);

        if (index === 0) {
            $leftButton.css("color", "#444");
        } else if (index == 1) {
            $leftButton.css("color", "#fff");
        }

        if (index === pageURLs.length - 1) {
            $rightButton.css("color", "#444");
        } else if (index ==  pageURLs.length - 2) {
            $rightButton.css("color", "#fff");
        }
    }

    comicBaker.read = function (apiURL) {
      $.ajax(apiURL).then(function (urls) {
        pageURLs = urls;
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