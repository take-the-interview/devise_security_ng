require 'rails/generators/migration'

class DeviseSecurityNgGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration

  def self.source_root
    @_devise_source_root ||= File.expand_path("../templates", __FILE__)
  end

  def self.orm_has_migration?
    Rails::Generators.options[:rails][:orm] == :active_record
  end

  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  class_option :orm
  class_option :migration, :type => :boolean, :default => orm_has_migration?


  def create_migration_file
    migration_template 'migration.rb', "db/migrate/devise_add_security_ng_#{name.downcase}.rb"
  end

  def add_configs
    inject_into_file "config/initializers/devise.rb", "\n  # ==> Security NG\n  # Configure security ng for devise\n\n" +
    "  # Maximum login attempts before first lock\n" +
    "  # config.maximum_login_attempts = 3\n\n" +
    "  # Should we alert the user of imminent account locking?\n" +
    "  # config.last_attempt_warning = true\n\n" +
    "", :before => /end[ |\n|]+\Z/
  end
end
