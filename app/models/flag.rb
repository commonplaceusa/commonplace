class Flag < ActiveRecord::Base

  belongs_to :resident
  belongs_to :street_address

  # TODO Initialize with actual flags [load from text file or...?]
  def self.init
    {
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
    {
      "send nomination email" => ["sent nomination email"],
      "schedule a call" => ["scheduled a call"],
      "call" => ["called"],
      "send thanks for call" => ["sent thanks for call"],
      "add to civic hero list" => ["member of civic hero"]
    }
  end

  def self.get_rule(flag)
    @@rules ||= init

    @@rules[flag]
  end

  def self.get_rules
    @@rules ||= init

    list = @@rules.to_a

    list.each do |flag|
      puts flag.to_s
    end

    nil
  end

  # Creates rules for flags to follow
  def self.create_rule(done, flag, to_do)
    @@rules ||= init
    @@rules[flag] = [done, to_do]
  end

  def self.create_rules(flag_list)
    @@rules ||= init
  end
end
