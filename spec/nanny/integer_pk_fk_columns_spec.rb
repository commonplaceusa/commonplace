require "spec_helper"

describe "integer PK and FK columns", :nanny => true do
  subject { ActiveRecord::Base.connection.execute(sql).to_a }

  let(:sql) do
    <<-SQL
SELECT  c.table_name,
        c.column_name
FROM    information_schema.columns c
        INNER JOIN information_schema.tables t
          ON c.table_name = t.table_name
WHERE   t.table_schema = 'public'
        AND
        (
          c.column_name LIKE '%\_id'
          OR
          c.column_name = 'id'
        )
        AND c.data_type = 'integer'
ORDER BY c.table_name, c.column_name
    SQL
  end

  pending "Not really sure why this is here"
  # it { should == [] }
end
