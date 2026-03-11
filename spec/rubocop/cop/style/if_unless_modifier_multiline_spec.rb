# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::Style::IfUnlessModifierMultiline, :config do
  # Modifier if — should be flagged

  it 'flags a simple modifier if' do
    expect_offense(<<~RUBY)
      do_something if condition
      ^^^^^^^^^^^^^^^^^^^^^^^^^ Convert modifier `if` to multi-line form. Reading left-to-right is a feature, not a suggestion.
    RUBY

    expect_correction(<<~RUBY)
      if condition
        do_something
      end
    RUBY
  end

  it 'flags a modifier if with a method call condition' do
    expect_offense(<<~RUBY)
      send_notification if user.active?
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Convert modifier `if` to multi-line form. Reading left-to-right is a feature, not a suggestion.
    RUBY

    expect_correction(<<~RUBY)
      if user.active?
        send_notification
      end
    RUBY
  end

  it 'flags a modifier if with a complex condition' do
    expect_offense(<<~RUBY)
      destroy! if admin? && confirmed?
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Convert modifier `if` to multi-line form. Reading left-to-right is a feature, not a suggestion.
    RUBY

    expect_correction(<<~RUBY)
      if admin? && confirmed?
        destroy!
      end
    RUBY
  end

  it 'flags an indented modifier if and preserves indentation' do
    expect_offense(<<~RUBY)
      def run
        cleanup if done?
        ^^^^^^^^^^^^^^^^ Convert modifier `if` to multi-line form. Reading left-to-right is a feature, not a suggestion.
      end
    RUBY

    expect_correction(<<~RUBY)
      def run
        if done?
          cleanup
        end
      end
    RUBY
  end

  # Clean code — should not be flagged

  it 'does not flag a standard multi-line if' do
    expect_no_offenses(<<~RUBY)
      if condition
        do_something
      end
    RUBY
  end

  it 'does not flag a multi-line if/else' do
    expect_no_offenses(<<~RUBY)
      if condition
        do_something
      else
        do_other_thing
      end
    RUBY
  end

  # Modifier unless is NOT this cop's job — NoUnless handles it
  # and will also expand it. No double-reporting.

  it "does not flag modifier unless (that is NoUnless's problem)" do
    expect_no_offenses(<<~RUBY)
      bar unless foo
    RUBY
  end
end
