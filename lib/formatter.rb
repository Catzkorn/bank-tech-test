class Formatter
  def initialize
    @american_date = false
    @transaction_column = false
    @reverse_column_order = false
  end

  def format(transactions)
    return statement_header + "\n" + format_statement(transactions)
  end

  def toggle_date_format
    if @american_date
      @american_date = false
    else
      @american_date = true
    end
  end

  def toggle_transaction_format
    if @transaction_column
      @transaction_column = false
    else
      @transaction_column = true
    end
  end

  def toggle_columns_order
    if @reverse_column_order
      @reverse_column_order = false
    else
      @reverse_column_order = true
    end
  end

  private

  def format_statement(transactions)
    ledger = []
    current_balance = 0
    sorted_transactions = sort_transactions(transactions)

    sorted_transactions.each do |transaction|
      current_balance = balance(transaction, current_balance)
      cells = []

      if @transaction_column
        cells = transaction_column_format(transaction, current_balance)
      else
        cells = standard_format(transaction, current_balance)
      end

      cells = column_order_format(cells)

      ledger << join_by_separator(cells)
    end

    return ledger.reverse.join("\n")
  end

  def column_order_format(entry)
    if @reverse_column_order
      return entry.reverse
    end
    return entry
  end

  def format_date(date)
    case @american_date
    when true
      return date.strftime("%m/%d/%Y")
    when false
      return date.strftime("%d/%m/%Y")
    end
  end

  def statement_header
    header = []
    if @transaction_column
      header = ["date", "transactions", "balance"]
    else
      header = ["date", "credit", "debit", "balance"]
    end

    header = column_order_format(header)

    return join_by_separator(header)
  end

  def join_by_separator(data)
    return data.join(" || ").gsub("  ", " ")
  end

  def format_credit(transaction)
    if transaction.type != :credit
      return ""
    else
      return decimal_format(transaction.amount)
    end
  end

  def format_debit(transaction)
    if transaction.type != :debit
      return ""
    else
      return decimal_format(transaction.amount)
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
    cells = []
    cells << format_date(transaction.date)
    cells << format_credit(transaction)
    cells << format_debit(transaction)
    cells << decimal_format(current_balance)

    return cells
  end

  def transaction_column_format(transaction, current_balance)
    cells = []
    cells << format_date(transaction.date)
    cells << transaction_column(transaction)
    cells << decimal_format(current_balance)

    return cells
  end

  def transaction_column(transaction)
    if transaction.type == :credit
      return decimal_format(transaction.amount)
    elsif transaction.type == :debit
      return "(" + decimal_format(transaction.amount) + ")"
    end
  end
end
