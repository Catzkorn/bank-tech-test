require "bank"

describe Bank do
  before(:each) do
    @account = Bank.new
    @time = Time.new(2012, 1, 10)
  end

  describe "#deposit" do
    it "allows a customer to deposit money and view amount deposisted" do
      @account.deposit(1000, @time)
      expect(@account.statement).to eq("date || credit || debit || balance\n10/01/2012 || 1000.00 || || 1000.00")
    end
  end
end
