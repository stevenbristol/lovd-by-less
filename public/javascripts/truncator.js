// HTML Truncator for jQuery
// by Henrik Nyh <http://henrik.nyh.se> 2008-02-28.
// Free to modify and redistribute with credit.

(function($) {

  var trailing_whitespace = true;

  $.fn.truncate = function(options) {

    var opts = $.extend({}, $.fn.truncate.defaults, options);
    
    $(this).each(function() {

      var content_length = $.trim(squeeze($(this).text())).length;
      if (content_length <= opts.max_length)
        return;  // bail early if not overlong

      var actual_max_length = opts.max_length - opts.more.length - 3;  // 3 for " ()"    
      var truncated_node = recursivelyTruncate(this, actual_max_length);
      var full_node = $(this);

      truncated_node.insertAfter(full_node);
      // This is an ugly approximation for getting the last block tag:
      // we just pick the last <p> or else the container itself.
      truncated_node.find('p:last').add(truncated_node).eq(0).
        append(' (<a href="#show more content">'+opts.more+'</a>)');

      full_node.hide();
      full_node.find('p:last').add(full_node).eq(0).
        append(' (<a href="#show less content">'+opts.less+'</a>)');

      truncated_node.find('a:last').click(function() {
        truncated_node.hide(); full_node.show(); return false;
      });
      full_node.find('a:last').click(function() {
        truncated_node.show(); full_node.hide(); return false;
      });

    });
  }

  // Note that the "more" link and its wrapping counts towards the max length:
  // so "more" and a max length of 10 might give "123 (more)"
  $.fn.truncate.defaults = {
    max_length: 100,
    more: '... more',
    less: 'less'
  };

  function recursivelyTruncate(node, max_length) {
    return (node.nodeType == 3) ? truncateText(node, max_length) : truncateNode(node, max_length);
  }

  function truncateNode(node, max_length) {
    var node = $(node);
    var new_node = node.clone().html("");
    node.contents().each(function() {
      var remaining_length = max_length - new_node.text().length;
      if (remaining_length == 0) return;
      new_node.append(recursivelyTruncate(this, remaining_length));
    });
    return new_node;
  }

  function truncateText(node, max_length) {
    var text = squeeze(node.data);
    if (trailing_whitespace)  // remove initial whitespace if last text
      text = text.replace(/^ /, '');  // node had trailing whitespace.
    trailing_whitespace = !!text.match(/ $/);
    return text.slice(0, max_length);
  }

  // Collapses a sequence of whitespace into a single space.
  function squeeze(string) {
    return string.replace(/\s+/g, ' ');
  }

})(jQuery);
