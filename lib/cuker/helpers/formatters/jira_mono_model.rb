require_relative '../writers/abstract_writer'
module Cuker
  class JiraMonoModel < JiraModel
    include LoggerSetup

    def in_table_cell cell_hsh
      if cell_hsh[:type] == :TableCell
        val = cell_hsh[:value].strip
        val.empty? ? JIRA_BLANK : jira_monospace(val)
      else
        @log.warn "Expected :TableCell in #{cell_hsh} @ #{@file_path}"
        JIRA_BLANK
      end
    end

    def in_step(steps)
      steps.each do |step|
        if step[:type] == :Step
          step_ary = []
          step_str = [
              (jira_monospace(jira_bold(step[:keyword].strip)).rjust(11)), # bolding the keywords
              jira_monospace(step[:text].strip)
          ].join(' ')

          # step_ary << jira_monospace(step_str)
          step_ary << (step_str)

          step_ary += in_step_args(step[:argument]) if step[:argument]
          # todo: padding as needed
          yield step_ary
        else
          @log.warn "Unknown type '#{item[:type]}' found in file @ #{@file_path}"
        end
      end
    end

    # helps handle tables for now
    def in_step_args arg
      if arg[:type] == :DataTable
        res = []
        arg[:rows].each_with_index do |row, i|
          sep = i == 0 ? '||' : '|'
          res << surround(row[:cells].map {|hsh| jira_monospace(jira_blank_pad hsh[:value])}, sep)
        end
        return res
      elsif arg[:type] == :DocString
        # todo: handle if needed
        @log.warn "Docstrings found in '#{arg}' found in file @ #{@file_path}"
      else
        @log.warn "Unknown type '#{arg[:type]}' found in file @ #{@file_path}"
      end
      []
    end

    def jira_monospace str
      simple_surround str, '{{', '}}'
    end

  end
end