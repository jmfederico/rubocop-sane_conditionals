# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::Style::NoUnless, :config do
  # Multi-line unless

  it 'flags a simple multi-line unless' do
    expect_offense(<<~RUBY)
      unless foo
      ^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        bar
      end
    RUBY

    expect_correction(<<~RUBY)
      if !foo
        bar
      end
    RUBY
  end

  it 'flags unless with an else branch' do
    expect_offense(<<~RUBY)
      unless foo
      ^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        bar
      else
        baz
      end
    RUBY

    expect_correction(<<~RUBY)
      if !foo
        bar
      else
        baz
      end
    RUBY
  end

  it 'flags a complex condition in unless, adding parens because precedence is not a toy' do
    expect_offense(<<~RUBY)
      unless foo && bar
      ^^^^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        do_thing
      end
    RUBY

    expect_correction(<<~RUBY)
      if !(foo && bar)
        do_thing
      end
    RUBY
  end

  it 'flags a complex or-condition in unless, adding parens because precedence is not a toy' do
    expect_offense(<<~RUBY)
      unless foo || bar
      ^^^^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        do_thing
      end
    RUBY

    expect_correction(<<~RUBY)
      if !(foo || bar)
        do_thing
      end
    RUBY
  end

  it 'flags indented unless blocks, preserving indentation' do
    expect_offense(<<~RUBY)
      def check
        unless ready?
        ^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
          go
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      def check
        if !ready?
          go
        end
      end
    RUBY
  end

  # Modifier unless

  it 'flags modifier unless' do
    expect_offense(<<~RUBY)
      bar unless foo
      ^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
    RUBY

    expect_correction(<<~RUBY)
      if !foo
        bar
      end
    RUBY
  end

  it 'flags modifier unless with a complex condition, adding parens because precedence is not a toy' do
    expect_offense(<<~RUBY)
      send_email unless already_sent? || suppressed?
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
    RUBY

    expect_correction(<<~RUBY)
      if !(already_sent? || suppressed?)
        send_email
      end
    RUBY
  end

  it 'flags modifier unless with a comparison, adding parens because precedence is not a toy' do
    expect_offense(<<~RUBY)
      return unless date < Time.zone.today
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
    RUBY

    expect_correction(<<~RUBY)
      if !(date < Time.zone.today)
        return
      end
    RUBY
  end

  it 'flags multi-line unless with a comparison operator' do
    expect_offense(<<~RUBY)
      unless count >= 10
      ^^^^^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        do_thing
      end
    RUBY

    expect_correction(<<~RUBY)
      if !(count >= 10)
        do_thing
      end
    RUBY
  end

  it 'flags unless with subscript access without adding unnecessary parens' do
    expect_offense(<<~RUBY)
      unless slice[:symbol]
      ^^^^^^^^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        do_thing
      end
    RUBY

    expect_correction(<<~RUBY)
      if !slice[:symbol]
        do_thing
      end
    RUBY
  end

  it 'flags unless with equality check, adding parens' do
    expect_offense(<<~RUBY)
      unless status == :active
      ^^^^^^^^^^^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        deactivate
      end
    RUBY

    expect_correction(<<~RUBY)
      if !(status == :active)
        deactivate
      end
    RUBY
  end

  it 'flags unless with regex match operator, adding parens' do
    expect_offense(<<~RUBY)
      unless str =~ /pattern/
      ^^^^^^^^^^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        do_thing
      end
    RUBY

    expect_correction(<<~RUBY)
      if !(str =~ /pattern/)
        do_thing
      end
    RUBY
  end

  it 'flags unless with spaceship operator, adding parens' do
    expect_offense(<<~RUBY)
      unless (a <=> b) == 0
      ^^^^^^^^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        do_thing
      end
    RUBY

    expect_correction(<<~RUBY)
      if !((a <=> b) == 0)
        do_thing
      end
    RUBY
  end

  it 'flags unless with arithmetic, adding parens' do
    expect_offense(<<~RUBY)
      unless a + b
      ^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        do_thing
      end
    RUBY

    expect_correction(<<~RUBY)
      if !(a + b)
        do_thing
      end
    RUBY
  end

  it 'flags unless with method call without adding unnecessary parens' do
    expect_offense(<<~RUBY)
      unless foo.bar?
      ^^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        do_thing
      end
    RUBY

    expect_correction(<<~RUBY)
      if !foo.bar?
        do_thing
      end
    RUBY
  end

  it 'flags unless with chained method call without adding unnecessary parens' do
    expect_offense(<<~RUBY)
      unless foo.bar.baz?
      ^^^^^^^^^^^^^^^^^^^ Use negated `if` instead of `unless`. Your future self will thank you. Your colleagues will thank you. English teachers need not apply.
        do_thing
      end
    RUBY

    expect_correction(<<~RUBY)
      if !foo.bar.baz?
        do_thing
      end
    RUBY
  end

  # Clean code — should not be flagged

  it 'does not flag a plain if' do
    expect_no_offenses(<<~RUBY)
      if foo
        bar
      end
    RUBY
  end

  it 'does not flag a negated if' do
    expect_no_offenses(<<~RUBY)
      if !foo
        bar
      end
    RUBY
  end

  it 'does not flag a modifier if' do
    expect_no_offenses(<<~RUBY)
      bar if foo
    RUBY
  end
end
