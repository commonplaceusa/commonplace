class Flag < ActiveRecord::Base

  belongs_to :resident
  belongs_to :street_address

  def self.init
    @@rules = {
      "nominate" =>[[], ["send nomination email"]],
      "sent nomination email" => [["send nomination email"], ["schedule a call"]],
      "scheduled a call" => [["schedule a call"], ["call"]],
      "called" => [["schedule a call", "call"], ["send thanks for call"]],
      "sent thanks for call" => [["schedule a call", "call", "send thanks for call"], []],
      "agreed to civic hero membership" => [[], ["add to civic hero list"]],
      "member of civic hero" => [["add to civic hero list"], []]
    }
  end

  # Creates a 1:1 mapping of todo with "logical" next flag
  def self.init_todo
    @@todos = {
      "send nomination email" => ["sent nomination email"],
      "schedule a call" => ["scheduled a call"],
      "call" => ["called"],
      "send thanks for call" => ["sent thanks for call"],
      "add to civic hero list" => ["member of civic hero"]
    }
  end

  def self.get_todos
    @@todos ||= {}

    @@todos.sort {|a, b| a[1] <=> b[1]}.map {|a, b, c, d| a}.compact
    # @@todos.keys.compact
  end

  def self.get_rule(flag)
    @@rules ||= {}

    @@rules[flag]
  end

  def self.get_rules
    @@rules ||= {}

    @@rules
  end

  def self.create_todo(to_do, type, should, cant)
    @@todos ||= {}
    if @@todos[to_do].nil?
      @@todos[to_do] = [type, Array(cant), Array(should)]
    else
      update = @@todos[to_do]
      update[1] |= Array(cant)
      update[2] |= Array(should)
      @@todos[to_do] = update
    end
  end

  # Creates rules for flags to follow
  def self.create_rule(done, flag, to_do)
    @@rules ||= {}
    if @@rules[flag].nil?
      @@rules[flag] = [Array(done), Array(to_do)]
    else
      update = @@rules[flag]
      update[0] |= Array(done)
      update[1] |= Array(to_do)
      @@rules[flag] = update
    end
  end

  def self.clear
    @@rules = {}
    @@todos = {}
  end
end
