describe RuboCop::Cop::Gemfile::SortGemAscending, :config  do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) {
    {
      "TopGems" => top_gems,
    }
  }
  let(:top_gems) { [] }

  context "With ascending 1" do
    let(:source) do
      <<-RUBY
source "https://rubygems.org"

gem "bundler"
gem "rails"
      RUBY
    end

    it_behaves_like "no offences"
  end

  context "With ascending 2" do
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

    it_behaves_like "no offences"
  end

  context "Without ascending 1" do
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
        expect(cop.messages).to eq ["gem should be sorted by ascending"]
        expect(cop.offenses.size).to eq 1
        expect(cop.highlights).to eq([%q(gem "bundler")])
      end
    end

    it "auto-correct" do
      new_source = autocorrect_source(cop, source)
      expect(new_source).to eq(expected_source)
    end
  end

  context "Without ascending 2" do
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
        expect(cop.messages).to eq ["gem should be sorted by ascending", "gem should be sorted by ascending"]
        expect(cop.offenses.size).to eq 2
        expect(cop.highlights).to eq([%q(gem 'pg', '~> 0.18'), %q(gem 'coffee-rails', '~> 4.2')])
      end
    end

    it "auto-correct" do
      new_source = autocorrect_source(cop, source)
      expect(new_source).to eq(expected_source)
    end
  end

  context "Without ascending 3" do
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
        expect(cop.messages).to eq ["gem 'rails' should be top of Gemfile", "gem should be sorted by ascending"]
        expect(cop.offenses.size).to eq 2
        expect(cop.highlights).to eq([%q(gem 'rails', '~> 5.0.0', '>= 5.0.0.1'), %q(gem 'coffee-rails', '~> 4.2')])
      end
    end

    it "auto-correct" do
      new_source = autocorrect_source(cop, source)
      expect(new_source).to eq(expected_source)
    end
  end

  context "contains group block" do
    context "With ascending 1" do
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

      it_behaves_like "no offences"
    end

    context "Without ascending 1" do
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
          expect(cop.messages).to eq ["gem should be sorted by ascending"]
          expect(cop.offenses.size).to eq 1
          expect(cop.highlights).to eq([%q(gem "factory_girl")])
        end
      end

      it "auto-correct" do
        new_source = autocorrect_source(cop, source)
        expect(new_source).to eq(expected_source)
      end
    end
  end
end
