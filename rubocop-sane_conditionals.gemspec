# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'rubocop-sane_conditionals'
  spec.version = '1.0.0'
  spec.authors = ['Federico']
  spec.summary = 'RuboCop cops for humans who can read.'
  spec.description = <<~DESC
    Enforces conditional style that does not require you to hold the entire
    sentence in working memory while your brain tries to figure out what
    "do_thing if !foo unless bar" means. It means you hate your colleagues.
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
