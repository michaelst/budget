defmodule NotificationProvider do
  use Spendable.Utils.Enum,
    type: :notification_provider,
    values: [
      %{name: :apns}
    ]
end
