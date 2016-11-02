# frozen_string_literal: true
module RuboCop
  module Cop
    module Gemfile
      module Concerns
        module GroupType
          module OnSend # rubocop:disable Style/Documentation
            private

            def check_symbol_group(arg, node, message)
              return if exclude_type?(arg) || arg.sym_type?
              add_offense(node, arg.loc.expression, message)
            end

            def check_double_quotes_group(arg, node, message)
              return if exclude_type?(arg) || double_quotes?(arg)
              add_offense(node, arg.loc.expression, message)
            end

            def check_single_quotes_group(arg, node, message)
              return if exclude_type?(arg) || single_quotes?(arg)
              add_offense(node, arg.loc.expression, message)
            end
          end
        end
      end
    end
  end
end
