require "bank"

describe Bank do
  before(:each) do
    @account = Bank.new
    @tenthjan = Time.new(2012, 1, 10)
    @thirteenthjan = Time.new(2012, 1, 13)
    @fourteenthjan = Time.new(2012, 1, 14)
  end

  describe "#deposit" do
    it "allows a customer to deposit money and view amount deposisted" do
      @account.deposit(1000, @tenthjan)
      expect(@account.statement).to eq("date || credit || debit || balance\n10/01/2012 || 1000.00 || || 1000.00")
    end

    it "allows a customer to deposit money without a specific date and view amount deposisted" do
      date = Time.now
      @account.deposit(850)
      expect(@account.statement).to eq("date || credit || debit || balance\n#{date.strftime("%d/%m/%Y")} || 850.00 || || 850.00")
    end

    it "raises an error if a negative balance deposit is made" do
      expect { @account.deposit(-20, @tenthjan) }.to raise_error("You cannot deposit an amount of 0 or less")
    end

    it "raises an error if a string is input as an amount" do
      expect { @account.deposit("hello!", @tenthjan).to raise_error("Inputted amount is not an integer") }
    end

    it "raises an error if inputted date is in the future" do
      expect { @account.deposit(50, Time.new(2022, 1, 14)).to raise_error("Cannot make deposits in the future") }
    end
  end

  describe "#withdraw" do
    it "allows a customer to withdraw money and view amount deposisted" do
      @account.deposit(1000, @tenthjan)
      @account.withdraw(500, @thirteenthjan)
      expect(@account.statement).to eq("date || credit || debit || balance\n13/01/2012 || || 500.00 || 500.00\n10/01/2012 || 1000.00 || || 1000.00")
    end

    it "allows a customer to withdraw money without a specific date and view the statement" do
      date = Time.now
      @account.deposit(666, @thirteenthjan)
      @account.withdraw(555)
      expect(@account.statement).to eq("date || credit || debit || balance\n#{date.strftime("%d/%m/%Y")} || || 555.00 || 111.00\n13/01/2012 || 666.00 || || 666.00")
    end

    it "raises an error if a withdraw is made that goes below the overall balance" do
      expect { @account.withdraw(50, @thirteenthjan) }.to raise_error("Cannot withdraw more than account balance")
    end

    it "raises an error if a negative balance withdraw is made" do
      expect { @account.withdraw(-20, @thirteenthjan) }.to raise_error("You cannot withdraw an amount of 0 or less")
    end

    it "raises an error if a string is input as an amount" do
      expect { @account.withdraw("Goodbye!", @tenthjan).to raise_error("Inputted amount is not an integer") }
    end

    it "raises an error if inputted date is in the future" do
      @account.deposit(1000, @tenthjan)
      expect { @account.withdraw(50, Time.new(2022, 1, 14)).to raise_error("Cannot withdraw in the future") }
    end
  end

  describe "Feature test" do
    it "is given two deposits and provides one withdraw, and prints statement" do
      @account.deposit(1000, @tenthjan)
      @account.deposit(2000, @thirteenthjan)
      @account.withdraw(500, @fourteenthjan)
      expect(@account.statement).to eq("date || credit || debit || balance\n14/01/2012 || || 500.00 || 2500.00\n13/01/2012 || 2000.00 || || 3000.00\n10/01/2012 || 1000.00 || || 1000.00")
    end
  end
end
