RSpec.shared_examples "no offences" do
  it "does not occur any offenses" do
    inspect_source(cop, source)

    aggregate_failures do
      expect(cop.messages).to be_empty
      expect(cop.offenses).to be_empty
    end
  end

  it "should not be changed with auto-correct" do
    new_source = autocorrect_source(cop, source)
    expect(new_source).to eq(source)
  end
end
