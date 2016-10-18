# frozen_string_literal: true

module RuboCop
  module Cop
    module Gemfile
      # This cop makes sure that `group` has symbol group name
      #
      # @example
      #
      #   EnforcedStyle: Symbol
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
      #   EnforcedStyle: String
      #
      #   # bad
      #   group :test do
      #     gem "rspec-rails"
      #   end
      #
      #   # good
      #   group "test" do
      #     gem "rspec-rails"
      #   end
      #
      #   group 'test' do
      #     gem "rspec-rails"
      #   end
      class GroupType < Cop
        MSG = 'Use %s group'.freeze

        def on_send(node)
          _, method_name, *args = *node

          return unless method_name == :group

          enforced_style = cop_config["EnforcedStyle"]
          unless cop_config["SupportedStyles"].include?(enforced_style)
            raise ValidationError, "EnforcedStyle(#{enforced_style}) is not neither String or Symbol"
          end

          message = MSG % enforced_style

          args.each do |arg|
            case enforced_style
            when "Symbol"
              add_offense(node, arg.loc.expression, message) if arg.str_type?
            when "String"
              add_offense(node, arg.loc.expression, message) if arg.sym_type?
            end
          end
        end
      end
    end
  end
end
