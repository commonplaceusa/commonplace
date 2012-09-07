
Flag.clear

r = Rails.root.join("app", "text", "TagList.csv")
s = Rails.root.join("app", "text", "TodoRules.csv")

if !File.exist?(s) || !File.exist?(r)
  Flag.init
  Flag.init_todo

else

  CSV.foreach(r, :headers => true) do |row|
    h = row.to_hash

    type = h["Type"].nil? ? "No type" : h["Type"]
    name = h["Tag"]

    Flag.create_type(name, type)
  end

  CSV.foreach(s, :headers => true) do |row|
    h = row.to_hash

    next if h["To-Do"].nil?

    todo = h["To-Do"]
    should = h["Should Display If Has Tag:"]

    cant = h["Can't Display If Has Tag:"]
    more_cant = h["Can't Display If Has Tag (2):"]
    case h["To-Do Type"]
    when "Email"
      type = 1
    when "To Tag"
      type = 2
    when "Action"
      type = 3
    when "Event"
      type = 4
    when "Wait for"
      type = 5
    when "Wait for: long wait"
      type = 6
    when "Special To-Do"
      type = 7
    else
      type = 8
    end
    script = h["Notes"] if !h["Notes"].nil?

    Flag.create_todo(todo, type, should, cant)
    Flag.create_rule(todo, cant, nil) if !cant.nil?
    Flag.create_rule(todo, more_cant, nil) if !more_cant.nil?
    Flag.create_rule(nil, should, todo) if !should.nil?
    Flag.create_script(todo, script) if !script.nil?

    Flag.create_rule(todo, "Type: Uninterested", nil)
    Flag.create_rule(todo, "Type: Timed Out", nil)
  end
end
