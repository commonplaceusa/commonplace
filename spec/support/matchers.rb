module Matchers

  def have_queued(*args)
    have_received.enqueue(*args)
  end
  

  def have_received(method = nil)
    RR::Adapters::Rspec::InvocationMatcher.new(method)
  end

end
