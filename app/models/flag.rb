class Flag < ActiveRecord::Base

  belongs_to :resident
  belongs_to :street_address

  # todo => [type, [don't display tags], [should display tags]
  #
  # Note: Don't display overrides should display
  # This function will only be called if the TagRules file can't be found
  def self.init_todo
    @@todos = {
      "send nomination email" => [0, ["sent nomination email"], ["nominate"]],
      "schedule a call" => [0, ["scheduled a call", "called", "sent thanks for call"], ["sent nomination email"]],
      "call" => [0, ["called"], ["scheduled a call"]],
      "send thanks for call" => [0, ["sent thanks for call"], ["called"]],
      "add to civic hero list" => [0, ["member of civic hero"]]
    }

    @@scripts = {
      "send nomination email" => "<i>test</i>",
      "schedule a call" => "hi",
      "call" => "wat",
      "send thanks for call" => "zen",
      "add to civic hero list" => "final"
    }
  end

  # tag => [[don't display todos], [should display todos]
  #
  # Note: Don't display overrides should display
  # This function will only be called if the TagRules file can't be found
  def self.init
    @@rules = {
      "nominate" => [[], ["send nomination email"]],
      "sent nomination email" => [["send nomination email"], ["schedule a call"]],
      "scheduled a call" => [["schedule a call"], ["call"]],
      "called" => [["schedule a call", "call"], ["send thanks for call"]],
      "sent thanks for call" => [["schedule a call", "call", "send thanks for call"], []],
      "agreed to civic hero membership" => [[], ["add to civic hero list"]],
      "member of civic hero" => [["add to civic hero list"], []]
    }

    @@type = {
      "nominate" => "No type",
      "sent nomination email" => "No type",
      "scheduled a call" => "No type",
      "called" => "No type",
      "sent thanks for call" => "No type",
      "agreed to civic hero membership" => "No type",
      "member of civic hero" => "No type"
    }
  end

  def self.get_scripts
    @@scripts ||= {}

    @@scripts
  end

  def self.get_type(flag)
    @@type ||= {}

    @@type[flag]
  end

  def self.get_types
    @@type ||= {}

    @@type
  end

  def self.get_todo(todo)
    @@todos ||= {}

    @@todos[todo]
  end

  def self.get_todos
    @@todos ||= {}

    @@todos.sort {|a, b| a[1] <=> b[1]}.map {|a, b, c, d| a}.compact
  end

  def self.get_rule(flag)
    @@rules ||= {}

    @@rules[flag]
  end

  def self.get_rules
    @@rules ||= {}

    @@rules
  end

  def self.create_script(to_do, script)
    @@scripts ||= {}
    if @@scripts[to_do].nil?
      @@scripts[to_do] = script
    else
      old = @@scripts[to_do]
      new = old << script
      @@scripts[to_do] = new
    end
  end

  def self.create_type(flag, type)
    @@type ||= {}
    @@type[flag] = type
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
    @@type = {}
  end
end
