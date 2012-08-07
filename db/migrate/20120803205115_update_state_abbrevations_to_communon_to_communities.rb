class UpdateStateAbbrevationsToCommunonToCommunities < ActiveRecord::Migration
  def up
    execute("UPDATE communities SET state = 'MA' WHERE id = 1")
    execute("UPDATE communities SET state = 'VA' WHERE id = 2")
    execute("UPDATE communities SET state = 'NY' WHERE id = 3")
    execute("UPDATE communities SET state = 'VA' WHERE id = 4")
    execute("UPDATE communities SET state = 'MN' WHERE id = 5")
    execute("UPDATE communities SET state = 'MA' WHERE id = 6")
    execute("UPDATE communities SET state = 'MA' WHERE id = 8")
    execute("UPDATE communities SET state = 'RI' WHERE id = 9")
    execute("UPDATE communities SET state = 'NC' WHERE id = 10")
    execute("UPDATE communities SET state = 'VA' WHERE id = 11")
    execute("UPDATE communities SET state = 'NC' WHERE id = 12")
    execute("UPDATE communities SET state = 'MN' WHERE id = 13")
    execute("UPDATE communities SET state = 'TN' WHERE id = 14")
    execute("UPDATE communities SET state = 'MA' WHERE id = 15")
    execute("UPDATE communities SET state = 'MA' WHERE id = 17")
    execute("UPDATE communities SET state = 'WA' WHERE id = 20")
    execute("UPDATE communities SET state = 'MN' WHERE id = 21")
    execute("UPDATE communities SET state = 'MI' WHERE id = 22")
    execute("UPDATE communities SET state = 'MN' WHERE id = 23")
    execute("UPDATE communities SET state = 'NY' WHERE id = 24")
    execute("UPDATE communities SET state = 'GA' WHERE id = 25")
    execute("UPDATE communities SET state = 'MA' WHERE id = 26")
    execute("UPDATE communities SET state = 'MA' WHERE id = 27")
    execute("UPDATE communities SET state = 'MA' WHERE id = 28")
  end

  def down
  end
end
