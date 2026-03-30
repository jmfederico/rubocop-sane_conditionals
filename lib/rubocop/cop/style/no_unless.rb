# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Disallows `unless` in all its forms and replaces it with a negated `if`.
      #
      # `unless` is syntactic sugar that requires the reader to mentally invert
      # the condition. This is fine if your reader is a compiler. Your reader is
      # not a compiler. Your reader is a tired human at 4pm on a Friday who just
      # wants to know whether the code runs the thing or does not run the thing.
      #
      # @example
      #   # bad
      #   unless foo
      #     bar
      #   end
      #
      #   # good
      #   if !foo
      #     bar
      #   end
      #
      #   # bad
      #   unless foo && bar
      #     baz
      #   end
      #
      #   # good
      #   if !(foo && bar)
      #     baz
      #   end
      #
      #   # bad
      #   bar unless foo
      #
      #   # good
      #   if !foo
      #     bar
      #   end
      class NoUnless < Base
        extend AutoCorrector

        MSG = 'Use negated `if` instead of `unless`. Your future self will thank you. ' \
              'Your colleagues will thank you. English teachers need not apply.'

        def on_if(node)
          if !node.unless?
            return
          end

          add_offense(node) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        def autocorrect(corrector, node)
          condition_node = node.condition
          condition_source = condition_node.source

          negated_condition = if requires_parens?(condition_node)
                                "!(#{condition_source})"
                              else
                                "!#{condition_source}"
                              end

          if node.modifier_form?
            autocorrect_modifier(corrector, node, negated_condition)
          else
            autocorrect_multiline(corrector, node, negated_condition)
          end
        end

        def requires_parens?(condition_node)
          condition_node.and_type? || condition_node.or_type? ||
            (condition_node.send_type? && condition_node.binary_operation? &&
              !condition_node.method?(:[]))
        end

        def autocorrect_modifier(corrector, node, negated_condition)
          body = node.body.source
          indentation = ' ' * node.loc.column
          replacement = "if #{negated_condition}\n#{indentation}  #{body}\n#{indentation}end"
          corrector.replace(node, replacement)
        end

        def autocorrect_multiline(corrector, node, negated_condition)
          body_source = node.body.source
          indentation = ' ' * node.loc.column

          replacement = if node.else_branch
                          else_body = node.else_branch.source
                          <<~RUBY.chomp
                            if #{negated_condition}
                            #{indentation}  #{body_source}
                            #{indentation}else
                            #{indentation}  #{else_body}
                            #{indentation}end
                          RUBY
                        else
                          <<~RUBY.chomp
                            if #{negated_condition}
                            #{indentation}  #{body_source}
                            #{indentation}end
                          RUBY
                        end

          corrector.replace(node, replacement)
        end
      end
    end
  end
end
