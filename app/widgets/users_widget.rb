widget :users do
  key "857d5093f263bb8612c4577034a14595d7007b5a"
  type "number_and_secondary"
  data do
    {
      :value => User.count,
      :previous => User.count(:conditions => "created_at < '#{1.day.ago.to_s(:db)}'")
    }
  end
end
