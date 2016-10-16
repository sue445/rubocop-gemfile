# frozen_string_literal: true

module RuboCop
  module Cop
    module Gemfile
      class GroupSingleEnvironment < Cop
        MSG = '`group` should not have multiple environments'.freeze

        def on_def(node)
          # TODO
        end
      end
    end
  end
end
