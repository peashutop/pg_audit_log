require "active_record/connection_adapters/postgresql_adapter"

# Did not want to reopen the class but sending an include seemingly is not working.
class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  def execute_with_auditing(sql, name = nil)
    current_user = Thread.current[:current_user]
    user_unique_name = current_user.try(:unique_name) || "UNKNOWN"

    log_user_id = %[SET audit.user_id = #{current_user.try(:id) || "-1"}]
    log_user_unique_name = %[SET audit.user_unique_name = "#{user_unique_name}"]

    log([log_user_id, log_user_unique_name, sql].join("; "), name) do
      if @async
        @connection.async_exec(log_user_id)
        @connection.async_exec(log_user_unique_name)
        @connection.async_exec(sql)
      else
        @connection.exec(log_user_id)
        @connection.exec(log_user_unique_name)
        @connection.exec(sql)
      end
    end
  end

  alias_method_chain :execute, :auditing
end

