namespace :db do
  desc "Validate all model objects eg rake db:validate OR rake db:validate[cases]"
  task :validate, [:name] => [:environment] do |t, args|

    Dir.glob(Rails.root.join('app/models/**/*.rb')).each { |f| require f }

    flaky_models = [ ]
    allowable_blank_models = [].map(&:name)
    ignored_models = [ ]

    $LOAD_PATH << (Rails.root + "tc/common") << (Rails.root + "tc/bdd")
    formatter = nil
    puts "WARNING: unable to load teamcity formatter, loading rspec formatter"
    require "rspec/core/formatters/documentation_formatter"
    formatter = RSpec::Core::Formatters::DocumentationFormatter
    formatter.class_eval do
      def self.example_group_started(*args)
      end

      def self.example_started(*args)
      end

      def self.example_passed(*args)
        print "\033[0;32mall valid\033[0m"
      end

      def self.example_failed(record)
        puts "\n\033[0;31m"
        if record.exception.respond_to?(:each)
          record.exception.each do |key, value|
            puts "#{key} affecting records #{value.join(', ')}"
          end
        else
          puts record.exception.inspect
        end
        puts "\033[0m\n"
      end

      def self.example_group_finished(*args)
      end
    end

    records = []
    models = (ActiveRecord::Base.descendants - flaky_models - ignored_models).uniq.sort_by(&:table_name)
    models.reject!{|m| models.include?(m.parent)}
    models.each do |model|
      next if !args[:name].nil? && model.table_name != args[:name]
      next unless model.validators.any?

      example_group = Object.new.tap { |o| o.extend Module.new {
        define_method(:description) do
          "#{model.table_name}"
        end
      }}

      formatter.example_group_started(example_group)
      print "Validating: #{model.name}(#{model.table_name}) (#{model.count} rows)..." unless ENV["CI"]
      example = Class.new {
        attr_accessor :exception

        def initialize(model)
          @model = model
        end

        def record
          @model
        end

        def invalid_records=(array)
          @invalid_records = array
        end

        def description
          @model.to_s
        end

        def execution_result
          {
            exception: RSpec::Expectations::ExpectationNotMetError.new(exception)
          }
        end
      }.new(model)

      formatter.example_started(example)
      invalid_records_for_model = {}
      model.find_each do |r|
        begin
          unless r.valid?
            records << r
            r.errors.full_messages.uniq.each do |validation_error|
              invalid_records_for_model["#{r.class.name} #{validation_error}"] ||= []
              invalid_records_for_model["#{r.class.name} #{validation_error}"] << r.id
            end
          end
        rescue => e
          puts "\nF: RAISE: #{r.id} - #{e}" unless ENV["CI"]
          invalid_records_for_model["#{r.class.name} #{e}"] ||= []
          invalid_records_for_model["#{r.class.name} #{e}"] << r.id
        end
      end

      model_count = model.count

      if invalid_records_for_model.empty? && model_count != 0
        formatter.example_passed(example)
      elsif model_count == 0 and !allowable_blank_models.include?(model.name)
        example.exception = "No records for #{model.name} model"
        formatter.example_failed(example)
      else
        example.exception = invalid_records_for_model
        formatter.example_failed(example)
      end
      formatter.example_group_finished(example_group)
      puts "" unless ENV["CI"]
    end

    unless ENV["CI"]
      puts ""
      puts "*** Summary ***"
      puts ""
      records.flatten.uniq.each{|r| puts "#{r.class.name} - #{r.id} - #{r.errors.full_messages.uniq}" }
    end
    exit 1 unless records.empty?
  end

  desc "Validate all model objects eg rake db:validate OR rake db:validate[cases]"
  task :delete_invalid_records => [:environment, :delete_invalid_records_first_pass] do
    Dir.glob(Rails.root.join('app/models/**/*.rb')).each { |f| require f }
    num_wrong = 1
    while num_wrong > 0 do
      num_wrong = 0
      ActiveRecord::Base.descendants.uniq.sort_by(&:table_name).each do |model|
        next unless model.validators.any?
        print "Validating: #{model.table_name} (#{model.count} rows)"
        model.find_each do |r|
          begin
            if r.valid?
              print '.'
            else
              print "(F:#{r.id})"
              ActiveRecord::Base.connection.execute("DELETE FROM #{model.table_name} WHERE id=#{r.id}")
              num_wrong += 1
            end
          rescue => e
            puts "\nF: RAISE: #{r.id} - #{e}"
            ActiveRecord::Base.connection.execute("DELETE FROM #{model.table_name} WHERE id=#{r.id}")
            num_wrong += 1
          end
        end
        puts
      end
      puts "NumberWrong #{num_wrong}"
    end

    ActiveRecord::Base.connection.execute("alter table assistance_group_people drop constraint assistance_group_people_person_id_fkey")
    ActiveRecord::Base.connection.execute("alter table assistance_group_people add FOREIGN KEY (person_id) references people(id)")

    ActiveRecord::Base.connection.execute("ALTER TABLE ONLY intakes DROP CONSTRAINT intakes_incident_address_id_fkey")
    ActiveRecord::Base.connection.execute("ALTER TABLE ONLY intakes ADD CONSTRAINT intakes_incident_address_id_fkey FOREIGN KEY (incident_address_id) REFERENCES addresses(id)")

    puts ""
  end

  task :generate_constraints => [:environment] do
    Dir.glob(Rails.root.join('app/models/**/*.rb')).each { |f| require f }
    ActiveRecord::Base.descendants.uniq.sort_by(&:table_name).each do |model|
      next unless model.validators.any?

      columns = model.columns.map(&:name)
      validators = model.validators.reject { |v| v.options[:if] || v.options[:except] || v.options[:unless] || v.options[:on] }
      validators.select { |v| v.class == ActiveModel::Validations::PresenceValidator }.map(&:attributes).flatten.map(&:to_s).uniq.sort.each do |attribute|
        if columns.include?(attribute)
          puts "change_column_null(:#{model.table_name}, :#{attribute}, false)"
        elsif model.reflect_on_association(attribute.to_sym)
          pkn = model.reflect_on_association(attribute.to_sym).primary_key_name
          if columns.include?(pkn.to_s)
            puts "change_column_null(:#{model.table_name}, :#{pkn}, false)"
          end
        end
      end
    end
  end

  task :delete_invalid_records_first_pass => [:environment] do
    Dir.glob(Rails.root.join('app/models/**/*.rb')).each { |f| require f }
    ActiveRecord::Base.descendants.uniq.sort_by(&:table_name).each do |model|
      next unless model.validators.any?

      columns = model.columns.map(&:name)
      validators = model.validators.reject { |v| v.options[:if] || v.options[:except] || v.options[:unless] }
      needed = []
      validators.select { |v| v.class == ActiveModel::Validations::PresenceValidator }.map(&:attributes).flatten.map(&:to_s).uniq.sort.each do |attribute|
        if columns.include?(attribute)
          needed << attribute
        elsif model.reflect_on_association(attribute.to_sym)
          pkn = model.reflect_on_association(attribute.to_sym).primary_key_name
          if columns.include?(pkn.to_s)
            needed << pkn
          end
        end
      end

      if needed.any?
        p "#{model.table_name}: #{needed.join(', ')}"
        strings = model.columns.select { |c| c.type==:string }.collect(&:name)
        sql = "DELETE FROM #{model.table_name} WHERE "
        sql += needed.select {|c| c.to_s != 'uuid' }.collect do |c|
          "('#{c}' IS NULL" + (strings.include?(c.to_s) ? " OR '#{c}'=''" : '') + ')'
        end.join(' OR ')
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
