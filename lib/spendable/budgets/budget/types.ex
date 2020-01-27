defmodule Spendable.Budgets.Budget.Types do
  use Absinthe.Schema.Notation

  alias Spendable.Budgets.Budget.Resolver
  alias Spendable.Budgets.Budget

  object :budget do
    field :id, :id
    field :name, :string
    field :balance, :string
    field :goal, :string
  end

  input_object :budget_allocation do
    field(:budget_id, non_null(:id))
    field(:amount, non_null(:string))
  end

  object :budget_queries do
    field :budgets, list_of(:budget) do
      middleware(Spendable.Middleware.CheckAuthentication)
      resolve(&Resolver.list/3)
    end
  end

  object :budget_mutations do
    field :create_budget, :budget do
      middleware(Spendable.Middleware.CheckAuthentication)
      arg(:name, :string)
      arg(:balance, :string)
      arg(:goal, :string)
      resolve(&Resolver.create/2)
    end

    field :update_budget, :budget do
      middleware(Spendable.Middleware.CheckAuthentication)
      middleware(Spendable.Middleware.LoadModel, module: Budget)
      arg(:id, non_null(:id))
      arg(:name, :string)
      arg(:balance, :string)
      arg(:goal, :string)
      resolve(&Resolver.update/2)
    end

    field :delete_budget, :budget do
      middleware(Spendable.Middleware.CheckAuthentication)
      middleware(Spendable.Middleware.LoadModel, module: Budget)
      arg(:id, non_null(:id))
      resolve(&Resolver.delete/2)
    end

    field :allocate, :integer do
      middleware(Spendable.Middleware.CheckAuthentication)
      arg(:allocations, list_of(:budget_allocation))
      resolve(&Resolver.allocate/2)
    end
  end
end
