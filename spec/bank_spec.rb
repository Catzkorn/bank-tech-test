require "bank"

describe Bank do
  before(:each) do
    @account = Bank.new
    @tenthjan = Time.new(2012, 1, 10)
    @thirteenthjan = Time.new(2012, 1, 13)
  end

  describe "#deposit" do
    it "allows a customer to deposit money and view amount deposisted" do
      @account.deposit(1000, @tenthjan)
      expect(@account.statement).to eq("date || credit || debit || balance\n10/01/2012 || 1000.00 || || 1000.00")
    end

    it "raises an error if a negative balance deposit is made" do
      expect { @account.deposit(-20, @tenthjan) }.to raise_error("You cannot deposit an amount of 0 or less")
    end

    it "raises an error if a string is input as an amount" do
      expect { @account.deposit("hello!", @tenthjan).to raise_error("Inputted amount is not an integer") }
    end
  end

  describe "#withdraw" do
    it "allows a customer to withdraw money and view amount deposisted" do
      @account.deposit(1000, @tenthjan)
      @account.withdraw(500, @thirteenthjan)
      expect(@account.statement).to eq("date || credit || debit || balance\n13/01/2012 || || 500.00 || 500.00\n10/01/2012 || 1000.00 || || 1000.00")
    end
  end
end
