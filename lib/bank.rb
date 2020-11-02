class Bank
  def initialize
    @transactions = []
    @balance = 0
  end

  def deposit(amount, time = Time.now)
    deposit_errors(amount)

    @balance += amount
    @transactions << { date: time.strftime("%d/%m/%Y"),
                       credit: amount,
                       balance: @balance }
  end

  def withdraw(amount, time = Time.now)
    withdraw_errors(amount)

    @balance -= amount
    @transactions << { date: time.strftime("%d/%m/%Y"),
                       debit: amount,
                       balance: @balance }
  end

  def statement
    "#{statement_header}\n#{format_statement}"
  end

  private

  def deposit_errors(amount)
    raise "Inputted amount is not an integer" unless amount.is_a?(Integer)
    raise "You cannot deposit an amount of 0 or less" if amount <= 0
  end

  def withdraw_errors(amount)
    raise "Inputted amount is not an integer" unless amount.is_a?(Integer)

    raise "Cannot withdraw more than account balance" if amount > @balance

    raise "You cannot withdraw an amount of 0 or less" if amount <= 0
  end

  def format_statement
    ledger = []
    @transactions.each do |transaction|
      ledger_entry = ""

      ledger_entry += transaction[:date]

      ledger_entry += credit(transaction)

      ledger_entry += debit(transaction)

      ledger_entry += ("%.2f" % transaction[:balance])

      ledger << ledger_entry
    end
    ledger.reverse.join("\n")
  end

  def statement_header
    "date || credit || debit || balance"
  end

  def credit(transaction)
    if transaction[:credit].nil?
      " ||"
    else
      " || #{"%.2f" % transaction[:credit]}"
    end
  end

  def debit(transaction)
    if transaction[:debit].nil?
      " || || "
    else
      " || #{"%.2f" % transaction[:debit]} || "
    end
  end
end
