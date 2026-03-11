# frozen_string_literal: true

require 'rubocop'
require_relative 'rubocop-sane_conditionals/version'
require_relative 'rubocop/cop/style/no_unless'
require_relative 'rubocop/cop/style/if_unless_modifier_multiline'

if defined?(Rake)
  RuboCop::RakeTask
end
