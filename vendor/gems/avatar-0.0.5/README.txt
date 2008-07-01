= avatar

* http://avatar.rubyforge.org

== DESCRIPTION:
Avatar is a collection of Ruby utilities for displaying avatars.

== FEATURES/PROBLEMS:

Avatar currently supports the following sources:
* Gravatar (see http://www.gravatar.com)
* a constant URL (e.g. http://mysite.com/images/default_icon.png)
* parameterized URLs (e.g. http://mysite.com/images/famfamfam/user_#{color}.png)
* file_column (see http://www.kanthak.net/opensource/file_column/)
* chains of sources (e.g. file_column if exists; otherwise default constant URL)

Avatar currently supports the following views:
* ActionView (Rails), through avatar_tag
* AbstractView (any framework), through avatar_url_for

== SYNOPSIS:

in RAILS_ROOT/app/helpers/people_helper.rb
require 'avatar/view/action_view_support'
class PeopleHelper
	include Avatar::View::ActionViewSupport
end  

in RAILS_ROOT/app/views/people/show.html.erb:
<%= avatar_tag(@current_user, :size => 40) %>

== REQUIREMENTS:

* none for basic functionality
* will integrate with ActionView
* will integrate with the file_column Rails plugin

== INSTALL:

* sudo gem install avatar

== LICENSE:

(The MIT License)

Copyright (c) 2008 Universal Presenece, Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.