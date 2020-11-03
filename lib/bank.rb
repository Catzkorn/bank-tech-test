class Bank
  def initialize
    @transactions = []
    @balance = 0
  end

  def deposit(amount, date = Time.now)
    deposit_errors(amount, date)

    @transactions << { date: date.strftime("%d/%m/%Y"),
                       type: :credit,
                       amount: amount }
  end

  def withdraw(amount, date = Time.now)
    withdraw_errors(amount, date)

    @balance -= amount
    @transactions << { date: date.strftime("%d/%m/%Y"),
                       type: :debit,
                       amount: amount }
  end

  def statement
    "#{statement_header}\n#{format_statement}"
  end

  private

  def deposit_errors(amount, date)
    raise "Inputted amount is not an integer" unless amount.is_a?(Integer)

    raise "Cannot make deposits in the future" if date > Time.now

    raise "You cannot deposit an amount of 0 or less" if amount <= 0
  end

  def withdraw_errors(amount, date)
    raise "Inputted amount is not an integer" unless amount.is_a?(Integer)

    raise "Cannot withdraw in the future" if date > Time.now

    raise "Cannot withdraw more than account balance" if amount > check_balance

    raise "You cannot withdraw an amount of 0 or less" if amount <= 0
  end

  def format_statement
    ledger = []
    current_balance = 0

    p sort_transactions(@transactions)

    sort_transactions(@transactions).each do |transaction|
      ledger_entry = []

      ledger_entry << transaction[:date]

      ledger_entry << credit(transaction)

      ledger_entry << debit(transaction)
      current_balance = balance(transaction, current_balance)
      ledger_entry << decimal_format(current_balance)

      ledger << ledger_entry.join(" || ").gsub("  ", " ")
    end

    return ledger.reverse.join("\n")
  end

  def statement_header
    header = ["date", "credit", "debit", "balance"]
    return header.join(" || ")
  end

  def credit(transaction)
    if transaction[:type] != :credit
      return
    else
      decimal_format(transaction[:amount])
    end
  end

  def debit(transaction)
    if transaction[:type] != :debit
      return
    else
      decimal_format(transaction[:amount])
    end
  end

  def balance(transaction, balance)
    if transaction[:type] == :credit
      balance += transaction[:amount]
    elsif transaction[:type] == :debit
      balance -= transaction[:amount]
    end

    return balance
  end

  def check_balance
    balance = 0
    @transactions.each { |transaction|
      if transaction[:type] == :credit
        balance += transaction[:amount]
      elsif transaction[:type] == :debit
        balance -= transaction[:amount]
      end
    }
    return balance
  end

  def decimal_format(number)
    return "#{"%.2f" % number}"
  end

  def sort_transactions(transactions)
    sorted_transactions = []

    sorted_transactions = transactions.sort_by { |transaction|
      Date.strptime(transaction[:date], "%d/%m/%Y")
    }

    return sorted_transactions
  end
end
