ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:default => '%m/%d/%Y')

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :default => "%I:%M %p",
  :date_time12  => "%m/%d/%Y %I:%M%p"
)
