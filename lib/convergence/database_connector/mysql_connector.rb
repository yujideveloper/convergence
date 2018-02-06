# frozen_string_literal: true
require 'mysql2'
class Convergence::DatabaseConnector::MysqlConnector
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def client(database_name = @config.database)
    @mysql ||= Mysql2::Client.new(
      host: @config.host,
      port: @config.port,
      username: @config.username,
      password: @config.password,
      database: database_name
    )
  end

  def schema_client
    @schema_mysql ||= Mysql2::Client.new(
      host: @config.host,
      port: @config.port,
      username: @config.username,
      password: @config.password,
      database: 'information_schema'
    )
  end
end
