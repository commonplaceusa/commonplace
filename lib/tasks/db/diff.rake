namespace :db do

  desc "see if there's a difference between migrating and rolling back your migration - compared to production, if env variable LEAVE_FILES is set, diff files will not be deleted"
  task :diff_production do
    `heroku db:pull --app commonplace --confirm commonplace`
     puts "database is ready"
     puts "run 'rake db:diff' to test the migrations"
  end

  desc "see if there's a difference between migrating and rolling back your migration - compared to staging, if env variable LEAVE_FILES is set, diff files will not be deleted"
  task :diff_staging => [:environment] do
    `heroku db:pull --app commonplace-staging --confirm commonplace-staging`
     puts "database is ready"
     puts "run 'rake db:diff' to test the migrations"
  end

  task :diff_local_production do
    `dropdb -h localhost commonplace_development; createdb -h localhost -T commonplace_production commonplace_development`
  end

  desc "see if there's a difference between migrating and rolling back your migration, if env variable LEAVE_FILES is set, diff files will not be deleted"
  task :diff => [:environment] do
    exit 0 if migrations.empty?

    clean_up

    puts 'taking "before" snapshot of db ...'
    dump("before")

    puts 'running migration(s) ...'
    migrate

    puts 'rolling back ...'
    rollback

    puts 'comparing ...'
    dump("after")

    tables = compare

    if leave_files
      puts "*" * 80
      puts "Environment Variable LEAVE_FILES is set, diff source files remain in '#{temp_folder}'"
      puts "*" * 80
    else
      clean_up
    end

    exit tables.length if tables.any?
  end

  private

  def leave_files
    ENV["LEAVE_FILES"] == 'true'
  end

  def temp_folder
    "/tmp/casebook2-dumps"
  end

  def clean_up
    FileUtils.rm_rf(temp_folder) if Dir.exists?(temp_folder)
  end

  def dump(file_token)
    tables_to_ignore = %w[audit_log click_streams data_broker_event_logs data_broker_traffic_logs archived_ deprecated_]

    FileUtils.mkdir_p(File.join(temp_folder, file_token))
    conn = ActiveRecord::Base.connection
    database = conn.current_database

    conn.tables.sort.reject do |table_name|
      table_name.match(/^#{tables_to_ignore.join('|')}/)
    end.each do |table_name|
      print "#{table_name}#{" "*20} #{"\b"*500}"
      columns = conn.select_values(<<-SQL)
        SELECT column_name FROM information_schema.columns
        WHERE table_catalog = #{conn.quote(database)}
        AND table_name = #{conn.quote(table_name)}
        ORDER BY column_name
      SQL
      columns.reject! { |col| col.match(/^deprecated_/) }

      file = File.join(temp_folder, file_token, "#{table_name}.txt")
      quoted_columns = columns.map { |c| conn.quote_table_name(c) }.join(',')
      conn.execute "COPY (SELECT #{quoted_columns} FROM #{conn.quote_table_name(table_name)} ORDER BY #{quoted_columns}) TO #{conn.quote(file)}"
    end
    puts ' ' * 150
    STDOUT.flush
  end

  def migrations
    return @migrations if @migrations
    done = ActiveRecord::Base.connection.select_values("SELECT version FROM schema_migrations")
    files = Dir.glob('db/migrate/*_*.rb').map{|l|l.match(%r{db/migrate/(\d+)_}) ? $1 : nil}.compact
    @migrations = (files - done).sort
  end

  def migrate
    migrations.each do |migration|
      puts migration
      ENV["VERSION"] = migration
      Rake::Task["db:migrate:up"].execute
    end
  end

  def rollback
    migrations.reverse.each do |migration|
      puts migration
      ENV["VERSION"] = migration
      Rake::Task["db:migrate:down"].execute
    end
  end

  def compare
    files = `diff -q #{temp_folder}/before #{temp_folder}/after`.split(/\n/).map do |line|
      line.match(/([^\s\/]*)\.txt/) ? $1 : line
    end
    if files.any?
      puts "The Following tables are different:", files
    else
      puts "No tables are different :)"
    end
    files
  end
end
