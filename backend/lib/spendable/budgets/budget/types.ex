defmodule Spendable.Budgets.Budget.Types do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  alias Spendable.Budgets.Budget
  alias Spendable.Budgets.Budget.Resolver
  alias Spendable.Middleware.CheckAuthentication
  alias Spendable.Middleware.LoadModel

  object :budget do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:goal, :decimal)

    field :balance, non_null(:decimal) do
      complexity(5)

      resolve(fn budget, _args, _resolution ->
        batch({Budget, :balance_by_budget}, budget, fn batch_results ->
          {:ok, Map.get(batch_results, budget.id, "0.00")}
        end)
      end)
    end

    field(:recent_allocations, :allocation |> non_null |> list_of |> non_null,
      resolve: dataloader(Spendable, :allocations, args: %{recent: true})
    )

    field(:allocation_template_lines, :allocation_template_line |> non_null |> list_of |> non_null,
      resolve: dataloader(Spendable)
    )
  end

  object :budget_queries do
    field :budget, non_null(:budget) do
      middleware(CheckAuthentication)
      middleware(LoadModel, module: Budget)
      arg(:id, non_null(:id))
      resolve(&Resolver.get/2)
    end

    field :budgets, :budget |> non_null |> list_of |> non_null do
      middleware(CheckAuthentication)
      resolve(&Resolver.list/2)
    end
  end

  object :budget_mutations do
    field :create_budget, non_null(:budget) do
      middleware(CheckAuthentication)
      arg(:balance, :decimal)
      arg(:name, :string)
      arg(:goal, :decimal)
      resolve(&Resolver.create/2)
    end

    field :update_budget, non_null(:budget) do
      middleware(CheckAuthentication)
      middleware(LoadModel, module: Budget)
      arg(:id, non_null(:id))
      arg(:balance, :decimal)
      arg(:name, :string)
      arg(:goal, :decimal)
      resolve(&Resolver.update/2)
    end

    field :delete_budget, non_null(:budget) do
      middleware(CheckAuthentication)
      middleware(LoadModel, module: Budget)
      arg(:id, non_null(:id))
      resolve(&Resolver.delete/2)
    end
  end
end
