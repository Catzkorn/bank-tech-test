require "formatter"

describe Formatter do
  mock_transactions = [{ :date => Date.new(2012, 01, 10), :type => :credit, :amount => 1000 }, { :date => Date.new(2012, 01, 13), :type => :credit, :amount => 2000 }, { :date => Date.new(2012, 01, 14), :type => :debit, :amount => 500 }]

  before(:each) do
    @formatter = Formatter.new
  end

  describe "#format_statement" do
    it "takes in an array of hashes, and returns a formatted statement" do
      expect(@formatter.format(mock_transactions)).to eq("date || credit || debit || balance\n14/01/2012 || || 500.00 || 2500.00\n13/01/2012 || 2000.00 || || 3000.00\n10/01/2012 || 1000.00 || || 1000.00")
    end
  end

  describe "American Date Format" do
    it "Formats the dates into american mm/dd/yyyy if the option is selected by the user" do
      @formatter.american_date_format
      expect(@formatter.format(mock_transactions)).to eq("date || credit || debit || balance\n01/14/2012 || || 500.00 || 2500.00\n01/13/2012 || 2000.00 || || 3000.00\n01/10/2012 || 1000.00 || || 1000.00")
    end
  end

  describe "Single Transaction Collumn Format" do
    it "rormats the statement to have a single transaction collumn, with withdraws formatted in ()" do
      @formatter.transaction_collumn_format
      expect(@formatter.format(mock_transactions)).to eq("date || transactions || balance\n14/01/2012 || (500.00) || 2500.00\n13/01/2012 || 2000.00 || 3000.00\n10/01/2012 || 1000.00 || 1000.00")
    end
  end

  # describe "Reverse Collumns" do
  #   it "reverses the order of the collumns in debit/credit format" do
  #     @formatter.reverse_statement_format
  #     expect(@formatter.format(mock_transactions)).to eq("balance || debit || credit || date\n2500.00 || 500.00 || || 01/14/2012\n3000.00 || || 2000.00 || 01/13/2012\n1000.00 || || 1000.00 || 01/10/2012")
  #   end

  #   it "reverses the order of the collumns of single transaction collumn format" do
  #     @formatter.reverse_statement_format
  #     @formatter.american_date_format
  #     expect(@formatter.format(mock_transactions)).to eq("balance || transactions || date\n2500.00 || (500.00) || 14/01/2012\n3000.00 || 2000.00 || 13/01/2012\n1000.00 || 1000.00 || 10/01/2012")
  #   end
  # end
end
