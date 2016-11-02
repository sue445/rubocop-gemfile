# frozen_string_literal: true
module RuboCop
  module Cop
    module Gemfile
      module Concerns
        module SortGemAscending
          module OnBegin # rubocop:disable Style/Documentation
            private

            def check_gems_order(node, gem1, gem2)
              if top_gem?(gem1) == top_gem?(gem2)
                check_gems_order_in_same_priority(node, gem1, gem2)
              elsif !top_gem?(gem1) && top_gem?(gem2)
                add_offense(node, gem2.loc.expression,
                            "gem '#{gem_name(gem2)}' should be top of Gemfile")
              end
            end

            def check_gems_order_in_same_priority(node, gem1, gem2)
              gem_name1 = gem_name(gem1)
              gem_name2 = gem_name(gem2)
              add_offense(node, gem2.loc.expression) if gem_name1 > gem_name2
            end
          end
        end
      end
    end
  end
end
