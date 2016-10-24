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
          gems = node.children.select{ |n| gem_type?(n) }
          gems.each_cons(2) do |gem1, gem2|
            gem_name1 = gem_name(gem1)
            gem_name2 = gem_name(gem2)

            next if !gem_name1 || !gem_name2

            add_offense(node, gem2.loc.expression) if gem_name1 > gem_name2
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            gems = node.children.select{ |n| gem_type?(n) }
            string_arg_gems = gems.select { |gem| gem_name(gem)  }
            sorted_gems     = string_arg_gems.sort_by { |gem| gem_name(gem) }

            string_arg_gems_enum = string_arg_gems.to_enum
            sorted_gems_enum     = sorted_gems.to_enum

            loop do
              string_arg_gem = string_arg_gems_enum.next
              sorted_gem     = sorted_gems_enum.next

              unless string_arg_gem == sorted_gem
                corrector.replace(string_arg_gem.loc.expression, sorted_gem.source)
              end
            end
          end
        end

        private

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
