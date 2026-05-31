# ExpenseTracker
A CLI tool built with ELixir for managing personal expenses

## Features
- Add expenses with description, amount, category and date
- List all your expenses in your tracker
- Find by description
- Find total of expenses
- Find by category of expense
- Summary gives you an overview of expenses per category
- Find between date ranges finds maps with dates listed between start_date and end_date
- Highest expense finds your map with the larges amount spent

## Tech Stack
- Elixir
- JSON (JSON parsing)
- ExUnit (testing)

## Running the Project
mix deps.get
iex.bat -S mix

## Examples Usage
- ExpenseTracker.add("DESCRIPTION", AMOUNT, "CATEGORY", "YYYY-MM-DD")
- ExpenseTracker.list()
- ExpenseTracker.find_by_description("DESCRIPTION")
- ExpenseTracker.total()
- ExpenseTracker.by_category("CATEGORY")
- ExpenseTracker.summary()
- ExpenseTracker.date_range("START_DATE", "END_DATE")
- ExpenseTracker.highest_expense()
