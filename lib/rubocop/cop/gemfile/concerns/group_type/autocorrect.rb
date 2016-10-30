
module RuboCop
  module Cop
    module Gemfile
      module Concerns
        module GroupType
          module Autocorrect
            private

            def correct_symbol_group(args)
              lambda do |corrector|
                args.each do |arg|
                  content = arg_content(arg)
                  if content
                    corrector.replace(arg_location(arg),
                                      to_symbol_literal(content))
                  end
                end
              end
            end

            def correct_double_quote_group(args)
              lambda do |corrector|
                args.each do |arg|
                  content = arg_content(arg)
                  if content
                    corrector.replace(arg_location(arg),
                                      content.inspect)
                  end
                end
              end
            end

            def correct_symbol_quote_group(args)
              lambda do |corrector|
                args.each do |arg|
                  content = arg_content(arg)
                  if content
                    corrector.replace(arg_location(arg),
                                      to_string_literal(content))
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
