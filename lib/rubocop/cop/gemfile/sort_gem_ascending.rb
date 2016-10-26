# frozen_string_literal: true

module RuboCop
  module Cop
    module Gemfile
      # This cop makes sure that `gem` is sorted by ascending
      #
      # @example
      #   # bad
      #   gem "sass-rails"
      #   gem "coffee-rails"
      #
      #   # good
      #   gem "coffee-rails"
      #   gem "sass-rails"
      class SortGemAscending < Cop
        MSG = "gem should be sorted by ascending".freeze

        def on_begin(node)
          gems = string_arg_gems(node)
          gems.each_cons(2) do |gem1, gem2|
            gem_name1 = gem_name(gem1)
            gem_name2 = gem_name(gem2)

            add_offense(node, gem2.loc.expression) if gem_name1 > gem_name2
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            gems        = string_arg_gems(node)
            sorted_gems = gems.sort_by { |gem| gem_name(gem) }

            gems_enum        = gems.to_enum
            sorted_gems_enum = sorted_gems.to_enum

            loop do
              gem        = gems_enum.next
              sorted_gem = sorted_gems_enum.next

              unless gem == sorted_gem
                corrector.replace(gem.loc.expression, sorted_gem.source)
              end
            end
          end
        end

        private

        def string_arg_gems(node)
          gems = node.children.select { |n| gem_type?(n) }
          gems.select { |gem| gem_name(gem) }
        end

        def gem_type?(node)
          _, method_name, *_args = *node
          method_name == :gem
        end

        def gem_name(node)
          _, method_name, *args = *node

          return nil unless method_name == :gem

          arg = args.first
          return nil unless arg
          return nil unless arg.str_type?

          arg.str_content
        end
      end
    end
  end
end
