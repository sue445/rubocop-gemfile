module RuboCop
  module Cop
    module Gemfile
      module Concerns
        module SortGemAscending
          module Autocorrect
            private

            def correct_gems(corrector, gems, sorted_gems)
              gems_enum = gems.to_enum
              sorted_gems_enum = sorted_gems.to_enum

              loop do
                gem = gems_enum.next
                sorted_gem = sorted_gems_enum.next

                unless gem == sorted_gem
                  corrector.replace(gem.loc.expression, sorted_gem.source)
                end
              end
            end
          end
        end
      end
    end
  end
end
