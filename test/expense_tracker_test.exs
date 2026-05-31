defmodule ExpenseTrackerTest do
  use ExUnit.Case
  doctest ExpenseTracker

  @test_path "test_expense.json"

setup do
    File.write(@test_path, "[]")
    on_exit(fn -> File.rm(@test_path) end)
    :ok
  end

  test "add/4 adds a new expense to your tracker with description, amount, category and date" do
    result = ExpenseTracker.add("Coffee", 5.00, "Food and Drink", "2026-05-28", @test_path)
    assert result == {:ok, "Coffee for $5.0 has been added to your tracker."}
    {:ok, expenses} = ExpenseTracker.list(@test_path)
    assert length(expenses) == 1
  end

  test "list/0 gets all of the maps in your json file and returns them" do
  result = ExpenseTracker.add("Coffee", 5.00, "Food and Drink", "2026-05-28", @test_path)
    assert result == {:ok, "Coffee for $5.0 has been added to your tracker."}
    {:ok, expenses} = ExpenseTracker.list(@test_path)
    assert length(expenses) == 1
  end

  test "find_by_decription/1 finds a full map by a description" do
  ExpenseTracker.add("Rent", 1500, "Bill", "2026-06-01", @test_path)
  found = ExpenseTracker.find_by_description("Rent", @test_path)
  assert found ==  {:ok, [%{"description" => "Rent", "amount" => 1500, "category" => "Bill", "date" => "2026-06-01"}]}
  end

  test "find_by_decription/1 finds transactions with the same description" do
  ExpenseTracker.add("Coffee", 5, "Food and Drink", "2026-05-28", @test_path)
  ExpenseTracker.add("Coffee", 4.5, "Food and Drink", "2026-05-01", @test_path)
  found = ExpenseTracker.find_by_description("Coffee", @test_path)
  assert found == {:ok, [
    %{"description" => "Coffee", "amount" => 5, "category" => "Food and Drink", "date" => "2026-05-28"},
    %{"description" => "Coffee", "amount" => 4.5, "category" => "Food and Drink", "date" => "2026-05-01"},
    ]}
  end

  test "find_by_description/1 returns an error message when description not found" do
  assert ExpenseTracker.find_by_description("description", @test_path) == {:error, "description not found in tracker."}
  end

  test "total returns the total of all transactions put together" do
  ExpenseTracker.add("Rent", 1500, "Bill", "2026-06-01", @test_path)
  ExpenseTracker.add("Barnes & Nobles", 100, "Extra Spend", "2026-06-02", @test_path)
  assert ExpenseTracker.total(@test_path) == {:ok, 1600}
  end

  test "total returns an empty collection when there is no total" do
  assert ExpenseTracker.total(@test_path) == {:ok, 0}
  end

  test "by_category/1 finds and lists all transactions within that category" do
  ExpenseTracker.add("Rent", 1500, "Bill", "2026-06-01", @test_path)
  found = ExpenseTracker.by_category("Bill", @test_path)
  assert found ==  {:ok, [%{"description" => "Rent", "amount" => 1500, "category" => "Bill", "date" => "2026-06-01"}]}
  end

  test "by_category/1 returns an error message when category not found" do
  assert ExpenseTracker.by_category("category", @test_path) == {:error, "category not found."}
  end

  test "summary gets the categories and gives you an amount per category" do
  ExpenseTracker.add("Rent", 1500, "Bill", "2026-06-01", @test_path)
  ExpenseTracker.add("Barnes & Nobles", 100, "Extra Spend", "2026-06-02", @test_path)
  assert ExpenseTracker.summary(@test_path) == {:ok, %{"Bill" => 1500, "Extra Spend" => 100}}
  end

  test "date_range/2 gets a start date and an end date and returns the map for every transaction" do
  ExpenseTracker.add("Rent", 1500, "Bill", "2026-06-01", @test_path)
  ExpenseTracker.add("Barnes & Nobles", 100, "Extra Spend", "2026-06-02", @test_path)
  result = ExpenseTracker.date_range("2026-06-01", "2026-06-02", @test_path)
  assert result == {:ok,[
    %{"description" => "Rent", "amount" => 1500, "category" => "Bill", "date" => "2026-06-01"},
    %{"description" => "Barnes & Nobles", "amount" => 100, "category" => "Extra Spend", "date" => "2026-06-02"}
    ]}
  end

  test "date_range/2 error" do
  assert ExpenseTracker.date_range("start_date", "end_date", @test_path) == {:ok, []}
  end

  test "highest_expense returns a map with the highest amount" do
  ExpenseTracker.add("Rent", 1500, "Bill", "2026-06-01", @test_path)
  found = ExpenseTracker.highest_expense(@test_path)
  assert found == {:ok, %{"description" => "Rent", "amount" => 1500, "category" => "Bill", "date" => "2026-06-01"}}
  end

  test "highest_expense returns an error message when there are no expenses" do
  assert ExpenseTracker.highest_expense(@test_path) == {:error, "No expenses found"}
  end

end
