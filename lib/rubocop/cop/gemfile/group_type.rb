# frozen_string_literal: true

module RuboCop
  module Cop
    module Gemfile
      # This cop makes sure that `group` has symbol group name
      #
      # @example
      #
      #   EnforcedStyle: symbol
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
      #   EnforcedStyle: single_quotes
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
      #   EnforcedStyle: double_quotes
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
            when "symbol"
              add_offense(node, arg.loc.expression, message) if arg.str_type?
            when "double_quotes"
              add_offense(node, arg.loc.expression, message) if arg.sym_type? || single_quotes?(arg)
            when "single_quotes"
              add_offense(node, arg.loc.expression, message) if arg.sym_type? || double_quotes?(arg)
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
      end
    end
  end
end
