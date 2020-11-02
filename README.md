# The bank account

Welcome to the Bank! A simple bank program which is run using IRB. 

Code is formatted to [rufo](https://github.com/ruby-formatter/rufo) standards, tested using the [rspec](https://github.com/rspec/rspec) framework. Testing coverage is handled by [simplecov](https://github.com/simplecov-ruby/simplecov).

## To run

The program has three user facing interactions, deposit, withdraw and statement. The program can be run using the following commands:

```ruby
2.7.0 :003 > require './lib/bank.rb'
=> true 
# Create an account
2.7.0 :004 > account = Bank.new
 => #<Bank:0x00007f975d1891a0 @transactions=[], @balance=0> 
# To deposit an amount
2.7.0 :005 > account.deposit(200)
# To withdraw an amount
2.7.0 :006 > account.withdraw(150) 
# To view account statement
2.7.0 :007 > account.statement
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
2.7.0 :006 > account.deposit(500, Time.new(2020, 01, 13))
 => [{:date=>"13/01/2020", :credit=>500, :balance=>500}] 

```

# Testing

To run tests:

Clone repository to your machine:

```ruby
# Run bundle to install required gems
charlotte@Charlottes-MBP bank-tech-test % bundle
Bundle complete! 3 Gemfile dependencies, 14 gems now installed.
```

```ruby
# Run rspec in the terminal
charlotte@Charlottes-MBP bank-tech-test % rspec
........

Finished in 0.00667 seconds (files took 0.23404 seconds to load)
8 examples, 0 failures


COVERAGE: 100.00% -- 74/74 lines in 2 files
```