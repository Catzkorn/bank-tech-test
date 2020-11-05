# The bank account

Welcome to the Bank! A simple bank program which is run using IRB. 

Code is formatted to [rufo](https://github.com/ruby-formatter/rufo) standards, tested using the [rspec](https://github.com/rspec/rspec) framework. Testing coverage is handled by [simplecov](https://github.com/simplecov-ruby/simplecov).

## Requirements

To use this program, you will need:
- [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
- [Bundler](https://bundler.io/)


Clone repository to your machine:

```ruby
# Run bundle to install required gems
charlotte@Charlottes-MBP bank-tech-test % bundle
Bundle complete! 3 Gemfile dependencies, 14 gems now installed.
```



# To run

The program has three user facing interactions within the Bank class, deposit, withdraw and statements; and 3 statement option commands, americans_dates, transaction_column and reversed_columns. The options can be toggled on an off, and any combination of options can be used. 

The program can be run using the following commands:

```ruby
# Run IRB in the terminal
  charlotte@Charlottes-MBP bank-tech-test % irb
# Require the bank file
  2.7.0 :003 > require './lib/bank.rb'
    => true 
# Create an account
  2.7.0 :004 > account = Bank.new
  => #<Bank:0x00007f975d1891a0 @transactions=[], @balance=0> 
# To deposit an amount
  2.7.0 :005 > account.deposit(20)
     => [#<Transaction:0x00007f9d93110cc8 @date=2020-11-05 09:18:37.16123 +0000, @amount=20, @type=:credit>] 
# To withdraw an amount
  2.7.0 :006 > account.withdraw(10) 
    => [#<Transaction:0x00007f9d93110cc8 @date=2020-11-05 09:18:37.16123 +0000, @amount=10, @type=:debit>] 
# To view account statement
  2.7.0 :007 > account.statement
   => "date || credit || debit || balance\n05/11/2020 || || 10.00 || 10.00\n05/11/2020 || 20.00 || || 20.00"
# To change date format to and from american - mm/dd/yyy
  2.7.0 :006 > account.american_dates
    => true ||  => false 
    => "date || credit || debit || balance\n11/05/2020 || || 10.00 || 10.00\n11/05/2020 || 20.00 || || 20.00" 
# To change statement format to and from having a single transaction column - date || transactions || balance
  2.7.0 :010 > account.transaction_column
    => true ||  => false
    => "date || transactions || balance\n11/05/2020 || (10.00) || 10.00\n11/05/2020 || 20.00 || 20.00" 
# To change the order of the columns - balance || transactions || date
  2.7.0 :014 > account.reversed_columns
    => true || => false
    => "balance || transactions || date\n10.00 || (10.00) || 11/05/2020\n20.00 || 20.00 || 11/05/2020" 
```

### Error handling:

The program handles errors including depositing or withdrawing 0 or less amounts, attempting to withdraw more than the account balance, and inputting an amount that is not an integer.


```ruby
# Deposit Errors
2.7.0 :009 > account.deposit(0)
RuntimeError (You cannot deposit an amount of 0 or less)
#
2.7.0 :003 > account.deposit("money")
RuntimeError (Inputted amount is not an integer)

# Withdraw Errors
2.7.0 :004 > account.withdraw(0)
RuntimeError (You cannot withdraw an amount of 0 or less)
#
2.7.0 :008 > account.withdraw(400)
RuntimeError (Cannot withdraw more than account balance)
#
2.7.0 :005 > account.withdraw("money")
RuntimeError (Inputted amount is not an integer)


```

### Date input: 

Date is an optional parameter to the withdraw and deposit methods. If no parameter is given, the current date will be provided. To specify a date use the `Time.new` with the parameters of year, month, day:

```ruby
2.7.0 :018 > account.deposit(500, Time.new(2020, 01, 13))
 => [#<Transaction:0x00007f9d93223b60 @date=2020-01-13 00:00:00 +0000, @amount=500, @type=:credit>] 
# Error will be thrown if a date in the future is added
# Deposit
2.7.0 :005 > account.deposit(50, Time.new(2022, 1, 14))
RuntimeError (Cannot make deposits in the future)
# Withdraw
2.7.0 :007 > account.withdraw(30, Time.new(2202))
RuntimeError (Cannot withdraw in the future)
```

# Testing

To run tests:


```ruby
# Run rspec in the terminal
charlotte@Charlottes-MBP bank-tech-test % rspec
..........

Finished in 0.02146 seconds (files took 0.16827 seconds to load)
31 examples, 0 failures


COVERAGE: 100.00% -- 309/309 lines in 6 files
```