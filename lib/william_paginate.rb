module ActionView::Helpers::TagHelper
  
  def william_paginate(total_count = (@count || 0), per_page = @per_page, page = (@page || 1), method = :get)
    page = 1 if page < 1
    max = (total_count / (per_page*1.0)).ceil rescue 1
    page = max if page > max
    adjacents = 2
    prev_page = page - 1
    next_page = page + 1
    last_page = (total_count / per_page.to_f).ceil
    lpm1      = last_page - 1

    returning '' do |pgn|
      if last_page > 1
        pgn << %{<div class="pagination">}

        pgn << (page > 1 ? link_to("&laquo; Previous", params.merge(:page => prev_page), {:method => method}) : content_tag(:span, "&laquo; Previous", :class => 'disabled'))
        # not enough pages to bother breaking
        if last_page < 7 + (adjacents * 2)
          1.upto(last_page) { |ctr| pgn << (ctr == page ? content_tag(:span, ctr, :class => 'current') : link_to(ctr, params.merge(:page => ctr), {:method => method})) }

          # enough pages to hide some
        elsif last_page > 5 + (adjacents * 2) 

          # close to beginning, only hide later pages
          if page < 1 + (adjacents * 2)
            1.upto(3 + (adjacents * 2)) { |ctr| pgn << (ctr == page ? content_tag(:span, ctr, :class => 'current') : link_to(ctr, {:page => ctr}, {:method => method})) }
            pgn << "..." + link_to(lpm1, params.merge(:page => lpm1), {:method => method}) + link_to(last_page, params.merge(:page => last_page), {:method => method})

            # in middle, hide some from both sides
          elsif last_page - (adjacents * 2) > page && page > (adjacents * 2)
            pgn << link_to('1', params.merge(:page => 1), {:method => method}) + link_to('2', params.merge(:page => 2), {:method => method}) + "..."
            (page - adjacents).upto(page + adjacents) { |ctr| pgn << (ctr == page ? content_tag(:span, ctr, :class => 'current') : link_to(ctr, params.merge(:page => ctr), {:method => method})) }
            pgn << "..." + link_to(lpm1, params.merge(:page => lpm1), {:method => method}) + link_to(last_page, params.merge(:page => last_page), {:method => method})

            # close to end, only hide early pages
          else
            pgn << link_to('1', params.merge(:page => 1), {:method => method}) + link_to('2', params.merge(:page => 2), {:method => method}) + "..."
            (last_page - (2 + (adjacents * 2))).upto(last_page) { |ctr| pgn << (ctr == page ? content_tag(:span, ctr, :class => 'current') : link_to(ctr, params.merge(:page => ctr), {:method => method})) }
          end
        end
        pgn << (page < last_page ? link_to("Next &raquo;", params.merge(:page => next_page), {:method => method}) : content_tag(:span, "Next &raquo;", :class => 'disabled'))
        if method==:post
          pgn << "<select style=\"width: 50px;\" id=\"leftside_select_for_pager\" class=\"no_border\" onchange=\"var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.value;f.submit();return false;\">"
          1.upto(last_page){|i| pgn << "<option #{'selected="selected" ' if page == i}value=\"#{url_for(params.merge(:page => i))}\">#{i}</option>"}
          pgn << "</select>"
        else
          pgn << "<select style=\"width: 50px;\" id=\"leftside_select_for_pager\" class=\"no_border\" onchange=\"window.location=this.value;\">"
          1.upto(last_page){|i| pgn << "<option #{'selected="selected" ' if page == i}value=\"#{url_for(params.merge(:page => i))}\">#{i}</option>"}
          pgn << "</select>"
        end
        pgn << '</div>'
      end
    end
  end


end