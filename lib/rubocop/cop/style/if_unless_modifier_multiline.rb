# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Disallows modifier `if` (i.e. `foo if bar`) and converts it to a
      # standard multi-line `if` block.
      #
      # Modifier `if` reads right-to-left: your eye hits `foo`, your brain
      # starts processing "ok, we do foo", then hits `if bar` and has to
      # backtrack. Congratulations, you have implemented a for-loop in a
      # human brain. It will crash.
      #
      # Note: modifier `unless` is handled separately by `Style/NoUnless`.
      # Don't worry, it's also banned.
      #
      # @example
      #   # bad
      #   do_something if condition
      #
      #   # good
      #   if condition
      #     do_something
      #   end
      class IfUnlessModifierMultiline < Base
        extend AutoCorrector

        MSG = 'Convert modifier `if` to multi-line form. Reading left-to-right ' \
              'is a feature, not a suggestion.'

        def on_if(node)
          if !node.modifier_form?
            return
          end

          if node.unless?
            return
          end

          add_offense(node) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        def autocorrect(corrector, node)
          condition = node.condition.source
          body = node.body.source
          indentation = ' ' * node.loc.column

          replacement = <<~RUBY.chomp
            if #{condition}
            #{indentation}  #{body}
            #{indentation}end
          RUBY

          corrector.replace(node, replacement)
        end
      end
    end
  end
end
