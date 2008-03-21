# This software is released under the MIT license
#
# Copyright (c) 2005 Stefan Kaes

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


require 'active_record'
require 'cgi'
require 'cgi/session'
require 'base64'

# +SQLSessionStore+ is a stripped down, optimized for speed version of
# class +ActiveRecordStore+, as it did exist in Rails version
# 0.12. Since then, +ActiveRecordStore+ has undergone many changes,
# not all them for the better.

class SQLSessionStore

  # An ActiveRecord class which corresponds to the database table
  # +sessions+. Functions +find_session+, +create_session+,
  # +update_session+ and +destroy+ constitute the interface to class
  # +SQLSessionStore+.

  class Session < ActiveRecord::Base

    # retrieve session data for a given +session_id+ from the database,
    # return nil if no such session exists
    def self.find_session(session_id)
      find_first("sessid='#{session_id}'")
    end

    # create a new session with given +id+ and +data+
    def self.create_session(session_id, data)
      new(:sessid => session_id, :data => data)
    end

    # update session data and store it in the database
    def update_session(data)
      update_attribute('data', data) 
    end
  end
  
  # The class to be used for creating, retrieving and updating sessions.
  # Defaults to SQLSessionStore::Session, which is derived from +ActiveRecord::Base+.
  #
  # In order to achieve acceptable performance you should implement
  # your own session class, similar to the one provided for Myqsl.
  #
  # Only functions +find_session+, +create_session+,
  # +update_session+ and +destroy+ are required. See file +mysql_session.rb+.

  cattr_accessor :session_class
  @@session_class = SQLSessionStore::Session
  
  # Create a new SQLSessionStore instance.
  #
  # +session+ is the session for which this instance is being created.
  #
  # +option+ is currently ignored as no options are recognized.

  def initialize(session, option=nil)
    if @session = @@session_class.find_session(session.session_id)
      @data = unmarshalize(@session.data)
    else
      @session = @@session_class.create_session(session.session_id, marshalize({}))
      @data = {}
    end
  end
  
  # Update the database and disassociate the session object
  def close
    if @session
      @session.update_session(marshalize(@data))
      @session = nil
    end
  end
  
  # Delete the current session, disassociate and destroy session object
  def delete
    if @session
      @session.destroy
      @session = nil
    end
  end
  
  # Restore session data from the session object
  def restore
    if @session
      @data = unmarshalize(@session.data)
    end
  end
  
  # Save session data in the session object
  def update
    if @session
      @session.update_session(marshalize(@data))
    end
  end
  
  private
  def unmarshalize(data)
    Marshal.load(Base64.decode64(data))
  end
  
  def marshalize(data)
    Base64.encode64(Marshal.dump(data))
  end

end
