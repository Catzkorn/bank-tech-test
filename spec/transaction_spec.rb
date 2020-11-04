require "transaction"

describe Transaction do
  describe "date" do
    it "returns an date object" do
      transaction = Transaction.new(20, "credit")
      expect(transaction.date).to be_instance_of(Date)
    end

    it "returns the inputted date" do
      time = Time.now
      transaction = Transaction.new(20, "credit", time)
      expect(transaction.date).to eq time
    end
  end

  describe "type" do
    it "returns credit as the type of transaction" do
      transaction = Transaction.new(50, "credit")
      expect(transaction.type).to eq "credit"
    end

    it "returns debit as the type of transaction" do
      transaction = Transaction.new(50, "debit")
      expect(transaction.type).to eq "debit"
    end
  end
end
