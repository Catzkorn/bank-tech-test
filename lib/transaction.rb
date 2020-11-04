class Transaction
  def initialize(amount, type, date = Date.new)
    @date = date
    @amount = amount
    @type = type
  end

  def date
    return @date
  end
end
