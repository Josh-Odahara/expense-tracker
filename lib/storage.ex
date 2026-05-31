defmodule ExpenseTracker.Storage do
  @moduledoc """
  Save and load logic for expense tracker
  """

  def load(path \\ "expense.json") do
    with  {:ok, contents} <- File.read(path),
          {:ok, expenses} <- Jason.decode(contents) do
            {:ok, expenses}
    else
      {:error, :enoent} -> {:ok, []}
      {:error, reason} -> {:error, "#{reason} not found."}
          end
  end

  def save(expenses, path \\ "expense.json") do
    with {:ok, json} <- Jason.encode(expenses, pretty: true),
    :ok <- File.write(path, json) do
      {:ok, "Expenses updated and saved."}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
