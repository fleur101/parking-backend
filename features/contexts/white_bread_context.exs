defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers
  alias Parking.Repo

  feature_starting_state(fn ->
    Application.ensure_all_started(:hound)
    %{}
  end)

  scenario_starting_state(fn _state ->
    Hound.start_session()
    Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    %{}
  end)

  scenario_finalize(fn _status, _state ->
    Ecto.Adapters.SQL.Sandbox.checkin(Repo)
    Hound.end_session()
  end)

  when_(~r/^I open registration page$/, fn state ->
    {:ok, state}
  end)

  given_(
    ~r/^user with username "(?<argument_one>[^"]+)" exists$/,
    fn state, %{argument_one: _argument_one} ->
      {:ok, state}
    end
  )

  and_(
    ~r/^I enter username "(?<argument_one>[^"]+)", name "(?<argument_two>[^"]+)" and password "(?<argument_three>[^"]+)"$/,
    fn state,
       %{
         argument_one: _argument_one,
         argument_two: _argument_two,
         argument_three: _argument_three
       } ->
      {:ok, state}
    end
  )

  and_(~r/^I submit the form$/, fn state ->
    {:ok, state}
  end)

  then_(~r/^I see a confirmation message$/, fn state ->
    {:ok, state}
  end)

  then_(~r/^I see a rejection message$/, fn state ->
    {:ok, state}
  end)
end
