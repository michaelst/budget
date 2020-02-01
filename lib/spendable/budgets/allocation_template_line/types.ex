defmodule Spendable.Budgets.AllocationTemplateLine.Types do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :allocation_template_line do
    field :id, :id
    field :amount, :string
    field :budget, :budget, resolve: dataloader(Spendable)
    field :priority, :integer
  end

  input_object :allocation_template_line_input_object do
    field :id, :id
    field :amount, :string
    field :budget_id, :id
    field :priority, :integer
  end
end