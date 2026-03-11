# rubocop-sane_conditionals

RuboCop cops for people who want to read code, not decode it.

## The Problem

Ruby is a beautiful language. It is expressive, elegant, and reads almost like
English. This is exactly the problem.

At some point, someone decided that because Ruby *can* read like English, it
*should* read like English — and then they implemented the wrong kind of
English. The kind where the subject comes last. The kind you have to read
backwards. The kind that makes you go:

```ruby
send_email unless already_sent?
```

Cool. So do we send the email, or do we not? Let me just... hold that `send_email`
in working memory while I parse `unless`... flip the boolean in my head...
re-check the variable name... oh. OH. We send the email when `already_sent?` is
`false`. Got it. Only took 600ms and a small cortisol spike.

And then there is:

```ruby
destroy! if admin? && confirmed?
```

This one is great. Your eye lands on `destroy!`. Your adrenal gland fires.
Your hand moves toward the keyboard. Then you read `if admin? && confirmed?`
and you relax. But the damage is done. Your heart rate is up. You have aged
slightly. The code has won.

This gem fights back.

## What It Does

### `Style/NoUnless`

Bans `unless` in all its forms. Replaces it with a negated `if`.

`unless` is syntactic sugar. Sugar is fine in coffee. Sugar is not fine when
you are trying to understand whether a background job is going to run or not
at 11pm during an incident.

```ruby
# Before (your colleagues wrote this)
unless user.banned?
  grant_access
end

# After (the cop wrote this)
if !user.banned?
  grant_access
end
```

Yes, `!condition` looks slightly more aggressive. It is slightly more
aggressive. That is the point. You are negating something. Own it.

When the condition is compound, the parens come with it:

```ruby
# Before (your colleagues wrote this)
unless user.banned? && account.locked?
  grant_access
end

# After (the cop wrote this)
if !(user.banned? && account.locked?)
  grant_access
end
```

```ruby
# Before (someone thought this was clever)
render_page unless maintenance_mode?

# After
if !maintenance_mode?
  render_page
end
```

**"But `unless foo` is so readable!"**

It is readable the first time. The fourteenth time you see it in a file, your
brain has learned to pattern-match it and skip the inversion step — which means
you are now *silently wrong* about what the code does until you stop and
actually re-read it. Congratulations on training yourself to make subtle errors
efficiently.

### `Style/IfUnlessModifierMultiline`

Bans modifier `if`. Expands it to a normal `if` block.

Modifier `if` is a style borrowed from Perl. If you are taking style advice
from Perl, please close this README and reconsider your choices.

```ruby
# Before (you thought you were saving lines)
do_the_thing if condition_is_met?

# After (you are saving brain cells instead)
if condition_is_met?
  do_the_thing
end
```

The argument for modifier `if` is always "it's more concise." This is true.
It is also more concise to write variable names as single letters, skip
comments entirely, and put everything on one line. Conciseness is not the
goal. Clarity is the goal.

When you write `do_thing if bar`, a reader must:

1. Parse `do_thing`
2. Begin forming the intention "ok, we do the thing"
3. Hit `if`
4. Backtrack
5. Parse `bar`
6. Decide whether to do the thing
7. Wonder why this person hates them

When you write `if bar` on its own line, a reader:

1. Parses `if bar`
2. Decides whether to enter the block
3. Does or does not enter the block
4. Goes home at a reasonable hour

Note: modifier `unless` (`do_thing unless bar`) is also banned, but by
`Style/NoUnless`. It is doubly bad — it is both backwards *and* inverted — and
it gets its own cop because it deserves special attention.

## Installation

Add this to your `Gemfile`:

```ruby
gem "rubocop-sane_conditionals", require: false
```

Then add this to your `.rubocop.yml`:

```yaml
require:
  - rubocop-sane_conditionals

Style/NoUnless:
  Enabled: true

Style/IfUnlessModifierMultiline:
  Enabled: true
```

Run `bundle exec rubocop --autocorrect` and let the gem fix your codebase
while you make tea and quietly reflect on past decisions.

## FAQ

**Q: Isn't `unless` idiomatic Ruby?**

A: Yes. So is `BEGIN`, `$PROGRAM_NAME`, and the flip-flop operator. Idiomatic
does not mean good. It means common. A lot of common things are bad.

**Q: My team loves `unless`. They will push back.**

A: Show them this gem. If they still push back, that is useful information
about your team.

**Q: What about `if !foo`? Isn't `unless foo` cleaner?**

A: No. `if !foo` is a complete, unambiguous statement. `unless foo` requires
the reader to know that `unless` means `if not`, apply that transformation,
and then continue. This is one extra step. Over a long career, these extra
steps add up to a measurable amount of time you could have spent doing
something else.

**Q: Why does `unless foo && bar` become `if !(foo && bar)` instead of `if !foo && !bar`?**

A: Because that would be wrong. De Morgan's law says `!(A && B)` equals
`!A || !B`, not `!A && !B`. The cop is not here to do your boolean algebra
for you. It is here to make the negation visible. The parens make it clear
that the whole compound condition is being negated, which is exactly what
`unless` was hiding.

**Q: You seem angry about this.**

A: I am not angry. I am tired. There is a difference. One of them requires
backtracking to determine the meaning.

## License

MIT. Use it. Improve it. Inflict it on your colleagues.
