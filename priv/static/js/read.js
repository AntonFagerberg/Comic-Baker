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