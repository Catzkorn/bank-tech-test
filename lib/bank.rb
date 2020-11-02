class Bank
  def initialize
    @transactions = []
    @balance = 0
    @ledger = []
  end

  def deposit(amount, time = Time.now)
    @transactions << { date: time.strftime("%d/%m/%Y"), credit: amount }
    @balance += amount
  end

  def statement
    @transactions.each { |transaction|
      row = ""

      row += transaction[:date]

      if transaction[:credit].nil?
        row += " ||"
      else
        row += " || #{"%.2f" % transaction[:credit]}"
      end

      if transaction[:debit].nil?
        row += " || || "
      else
        row += " || #{"%.2f" % transaction[:debit]} || "
      end
      row += "#{"%.2f" % @balance}"

      @ledger << row
    }

    return "#{statement_header()}\n#{@ledger.join("\n")}"
  end

  private

  def statement_header
    return "date || credit || debit || balance"
  end
end
