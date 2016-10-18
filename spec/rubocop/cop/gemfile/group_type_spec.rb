describe RuboCop::Cop::Gemfile::GroupType, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) {
    {
      "EnforcedStyle" => enforced_style,
      "SupportedStyles" => %w(Symbol String),
    }
  }

  context "group" do
    context "Symbol group" do
      let(:source) do
        <<-RUBY
group :test do
end
        RUBY
      end

      context "EnforcedStyle: Symbol" do
        let(:enforced_style) { "Symbol" }

        it_behaves_like "no offences"
      end

      context "EnforcedStyle: String" do
        let(:enforced_style) { "String" }

        it do
          inspect_source(cop, source)

          aggregate_failures do
            expect(cop.messages).to eq ["Use String group"]
            expect(cop.offenses.size).to eq 1
            expect(cop.highlights).to eq([%q(:test)])
          end
        end
      end
    end

    context "String group" do
      let(:source) do
        <<-RUBY
group 'test' do
end
        RUBY
      end

      context "EnforcedStyle: Symbol" do
        let(:enforced_style) { "Symbol" }

        it do
          inspect_source(cop, source)

          aggregate_failures do
            expect(cop.messages).to eq ["Use Symbol group"]
            expect(cop.offenses.size).to eq 1
            expect(cop.highlights).to eq([%q('test')])
          end
        end
      end

      context "EnforcedStyle: String" do
        let(:enforced_style) { "String" }

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

      context "EnforcedStyle: Symbol" do
        let(:enforced_style) { "Symbol" }

        it_behaves_like "no offences"
      end

      context "EnforcedStyle: String" do
        let(:enforced_style) { "String" }

        it_behaves_like "no offences"
      end
    end
  end
end
