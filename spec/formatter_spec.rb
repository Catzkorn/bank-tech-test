require "formatter"

describe Formatter do
  let(:transaction_double) { double :transaction, amount: 1000, type: :credit, date: Date.new(2012, 01, 10) }
  let(:transaction_doubletwo) { double :transaction, amount: 2000, type: :credit, date: Date.new(2012, 01, 13) }
  let(:transaction_doublethree) { double :transaction, amount: 500, type: :debit, date: Date.new(2012, 01, 14) }

  before(:each) do
    @formatter = Formatter.new
  end

  describe "#format_statement" do
    it "takes in an array of hashes, and returns a formatted statement" do
      mock_transactions = [transaction_double, transaction_doubletwo, transaction_doublethree]
      expect(@formatter.format(mock_transactions)).to eq("date || credit || debit || balance\n14/01/2012 || || 500.00 || 2500.00\n13/01/2012 || 2000.00 || || 3000.00\n10/01/2012 || 1000.00 || || 1000.00")
    end
  end

  describe "#.toggle_date_format" do
    it "formats the dates into american mm/dd/yyyy if the option is selected by the user" do
      mock_transactions = [transaction_double, transaction_doubletwo, transaction_doublethree]
      @formatter.toggle_date_format
      expect(@formatter.format(mock_transactions)).to eq("date || credit || debit || balance\n01/14/2012 || || 500.00 || 2500.00\n01/13/2012 || 2000.00 || || 3000.00\n01/10/2012 || 1000.00 || || 1000.00")
    end
  end

  describe "#.toggle_transaction_format" do
    it "formats the statement to have a single transaction column, with withdraws formatted in ()" do
      mock_transactions = [transaction_double, transaction_doubletwo, transaction_doublethree]
      @formatter.toggle_transaction_format
      expect(@formatter.format(mock_transactions)).to eq("date || transactions || balance\n14/01/2012 || (500.00) || 2500.00\n13/01/2012 || 2000.00 || 3000.00\n10/01/2012 || 1000.00 || 1000.00")
    end
  end

  describe "#.toggle_columns_order" do
    it "reverses the order of the columns in debit/credit format" do
      mock_transactions = [transaction_double, transaction_doubletwo, transaction_doublethree]
      @formatter.toggle_columns_order
      expect(@formatter.format(mock_transactions)).to eq("balance || debit || credit || date\n2500.00 || 500.00 || || 14/01/2012\n3000.00 || || 2000.00 || 13/01/2012\n1000.00 || || 1000.00 || 10/01/2012")
    end

    it "reverses the order of the columns of single transaction column format" do
      mock_transactions = [transaction_double, transaction_doubletwo, transaction_doublethree]
      @formatter.toggle_columns_order
      @formatter.toggle_transaction_format
      expect(@formatter.format(mock_transactions)).to eq("balance || transactions || date\n2500.00 || (500.00) || 14/01/2012\n3000.00 || 2000.00 || 13/01/2012\n1000.00 || 1000.00 || 10/01/2012")
    end
  end
end
