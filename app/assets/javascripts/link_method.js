(function ($) {
  $(function () {
    "use strict";
    function sendAsAjax(link, method) {
      var href = link.attr('href'),
          csrf_token = $('meta[name=csrf-token]').attr('content'),
          csrf_param = $('meta[name=csrf-param]').attr('content'),
          form = $('<form method="post" action="' + href + '"></form>'),
          metadata_input = '<input name="_method" value="' + method + '" type="hidden">';

      if (csrf_param !== undefined && csrf_token !== undefined) {
        metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden">';
      }

      form.hide().append(metadata_input).appendTo('body');
      form.submit();
    }

    $(document).on('click', '[data-method]', function(event) {
      var link   = $(event.target),
          method = link.data('method');
      sendAsAjax(link, method);
      event.preventDefault();
    });
  });
}(jQuery));
