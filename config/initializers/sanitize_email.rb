
require 'sanitize_email'
ActionMailer::Base.sanitized_bcc = nil
ActionMailer::Base.sanitized_cc = nil
ActionMailer::Base.sanitized_recipients = ["max"]

# These are the environments whose outgoing email BCC, CC and recipients fields will be overridden!
# All environments not listed will be treated as normal.
ActionMailer::Base.local_environments = %w( sendmail )
