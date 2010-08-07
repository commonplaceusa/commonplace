class Helper
  include Singleton
  include ActionView::Helpers::DateHelper
  include TimeHelper
end

def help
  Helper.instance
end