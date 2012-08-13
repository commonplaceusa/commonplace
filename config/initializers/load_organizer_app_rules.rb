
Flag.clear

s = Rails.root.join("app", "text", "TagRules.csv")

if !File.exist?(s)
  Flag.init
  Flag.init_todo

else

  CSV.foreach(s, :headers => true) do |row|
    h = row.to_hash

    next if !h["Dependency"].nil?
    next if h["To-Do"].nil?

    todo = h["To-Do"]
    should = h["Should Display If Has Tag:"]
    cant = h["Can't Display If Has Tag:"]
    case h["Type"]
    when "Email"
      type = 1
    when "To Tag"
      type = 2
    when "Action"
      type = 3
    when "Wait"
      type = 4
    when "Endpoint"
      type = 5
    else
      type = -1
    end

    Flag.create_todo(todo, type, should, cant)
    Flag.create_rule(todo, cant, nil) if !cant.nil?
    Flag.create_rule(nil, should, todo) if !should.nil?
  end
end
