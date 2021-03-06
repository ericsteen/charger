require_relative "../../../lib/customers/card"

describe Charger::Card do
  let(:luhn_data) do
    [
      [49927398716, true],
      [49927398717, false],
      [1234567812345678, false],
      [1234567812345670, true]
    ]
  end
  subject { described_class.new(number: "4111111111111111", limit: 10_000) }

  it "#charge adds to balance" do
    expect { subject.charge(10) }.to change {subject.balance}.by(10)
  end

  it "#charge raising balance above limit are ignored" do
    expect { subject.charge(20_000) }.to change {subject.balance}.by(0)
  end

  it "#credits dropping balance below $0 create a negative balance" do
    amt = 10_000
    expect(subject.balance).to eq(0)
    subject.credit(amt)
    expect(subject.balance).to eq(-amt)
  end

  it "#credits subtracts from balance" do
    expect { subject.credit(10) }.to change {subject.balance}.by(-10)
  end

  it "validates cards based on luhn 10" do
    luhn_data.each do |data|
      subject.number = data.first.to_s
      expect(subject.send(:luhn_check, subject.number)).to eq(data.last)
    end
  end
end
