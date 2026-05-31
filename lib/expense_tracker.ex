defmodule ExpenseTracker do
  @moduledoc """
  Expense Tracker that can add new expenses, list all transactions, search by categories and descriptions.
  It can also give a summary of your spending as well as the highest transaction you have had. You can also search for transactions in a date range.
  """

  @doc """
  Add an expense to your tracker with description, amount, category and date
  """
  def add(description, amount, category, date, path \\ "expense.json") do
  # Load the map
  with {:ok, expenses} <- ExpenseTracker.Storage.load(path) do
    new_expense = %{description: description, amount: amount, category: category, date: date}
    updated_expense = expenses ++ [new_expense]
    ExpenseTracker.Storage.save(updated_expense, path)
    {:ok, "#{description} for $#{amount} has been added to your tracker."}
  else
    {:error, reason} -> {:error, reason}
  end
  end

  @doc """
  Return all of the expenses in maps from expense.json(database)
  """
  def list(path \\ "expense.json") do
    ExpenseTracker.Storage.load(path)
  end

  @doc """
  Search the json file by description and return all matching options
  """
  def find_by_description(description, path \\ "expense.json") do
    case ExpenseTracker.Storage.load(path) do
      {:ok, expenses} ->
        case Enum.filter(expenses, fn expense -> String.downcase(expense["description"]) == String.downcase(description) end) do
          [] -> {:error, "#{description} not found in tracker."}
          expense -> {:ok, expense}
        end
    {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Adds all amounts into one integer to show how much spend has happened in your tracker
  """
  def total(path \\ "expense.json") do
    case ExpenseTracker.Storage.load(path) do
      {:ok, expenses} ->
        {:ok, Enum.reduce(expenses, 0, fn expense, acc -> acc + expense["amount"] end)}
        {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Search the json by category and return all matching options
  """
  def by_category(category, path \\ "expense.json") do
  case ExpenseTracker.Storage.load(path) do
    {:ok, expenses} ->
      case Enum.filter(expenses, fn expense -> String.downcase(expense["category"]) == String.downcase(category) end) do
        [] -> {:error, "#{category} not found."}
        expense -> {:ok, expense}
      end
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Returns totals spent per category
  """
  def summary(path \\ "expense.json") do
    case ExpenseTracker.Storage.load(path) do
      {:ok, expenses} ->
        {:ok, Enum.reduce(expenses, %{}, fn expense, acc ->
          current = Map.get(acc, expense["category"], 0)
          Map.put(acc, expense["category"], current + expense["amount"]) end)}
          {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Search json for maps between specific start_date and end_date
  """
  def date_range(start_date, end_date, path \\ "expense.json") do
    case ExpenseTracker.Storage.load(path) do
      {:ok, expenses} ->
        filtered = Enum.filter(expenses, fn expense -> expense["date"] >= start_date and expense["date"] <= end_date end)
        {:ok, filtered}
        {:error, reason} -> {:error, reason}
    end
  end

@doc """
  Returns your largest amount as a map
  """
  def highest_expense(path \\ "expense.json") do
    case ExpenseTracker.Storage.load(path) do
      {:ok, expenses} ->
        case expenses do
          [] -> {:error, "No expenses found"}
          _ -> {:ok, Enum.max_by(expenses, fn expense -> expense["amount"] end)}
        end
    end
  end

end
