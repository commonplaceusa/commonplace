Commonplace::Application.configure do
  silence_warnings do
    # This will gracefully fall back to IRB in production (pry gem not loaded)
    # But it whines. Let's shut it up.
    begin
      require 'pry'
      IRB = Pry
    rescue LoadError
    end
  end
end
