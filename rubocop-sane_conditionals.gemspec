# frozen_string_literal: true

require_relative 'lib/rubocop-sane_conditionals/version'

Gem::Specification.new do |spec|
  spec.name = 'rubocop-sane_conditionals'
  spec.version = RuboCop::SaneConditionals::VERSION
  spec.authors = ['Federico']
  spec.summary = 'RuboCop cops for people who want to read code, not decode it.'
  spec.description = <<~DESC
    Ruby is a beautiful language. It is expressive, elegant, and reads almost like
    English. This is exactly the problem.

    At some point, someone decided that because Ruby can read like English, it
    should read like English - and then they implemented the wrong kind of
    English. The kind where the subject comes last.

    This gem provides RuboCop cops that ban `unless` and multiline modifier
    conditionals, replacing them with explicit `if` forms that are easier to
    read, reason about, and review without mentally untangling a sentence that
    somebody wrote backwards and then had the nerve to commit.
  DESC
  spec.homepage = 'https://github.com/jmfederico/rubocop-sane_conditionals'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0'

  spec.files = Dir[
    'lib/**/*.rb',
    'config/default.yml',
    'README.md',
    'LICENSE.txt'
  ]

  spec.require_paths = ['lib']

  spec.add_dependency 'rubocop', '~> 1.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
