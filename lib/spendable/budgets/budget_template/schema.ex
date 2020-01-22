defmodule Spendable.Budgets.BudgetTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "budget_templates" do
    field :name, :string

    belongs_to :user, Spendable.User

    has_many :lines, Spendable.Budgets.BudgetTemplateLine, on_replace: :delete

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, __schema__(:fields) -- [:id])
    |> cast_assoc(:lines)
    |> validate_required([:user_id, :name])
  end
end
