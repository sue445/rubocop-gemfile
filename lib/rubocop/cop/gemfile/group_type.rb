# frozen_string_literal: true

require 'rubocop/cop/gemfile/concerns/group_type/on_send'
require 'rubocop/cop/gemfile/concerns/group_type/autocorrect'

module RuboCop
  module Cop
    module Gemfile
      # This cop makes sure that `group` has symbol group name
      #
      # @example
      #   # EnforcedStyle: symbol
      #
      #   # bad
      #   group "test" do
      #     gem "rspec-rails"
      #   end
      #
      #   group 'test' do
      #     gem "rspec-rails"
      #   end
      #
      #   # good
      #   group :test do
      #     gem "rspec-rails"
      #   end
      #
      #   # EnforcedStyle: single_quotes
      #
      #   # bad
      #   group :test do
      #     gem "rspec-rails"
      #   end
      #
      #   group "test" do
      #     gem "rspec-rails"
      #   end
      #
      #   # good
      #   group 'test' do
      #     gem "rspec-rails"
      #   end
      #
      #   # EnforcedStyle: double_quotes
      #
      #   # bad
      #   group :test do
      #     gem "rspec-rails"
      #   end
      #
      #   group 'test' do
      #     gem "rspec-rails"
      #   end
      #
      #   # good
      #   group "test" do
      #     gem "rspec-rails"
      #   end
      class GroupType < Cop
        MSG = 'Use %s group'.freeze

        ENFORCED_STYLE_SYMBOL        = 'symbol'.freeze
        ENFORCED_STYLE_DOUBLE_QUOTES = 'double_quotes'.freeze
        ENFORCED_STYLE_SINGLE_QUOTES = 'single_quotes'.freeze

        VALIDATION_ENFORCED_STYLE_MSG = '%s is not unsupport'.freeze

        include Concerns::GroupType::OnSend
        include Concerns::GroupType::Autocorrect

        def on_send(node)
          _, method_name, *args = *node

          return unless method_name == :group

          args.each do |arg|
            check_group_argument(arg, node)
          end
        end

        def autocorrect(node)
          _receiver, _method_name, *args = *node

          case enforced_style
          when ENFORCED_STYLE_SYMBOL
            correct_symbol_group(args)
          when ENFORCED_STYLE_DOUBLE_QUOTES
            correct_double_quote_group(args)
          when ENFORCED_STYLE_SINGLE_QUOTES
            correct_symbol_quote_group(args)
          end
        end

        private

        def check_group_argument(arg, node)
          message = MSG % enforced_style

          case enforced_style
          when ENFORCED_STYLE_SYMBOL
            check_symbol_group(arg, node, message)
          when ENFORCED_STYLE_DOUBLE_QUOTES
            check_double_quotes_group(arg, node, message)
          when ENFORCED_STYLE_SINGLE_QUOTES
            check_single_quotes_group(arg, node, message)
          end
        end

        def enforced_style
          return @enforced_style if @enforced_style

          @enforced_style = cop_config['EnforcedStyle']

          unless cop_config['SupportedStyles'].include?(@enforced_style)
            message = VALIDATION_ENFORCED_STYLE_MSG % @enforced_style
            raise ValidationError, message
          end

          @enforced_style
        end

        def single_quotes?(arg)
          quotes?(arg, "'")
        end

        def double_quotes?(arg)
          quotes?(arg, '"')
        end

        def quotes?(arg, quote)
          return false unless arg.str_type?

          arg_prev_position = arg.loc.begin.begin_pos
          arg.loc.expression.source_buffer.source[arg_prev_position] == quote
        end

        def exclude_type?(arg)
          return false if arg.str_type? || arg.sym_type?
          true
        end

        def arg_location(arg)
          begin_pos = arg.loc.begin.begin_pos
          end_pos = arg.loc.expression.end_pos

          Parser::Source::Range.new(arg.loc.expression.source_buffer,
                                    begin_pos, end_pos)
        end

        def arg_content(arg)
          if arg.sym_type?
            arg.to_a.first.to_s
          elsif arg.str_type?
            arg.str_content
          end
        end
      end
    end
  end
end
