module PgAuditLog
  IGNORED_TABLES = ["plugin_schema_migrations", "sessions", "schema_migrations"]
end

require "active_record"
require "pg_audit_log/version"

raise "ActiveRecord #{::ActiveRecord::VERSION::MAJOR}.x unsupported!" unless ::ActiveRecord::VERSION::MAJOR == 3

require "pg_audit_log/extensions/postgresql_adapter.rb"
require "pg_audit_log/active_record"
require "pg_audit_log/entry"
require "pg_audit_log/function"
require "pg_audit_log/triggers"

