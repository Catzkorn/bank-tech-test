class Formatter
  def format(transactions)
    return "#{statement_header}\n#{format_statement(transactions)}"
  end

  private

  def format_statement(transactions)
    ledger = []
    current_balance = 0

    sort_transactions(transactions).each do |transaction|
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
