# frozen_string_literal: true

# Унифицирует формат результатов различных линтеров
# Вывод данных в виде json:
# {
#   file_path: [
#     {
#       messgage: message,
#       rule: linter rule,
#       position: location of error
#     },
#     {
#       ...
#     }
#   ],
#   another_file_path: ....
# }
class LinterResultsUnifier
  def self.get_linter_errors(check)
    return {} if check.linter_result.blank?

    errors_as_json = JSON.parse(check.linter_result)

    case check.repository.language
    when 'ruby'
      format_ruby(check, errors_as_json)
    when 'javascript'
      format_javascript(check, errors_as_json)
    end
  end

  def self.format_ruby(check, errors_as_json)
    result = {}

    errors_as_json['files'].each do |file|
      next if file['offenses'].empty?

      relative_path = file['path'].gsub(Rails.root.join("tmp/repositories/#{check.repository.github_id}").to_s, '')
      result[relative_path] = file['offenses'].each_with_object([]) do |offense, arr|
        arr << {
          message: offense['message'],
          rule: offense['cop_name'],
          position: "#{offense['location']['start_line']}:#{offense['location']['start_column']}"
        }
      end
    end

    result
  end

  def self.format_javascript(check, errors_as_json)
    result = {}

    errors_as_json.each do |file|
      next if file['messages'].empty?

      relative_path = file['path'].gsub(Rails.root.join("tmp/repositories/#{check.repository.github_id}").to_s, '')
      result[relative_path] = file['messages'].each_with_object([]) do |offense, arr|
        arr << {
          message: offense['message'],
          rule: offense['ruleId'],
          position: "#{offense['line']}:#{offense['column']}"
        }
      end
    end

    result
  end
end
