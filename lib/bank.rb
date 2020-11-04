require "formatter"

class Bank
  def initialize(formatter = Formatter.new)
    @transactions = []
    @balance = 0
    @formatter = formatter
  end

  def deposit(amount, date = Time.now)
    deposit_errors(amount, date)

    @transactions << { date: date,
                       type: :credit,
                       amount: amount }
  end

  def withdraw(amount, date = Time.now)
    withdraw_errors(amount, date)

    @balance -= amount
    @transactions << { date: date,
                       type: :debit,
                       amount: amount }
  end

  def statement
    @formatter.format(@transactions)
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
end
