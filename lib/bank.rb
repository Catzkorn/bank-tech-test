class Bank
  def initialize
    @transactions = []
    @balance = 0
  end

  def deposit(amount, time = Time.now)
    @transactions << { date: time.strftime("%d/%m/%Y"), credit: amount }
    @balance += amount
  end

  def statement
    return "#{statement_header()}\n#{statement_transactions()}"
  end

  private

  def statement_transactions
    ledger = []
    @transactions.each { |transaction|
      ledger_entry = ""

      ledger_entry += transaction[:date]

      ledger_entry += credit(transaction)

      ledger_entry += debit(transaction)

      ledger_entry += "#{"%.2f" % @balance}"

      ledger << ledger_entry
    }
    return ledger.join("\n")
  end

  def statement_header
    return "date || credit || debit || balance"
  end

  def credit(transaction)
    if transaction[:credit].nil?
      return " ||"
    else
      return " || #{"%.2f" % transaction[:credit]}"
    end
  end

  def debit(transaction)
    if transaction[:debit].nil?
      return " || || "
    else
      return " || #{"%.2f" % transaction[:debit]} || "
    end
  end
end
