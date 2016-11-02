# frozen_string_literal: true
module RuboCop
  module Cop
    module Gemfile
      module Concerns
        module SortGemAscending
          module Autocorrect # rubocop:disable Style/Documentation
            private

            def correct_gems(corrector, gems, sorted_gems)
              gems_enum = gems.to_enum
              sorted_gems_enum = sorted_gems.to_enum

              loop do
                gem = gems_enum.next
                sorted_gem = sorted_gems_enum.next

                next if gem == sorted_gem

                range  = range_with_prev_comment(gem)
                source = source_with_prev_comment(sorted_gem)
                corrector.replace(range, source)
              end
            end

            def source_with_prev_comment(gem)
              comments = line_comments[gem.loc.line - 1]
              return gem.source unless comments

              lines = comments.map(&:text)
              lines << gem.source
              lines.join("\n")
            end

            def range_with_prev_comment(gem)
              comments = line_comments[gem.loc.line - 1]
              return gem.loc.expression unless comments

              Parser::Source::Range.new(
                gem.loc.expression.source_buffer,
                begin_pos(comments.first), end_pos(gem)
              )
            end

            def begin_pos(node)
              node.loc.expression.begin.begin_pos
            end

            def end_pos(node)
              node.loc.expression.end_pos
            end

            # @return [Hash{Integer, Array<Parser::Source::Comment>}]
            def line_comments
              return @line_comments if @line_comments

              @line_comments =
                comment_groups.each_with_object({}) do |comments, hash|
                  comment_end_line = comments.last.loc.line
                  hash[comment_end_line] = comments
                end
            end

            def comment_groups
              comment_groups = []
              work = []
              processed_source.comments.each do |comment|
                if work.empty? || continuously_line?(work.last, comment)
                  work << comment
                else
                  comment_groups << work
                  work = [comment]
                end
              end
              comment_groups << work unless work.empty?
              comment_groups
            end

            def continuously_line?(first, second)
              first.loc.line + 1 == second.loc.line
            end
          end
        end
      end
    end
  end
end
