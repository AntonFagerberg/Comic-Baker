(function () {
    window.comicBaker = {};
    var $page = $('#page'),
        $img = $('<img />'),
        pageURLs = [],
        index = 0,
        $rightButton = $('#right-button'),
        $leftButton = $('#left-button'),
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
            $leftButton.removeClass('green').addClass('disabled');
        } else if (index == 1) {
            $leftButton.addClass('green').removeClass('disabled');
        }

        if (index === pageURLs.length - 1) {
            $rightButton.removeClass('green').addClass('disabled');
        } else if (index ==  pageURLs.length - 2) {
            $rightButton.addClass('green').removeClass('disabled');
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