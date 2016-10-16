require "rubocop"
require "rubocop/gemfile/version"
require "rubocop/gemfile/inject"

RuboCop::Gemfile::Inject.defaults!

# cops
require "rubocop/cop/gemfile/group_block_has_single_group"
