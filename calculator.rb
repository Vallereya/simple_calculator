require 'glimmer-dsl-libui'
require_relative 'proc/buttons'
require_relative 'proc/evaluator'

include Glimmer

result = ''
result_entry = nil

window('Calculator', 300, 500) do
    margined true

    vertical_box do
        result_entry = entry do
            read_only true
            text ''
        end

        create_buttons(self, result_entry, ->(op) {
        case op

        when :clear
            result = ''

        when :delete
            result = result[0..-2] unless result.empty?

        when :percent
            begin
                value = evaluate_expression(result).to_f
                result = format_result(value / 100.0)
            rescue StandardError
                result = 'Error'
            end

        when :decimal
            result += '.' unless result.end_with?('.')

        when :equals
            begin
                result = evaluate_expression(result)
            rescue StandardError
                result = 'Error'
            end

        else
            result += op.to_s
        end

        result_entry.text = result
        })
    end
end.show
