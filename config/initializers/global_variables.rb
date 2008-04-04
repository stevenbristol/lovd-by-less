# Change globals to match the proper value for your site

DELETE_CONFIRM = "Are you sure you want to delete?\nThis can not be undone."
SEARCH_LIMIT = 25
SITE_NAME = 'Lovd By Less'
SITE = RAILS_ENV == 'production' ? 'lovdbyless.com' : 'localhost:3000'


MAILER_TO_ADDRESS = 'info@#{SITE}'
MAILER_FROM_ADDRESS = 'The Lovd by Less Team <info@lovdbyless.com>'
REGISTRATION_RECIPIENTS = %W() #send an email to this list everytime someone signs up


YOUTUBE_BASE_URL = "http://gdata.youtube.com/feeds/api/videos/"