class Formatter
  def initialize
    @american_format = false
    @collumn_format = false
    @reverse_statement = false
  end

  def format(transactions)
    return "#{statement_header}\n#{format_statement(transactions)}"
  end

  def american_date_format
    @american_format = true
  end

  def transaction_collumn_format
    @collumn_format = true
  end

  def reverse_statement_format
    @reverse_statement = true
  end

  private

  def format_statement(transactions)
    ledger = []
    current_balance = 0

    sort_transactions(transactions).each do |transaction|
      current_balance = balance(transaction, current_balance)

      if @collumn_format
        ledger_entry = collumn_format(transaction, current_balance)
      else
        ledger_entry = standard_format(transaction, current_balance)
      end

      if @reverse_statement
        ledger_entry = order_format(ledger_entry)
      end

      ledger << separator(ledger_entry)
    end

    return ledger.reverse.join("\n")
  end

  def order_format(entry)
    if @reverse_statement
      return entry.reverse
    end
    return entry
  end

  def date_format(date)
    case @american_format
    when true
      return date.strftime("%m/%d/%Y")
    when false
      return date.strftime("%d/%m/%Y")
    end
  end

  def statement_header
    if @collumn_format
      header = ["date", "transactions", "balance"]
    else
      header = ["date", "credit", "debit", "balance"]
    end

    header = order_format(header)

    return separator(header)
  end

  def separator(data)
    return data.join(" || ").gsub("  ", " ")
  end

  def credit(transaction)
    if transaction.type != :credit
      return
    else
      decimal_format(transaction.amount)
    end
  end

  def debit(transaction)
    if transaction.type != :debit
      return
    else
      decimal_format(transaction.amount)
    end
  end

  def transaction_collumn(transaction)
    if transaction.type == :credit
      return decimal_format(transaction.amount)
    elsif transaction.type == :debit
      return "(" + decimal_format(transaction.amount) + ")"
    end
  end

  def balance(transaction, balance)
    if transaction.type == :credit
      balance += transaction.amount
    elsif transaction.type == :debit
      balance -= transaction.amount
    end

    return balance
  end

  def decimal_format(number)
    return "#{"%.2f" % number}"
  end

  def sort_transactions(transactions)
    sorted_transactions = []

    sorted_transactions = transactions.sort_by { |transaction|
      transaction.date
    }

    return sorted_transactions
  end

  def standard_format(transaction, current_balance)
    ledger_entry = []
    ledger_entry << date_format(transaction.date)
    ledger_entry << credit(transaction)
    ledger_entry << debit(transaction)
    ledger_entry << decimal_format(current_balance)

    return ledger_entry
  end

  def collumn_format(transaction, current_balance)
    ledger_entry = []
    ledger_entry << date_format(transaction.date)
    ledger_entry << transaction_collumn(transaction)
    ledger_entry << decimal_format(current_balance)

    return ledger_entry
  end
end
