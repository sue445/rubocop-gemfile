# frozen_string_literal: true

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

        ENFORCED_STYLE_SYMBOL        = "symbol".freeze
        ENFORCED_STYLE_DOUBLE_QUOTES = "double_quotes".freeze
        ENFORCED_STYLE_SINGLE_QUOTES = "single_quotes".freeze

        def on_send(node)
          _, method_name, *args = *node

          return unless method_name == :group

          enforced_style = cop_config["EnforcedStyle"]
          unless cop_config["SupportedStyles"].include?(enforced_style)
            raise ValidationError, "EnforcedStyle(#{enforced_style}) is not neither double_quotes, single_quotes or symbol"
          end

          message = MSG % enforced_style

          args.each do |arg|
            case enforced_style
            when ENFORCED_STYLE_SYMBOL
              add_offense(node, arg.loc.expression, message) if arg.str_type?
            when ENFORCED_STYLE_DOUBLE_QUOTES
              add_offense(node, arg.loc.expression, message) if arg.sym_type? || single_quotes?(arg)
            when ENFORCED_STYLE_SINGLE_QUOTES
              add_offense(node, arg.loc.expression, message) if arg.sym_type? || double_quotes?(arg)
            end
          end
        end

        def autocorrect(node)
          _receiver, _method_name, *args = *node

          case cop_config["EnforcedStyle"]
          when ENFORCED_STYLE_SYMBOL
            lambda do |corrector|
              args.each do |arg|
                content = arg_content(arg)
                corrector.replace(arg_location(arg), to_symbol_literal(content)) if content
              end
            end
          when ENFORCED_STYLE_DOUBLE_QUOTES
            lambda do |corrector|
              args.each do |arg|
                content = arg_content(arg)
                corrector.replace(arg_location(arg), content.inspect) if content
              end
            end
          when ENFORCED_STYLE_SINGLE_QUOTES
            lambda do |corrector|
              args.each do |arg|
                content = arg_content(arg)
                corrector.replace(arg_location(arg), to_string_literal(content)) if content
              end
            end
          end
        end

        private

        def single_quotes?(arg)
          quotes?(arg, "'")
        end

        def double_quotes?(arg)
          quotes?(arg, '"')
        end

        def quotes?(arg, quote)
          arg.str_type? && arg.loc.expression.source_buffer.source[arg.loc.begin.begin_pos] == quote
        end

        def arg_location(arg)
          begin_pos = arg.loc.begin.begin_pos
          end_pos = arg.loc.expression.end_pos
          Parser::Source::Range.new(arg.loc.expression.source_buffer, begin_pos, end_pos)
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
