class Helper
  include Singleton
  include ActionView::Helpers::DateHelper
  include TimeHelper

  def self.help
    Helper.instance
  end
end

