require 'pathname'
require 'convergence/command'
require 'convergence/command/apply'
require 'convergence/dsl'
require 'convergence/default_parameter'
require 'convergence/pretty_diff'

class Convergence::Command::Dryrun < Convergence::Command
  def execute
    current_dir_path = Pathname.new(@opts[:input]).realpath.dirname
    input_tables = Convergence::DSL.parse(File.open(@opts[:input]).read, current_dir_path)
    current_tables = dumper.dump
    # -- maybe it's redundant output
    # output_diff(input_tables, current_tables)
    output_sql(input_tables, current_tables)
  end

  private

  def output_diff(input_tables, current_tables)
    input_tables_without_default_parameter =
      Convergence::DefaultParameter.remove_database_default_parameter(input_tables, database_adapter)
    current_tables_without_default_parameter =
      Convergence::DefaultParameter.remove_database_default_parameter(current_tables, database_adapter)

    msg = Convergence::PrettyDiff
      .new(current_tables_without_default_parameter, input_tables_without_default_parameter)
      .output
    logger.output(msg)
    msg
  end

  def output_sql(input_tables, current_tables)
    msg = Convergence::Command::Apply
      .new(@opts, config: @config)
      .generate_sql(input_tables, current_tables)
      .split("\n")
      .map { |v| '# ' + v }
      .join("\n")
    logger.output(msg) unless msg.empty?
    msg
  end
end
