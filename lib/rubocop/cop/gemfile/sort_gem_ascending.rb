# frozen_string_literal: true

require 'rubocop/cop/gemfile/concerns/sort_gem_ascending/autocorrect'
require 'rubocop/cop/gemfile/concerns/sort_gem_ascending/on_begin'

module RuboCop
  module Cop
    module Gemfile
      # This cop makes sure that `gem` is sorted by ascending
      #
      # @example
      #   # TopGems: []
      #
      #   # bad
      #   gem "sass-rails"
      #   gem "coffee-rails"
      #
      #   # good
      #   gem "coffee-rails"
      #   gem "sass-rails"
      #
      #   # TopGems:
      #   #   - rails
      #
      #   # bad
      #   gem "coffee-rails"
      #   gem "rails"
      #   gem "sass-rails"
      #
      #   # good
      #   gem "rails"
      #   gem "coffee-rails"
      #   gem "sass-rails"
      class SortGemAscending < Cop
        MSG = 'gem should be sorted by ascending'.freeze

        include RuboCop::Cop::Gemfile::Concerns::SortGemAscending::Autocorrect
        include RuboCop::Cop::Gemfile::Concerns::SortGemAscending::OnBegin

        def on_begin(node)
          gems = string_arg_gems(node)

          gems.each_cons(2) do |gem1, gem2|
            check_gems_order(node, gem1, gem2)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            gems        = string_arg_gems(node)
            sorted_gems = gems.sort_by do |gem|
              sort_key = top_gem?(gem) ? 0 : 1
              [sort_key, gem_name(gem)]
            end

            correct_gems(corrector, gems, sorted_gems)
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

        def top_gems
          @top_gems ||= Array(cop_config['TopGems'])
        end

        def top_gem?(gem)
          gem_name =
            if gem.is_a?(RuboCop::Node)
              gem_name(gem)
            else
              gem
            end

          top_gems.include?(gem_name)
        end
      end
    end
  end
end
