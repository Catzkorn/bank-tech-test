require "bank"

describe Bank do
  before(:each) do
    @account = Bank.new
  end

  describe "#deposit" do
    it "allows a customer to deposit money and view amount deposisted" do
      @account.deposit(1000, Time.new(2012, 1, 10))
      expect(@account.statement).to eq("date || credit || debit || balance\n10/01/2012 || 1000.00 || || 1000.00")
    end

    it "allows a customer to deposit money without a specific date and view amount deposisted" do
      date = Time.now
      @account.deposit(850)
      expect(@account.statement).to eq("date || credit || debit || balance\n#{date.strftime("%d/%m/%Y")} || 850.00 || || 850.00")
    end

    it "raises an error if a negative balance deposit is made" do
      expect { @account.deposit(-20, Time.new(2012, 1, 10)) }.to raise_error("You cannot deposit an amount of 0 or less")
    end

    it "raises an error if a string is input as an amount" do
      expect { @account.deposit("hello!", Time.new(2012, 1, 10)).to raise_error("Inputted amount is not an integer") }
    end

    it "raises an error if inputted date is in the future" do
      expect { @account.deposit(50, Time.new(2022, 1, 14)).to raise_error("Cannot make deposits in the future") }
    end
  end

  describe "#withdraw" do
    it "allows a customer to withdraw money and view amount deposisted" do
      @account.deposit(1000, Time.new(2012, 1, 10))
      @account.withdraw(500, Time.new(2012, 1, 13))
      expect(@account.statement).to eq("date || credit || debit || balance\n13/01/2012 || || 500.00 || 500.00\n10/01/2012 || 1000.00 || || 1000.00")
    end

    it "allows a customer to withdraw money without a specific date and view the statement" do
      date = Time.now
      @account.deposit(666, Time.new(2012, 1, 13))
      @account.withdraw(555)
      expect(@account.statement).to eq("date || credit || debit || balance\n#{date.strftime("%d/%m/%Y")} || || 555.00 || 111.00\n13/01/2012 || 666.00 || || 666.00")
    end

    it "raises an error if a withdraw is made that goes below the overall balance" do
      expect { @account.withdraw(50, Time.new(2012, 1, 13)) }.to raise_error("Cannot withdraw more than account balance")
    end

    it "raises an error if a negative balance withdraw is made" do
      expect { @account.withdraw(-20, Time.new(2012, 1, 13)) }.to raise_error("You cannot withdraw an amount of 0 or less")
    end

    it "raises an error if a string is input as an amount" do
      expect { @account.withdraw("Goodbye!", Time.new(2012, 1, 10)).to raise_error("Inputted amount is not an integer") }
    end

    it "raises an error if inputted date is in the future" do
      @account.deposit(1000, Time.new(2012, 1, 10))
      expect { @account.withdraw(50, Time.new(2022, 1, 14)).to raise_error("Cannot withdraw in the future") }
    end
  end

  describe "american date" do
    it "sets the date format to american" do
      @account.deposit(340, Time.new(2012, 1, 10))
      @account.deposit(260, Time.new(2013, 1, 11))
      @account.withdraw(500, Time.new(2014, 1, 12))
      @account.american_dates
      expect(@account.statement).to eq("date || credit || debit || balance\n01/12/2014 || || 500.00 || 100.00\n01/11/2013 || 260.00 || || 600.00\n01/10/2012 || 340.00 || || 340.00")
    end

    it "sets the date format to american" do
      @account.american_dates
      @account.deposit(340, Time.new(2012, 1, 10))
      expect(@account.statement).to eq ("date || credit || debit || balance\n01/10/2012 || 340.00 || || 340.00")
      @account.deposit(260, Time.new(2013, 1, 11))
      @account.withdraw(500, Time.new(2014, 1, 12))
      @account.american_dates
      expect(@account.statement).to eq("date || credit || debit || balance\n12/01/2014 || || 500.00 || 100.00\n11/01/2013 || 260.00 || || 600.00\n10/01/2012 || 340.00 || || 340.00")
    end
  end

  describe "Feature test" do
    it "is given two deposits and provides one withdraw, and prints statement" do
      @account.deposit(1000, Time.new(2012, 1, 10))
      @account.deposit(2000, Time.new(2012, 1, 13))
      @account.withdraw(500, Time.new(2012, 1, 14))
      expect(@account.statement).to eq("date || credit || debit || balance\n14/01/2012 || || 500.00 || 2500.00\n13/01/2012 || 2000.00 || || 3000.00\n10/01/2012 || 1000.00 || || 1000.00")
    end

    it "allows a user to add a transaction in the past, and it be shown chronologically" do
      @account.deposit(800, Time.new(2020, 6, 11))
      @account.deposit(1000, Time.new(2010, 1, 10))
      @account.withdraw(200, Time.new(2011, 6, 11))
      @account.deposit(2000, Time.new(2020, 1, 13))
      @account.withdraw(500, Time.new(2012, 1, 14))
      expect(@account.statement).to eq("date || credit || debit || balance\n11/06/2020 || 800.00 || || 3100.00\n13/01/2020 || 2000.00 || || 2300.00\n14/01/2012 || || 500.00 || 300.00\n11/06/2011 || || 200.00 || 800.00\n10/01/2010 || 1000.00 || || 1000.00")
    end
  end
end
