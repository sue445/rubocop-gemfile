require 'spec_helper'

describe Rubocop::Gemfile do
  it 'has a version number' do
    expect(Rubocop::Gemfile::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
