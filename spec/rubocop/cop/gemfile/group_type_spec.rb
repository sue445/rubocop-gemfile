describe RuboCop::Cop::Gemfile::GroupType, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) {
    {
      "EnforcedStyle" => enforced_style,
      "SupportedStyles" => %w(symbol single_quotes double_quotes),
    }
  }

  context "group" do
    context "symbol group" do
      let(:source) do
        <<-RUBY
group :test do
end
        RUBY
      end

      context "EnforcedStyle: symbol" do
        let(:enforced_style) { "symbol" }

        it_behaves_like "no offences"
      end

      context "EnforcedStyle: single_quotes" do
        let(:enforced_style) { "single_quotes" }

        let(:expected_source) do
          <<-RUBY
group 'test' do
end
          RUBY
        end

        it do
          inspect_source(cop, source)

          aggregate_failures do
            expect(cop.messages).to eq ["Use single_quotes group"]
            expect(cop.offenses.size).to eq 1
            expect(cop.highlights).to eq([%q(:test)])
          end
        end

        it "auto-correct" do
          new_source = autocorrect_source(cop, source)
          expect(new_source).to eq(expected_source)
        end
      end

      context "EnforcedStyle: double_quotes" do
        let(:enforced_style) { "double_quotes" }

        let(:expected_source) do
          <<-RUBY
group "test" do
end
          RUBY
        end

        it do
          inspect_source(cop, source)

          aggregate_failures do
            expect(cop.messages).to eq ["Use double_quotes group"]
            expect(cop.offenses.size).to eq 1
            expect(cop.highlights).to eq([%q(:test)])
          end
        end

        it "auto-correct" do
          new_source = autocorrect_source(cop, source)
          expect(new_source).to eq(expected_source)
        end
      end
    end

    context "single_quotes group" do
      let(:source) do
        <<-RUBY
group 'test' do
end
        RUBY
      end

      context "EnforcedStyle: symbol" do
        let(:enforced_style) { "symbol" }

        let(:expected_source) do
          <<-RUBY
group :test do
end
          RUBY
        end

        it do
          inspect_source(cop, source)

          aggregate_failures do
            expect(cop.messages).to eq ["Use symbol group"]
            expect(cop.offenses.size).to eq 1
            expect(cop.highlights).to eq([%q('test')])
          end
        end

        it "auto-correct" do
          new_source = autocorrect_source(cop, source)
          expect(new_source).to eq(expected_source)
        end
      end

      context "EnforcedStyle: single_quotes" do
        let(:enforced_style) { "single_quotes" }

        it_behaves_like "no offences"
      end

      context "EnforcedStyle: double_quotes" do
        let(:enforced_style) { "double_quotes" }

        let(:expected_source) do
          <<-RUBY
group "test" do
end
          RUBY
        end

        it do
          inspect_source(cop, source)

          aggregate_failures do
            expect(cop.messages).to eq ["Use double_quotes group"]
            expect(cop.offenses.size).to eq 1
            expect(cop.highlights).to eq([%q('test')])
          end
        end

        it "auto-correct" do
          new_source = autocorrect_source(cop, source)
          expect(new_source).to eq(expected_source)
        end
      end
    end

    context "double_quotes group" do
      let(:source) do
        <<-RUBY
group "test" do
end
        RUBY
      end

      context "EnforcedStyle: symbol" do
        let(:enforced_style) { "symbol" }

        let(:expected_source) do
          <<-RUBY
group :test do
end
          RUBY
        end

        it do
          inspect_source(cop, source)

          aggregate_failures do
            expect(cop.messages).to eq ["Use symbol group"]
            expect(cop.offenses.size).to eq 1
            expect(cop.highlights).to eq([%q("test")])
          end
        end

        it "auto-correct" do
          new_source = autocorrect_source(cop, source)
          expect(new_source).to eq(expected_source)
        end
      end

      context "EnforcedStyle: single_quotes" do
        let(:enforced_style) { "single_quotes" }

        let(:expected_source) do
          <<-RUBY
group 'test' do
end
          RUBY
        end

        it do
          inspect_source(cop, source)

          aggregate_failures do
            expect(cop.messages).to eq ["Use single_quotes group"]
            expect(cop.offenses.size).to eq 1
            expect(cop.highlights).to eq([%q("test")])
          end
        end

        it "auto-correct" do
          new_source = autocorrect_source(cop, source)
          expect(new_source).to eq(expected_source)
        end
      end

      context "EnforcedStyle: double_quotes" do
        let(:enforced_style) { "double_quotes" }

        it_behaves_like "no offences"
      end
    end

    context "variable group" do
      let(:source) do
        <<-RUBY
name = :test
group name do
end
        RUBY
      end

      context "EnforcedStyle: symbol" do
        let(:enforced_style) { "symbol" }

        it_behaves_like "no offences"
      end

      context "EnforcedStyle: single_quotes" do
        let(:enforced_style) { "single_quotes" }

        it_behaves_like "no offences"
      end

      context "EnforcedStyle: double_quotes" do
        let(:enforced_style) { "double_quotes" }

        it_behaves_like "no offences"
      end
    end
  end
end
