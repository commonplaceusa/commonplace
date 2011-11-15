Time::DATE_FORMATS.merge!(
  :default => "%I:%M %p",
  :date_time12  => "%m/%d/%Y %I:%M%p",
  :month_day_at_time => "%B %d at %I:%M%p",
  :month_day => "%B %d",             # October 17
  :month_year => "%B %Y",            # October 2010,
  :month_day_year => "%B %d, %Y",    # October 2010, 2010
  :pretty => "%a, %b %e at %l:%M%P", # Mon, Oct 4 at 7:00pm
  :full => "%a, %B %e, %l:%M%P",     # Mon, October 4 at 7:00pm
  :time_only => "%l:%M%P",           # 7:00pm
  :quick => "%b %e, %l:%M%p"         # Oct 4, 7:00pm
)
