require "formatter"

describe Formatter do
  mock_transactions = [{ :date => "10/01/2012", :type => :credit, :amount => 1000 }, { :date => "13/01/2012", :type => :credit, :amount => 2000 }, { :date => "14/01/2012", :type => :debit, :amount => 500 }]

  describe "#format_statement" do
    it "takes in an array of hashes, and returns a formatted statement" do
      formatter = Formatter.new
      expect(formatter.format(mock_transactions)).to eq("date || credit || debit || balance\n14/01/2012 || || 500.00 || 2500.00\n13/01/2012 || 2000.00 || || 3000.00\n10/01/2012 || 1000.00 || || 1000.00")
    end
  end
end
