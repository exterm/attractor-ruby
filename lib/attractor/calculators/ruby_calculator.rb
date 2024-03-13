# frozen_string_literal: true

require 'flog'

module Attractor
  class RubyCalculator < BaseCalculator
    def initialize(file_prefix: '', ignores: '', minimum_churn_count: 3, start_ago: 365 * 5, verbose: false)
      super(file_prefix: file_prefix, ignores: ignores, file_extension: 'rb', minimum_churn_count: minimum_churn_count, start_ago: start_ago, verbose: verbose)
      @type = "Ruby"
    end

    def calculate
      super do |change|
        flogger = Flog.new(all: true)
        flogger.flog(change[:file_path])
        # lines of code, ignoring comments and empty lines
        loc = File.readlines(change[:file_path])
          .reject { |line| line.strip.empty? || line.strip.start_with?('#') }.size
        complexity = flogger.total_score / loc
        details = flogger.totals
        [complexity, details]
      end
    end
  end
end
