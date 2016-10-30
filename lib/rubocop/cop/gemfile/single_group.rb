# frozen_string_literal: true

module RuboCop
  module Cop
    module Gemfile
      # This cop makes sure that `group` method has single group name
      #
      # @example
      #   # bad
      #   group :test, :development do
      #     gem "rspec-rails"
      #   end
      #
      #   # good
      #   group :test do
      #     gem "rspec-rails", group: :development
      #   end
      class SingleGroup < Cop
        MSG = '`group` should not have multiple groups'.freeze

        def on_send(node)
          _, method_name, *args = *node

          return unless method_name == :group

          add_offense(node, args_location(args)) if args.length >= 2
        end

        private

        def args_location(args)
          begin_pos = args.first.loc.begin.begin_pos
          end_pos = args.last.loc.expression.end_pos
          Parser::Source::Range.new(args.first.loc.expression.source_buffer,
                                    begin_pos, end_pos)
        end
      end
    end
  end
end
