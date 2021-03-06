# frozen_string_literal: true
describe RuboCop::Cop::Gemfile::SortGemAscending, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) do
    {
      'TopGems' => top_gems
    }
  end
  let(:top_gems) { [] }

  context 'With ascending 1' do
    let(:source) do
      <<-RUBY
source "https://rubygems.org"

gem "bundler"
gem "rails"
      RUBY
    end

    it_behaves_like 'no offences'
  end

  context 'With ascending 2' do
    let(:source) do
      <<-RUBY
source "https://rubygems.org"

gem 'coffee-rails', '~> 4.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
      RUBY
    end

    it_behaves_like 'no offences'
  end

  context 'Without ascending 1' do
    let(:source) do
      <<-RUBY
source "https://rubygems.org"

gem "rails"
gem "bundler"
      RUBY
    end

    let(:expected_source) do
      <<-RUBY
source "https://rubygems.org"

gem "bundler"
gem "rails"
      RUBY
    end

    it do
      inspect_source(cop, source)

      aggregate_failures do
        expect(cop.messages).to eq ['gem should be sorted by ascending']
        expect(cop.offenses.size).to eq 1
        expect(cop.highlights).to eq(['gem "bundler"'])
      end
    end

    it 'auto-correct' do
      new_source = autocorrect_source(cop, source)
      expect(new_source).to eq(expected_source)
    end
  end

  context 'Without ascending 2' do
    let(:source) do
      <<-RUBY
source "https://rubygems.org"

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
      RUBY
    end

    let(:expected_source) do
      <<-RUBY
source "https://rubygems.org"

gem 'coffee-rails', '~> 4.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
      RUBY
    end

    it do
      inspect_source(cop, source)

      aggregate_failures do
        expect(cop.messages).to eq ['gem should be sorted by ascending',
                                    'gem should be sorted by ascending']
        expect(cop.offenses.size).to eq 2
        expect(cop.highlights).to eq(["gem 'pg', '~> 0.18'",
                                      "gem 'coffee-rails', '~> 4.2'"])
      end
    end

    it 'auto-correct' do
      new_source = autocorrect_source(cop, source)
      expect(new_source).to eq(expected_source)
    end
  end

  context 'Without ascending 3' do
    let(:top_gems) { %w(rails) }

    let(:source) do
      <<-RUBY
source "https://rubygems.org"

gem 'pg', '~> 0.18'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
      RUBY
    end

    let(:expected_source) do
      <<-RUBY
source "https://rubygems.org"

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'coffee-rails', '~> 4.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
      RUBY
    end

    it do
      inspect_source(cop, source)

      aggregate_failures do
        expect(cop.messages).to eq(["gem 'rails' should be top of Gemfile",
                                    'gem should be sorted by ascending'])
        expect(cop.offenses.size).to eq 2
        expect(cop.highlights).to eq(["gem 'rails', '~> 5.0.0', '>= 5.0.0.1'",
                                      "gem 'coffee-rails', '~> 4.2'"])
      end
    end

    it 'auto-correct' do
      new_source = autocorrect_source(cop, source)
      expect(new_source).to eq(expected_source)
    end
  end

  context 'contains group block' do
    context 'With ascending 1' do
      let(:source) do
        <<-RUBY
source "https://rubygems.org"

gem "bundler"
gem "rails"

group :test do
  gem "factory_girl"
  gem "rspec"
end
        RUBY
      end

      it_behaves_like 'no offences'
    end

    context 'Without ascending 1' do
      let(:source) do
        <<-RUBY
source "https://rubygems.org"

gem "bundler"
gem "rails"

group :test do
  gem "rspec"
  gem "factory_girl"
end
        RUBY
      end

      let(:expected_source) do
        <<-RUBY
source "https://rubygems.org"

gem "bundler"
gem "rails"

group :test do
  gem "factory_girl"
  gem "rspec"
end
        RUBY
      end

      it do
        inspect_source(cop, source)

        aggregate_failures do
          expect(cop.messages).to eq ['gem should be sorted by ascending']
          expect(cop.offenses.size).to eq 1
          expect(cop.highlights).to eq(['gem "factory_girl"'])
        end
      end

      it 'auto-correct' do
        new_source = autocorrect_source(cop, source)
        expect(new_source).to eq(expected_source)
      end
    end
  end

  context 'contains comment' do
    context 'With ascending' do
      let(:source) do
        <<-RUBY
source "https://rubygems.org"

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
        RUBY
      end

      it_behaves_like 'no offences'
    end

    context 'Without ascending' do
      let(:source) do
        <<-RUBY
source "https://rubygems.org"

# TODO: Keep always newest rails
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
        RUBY
      end

      let(:expected_source) do
        <<-RUBY
source "https://rubygems.org"

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# TODO: Keep always newest rails
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
        RUBY
      end

      it do
        inspect_source(cop, source)

        aggregate_failures do
          expect(cop.messages).to eq(['gem should be sorted by ascending',
                                      'gem should be sorted by ascending'])
          expect(cop.offenses.size).to eq 2
          expect(cop.highlights).to eq(["gem 'pg', '~> 0.18'",
                                        "gem 'coffee-rails', '~> 4.2'"])
        end
      end

      it 'auto-correct with gem comment' do
        new_source = autocorrect_source(cop, source)
        expect(new_source).to eq(expected_source)
      end
    end
  end
end
