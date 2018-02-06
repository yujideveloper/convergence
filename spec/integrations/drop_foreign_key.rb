# frozen_string_literal: true
require 'spec_helper'

describe 'Changeable Foreign key' do
  after(:each) do
    rollback
  end

  def execute(dsl_path)
    parse_option = {
      apply: true,
      input: File.expand_path("#{File.dirname(__FILE__)}/../fixtures/#{dsl_path}")
    }
    Convergence::Command.new(parse_option, config: mysql_settings).execute
  end

  describe 'drop foreign key' do
    let(:exec_dsl) { 'drop_foreign_key.schema' }

    it 'should be drop foreign key' do
      expect { execute(exec_dsl) }.not_to raise_error
    end
  end

  describe 'change foreign key' do
    let(:exec_dsl) { 'change_foreign_key.schema' }

    it 'should be drop foreign key' do
      expect { execute(exec_dsl) }.not_to raise_error
    end
  end
end
