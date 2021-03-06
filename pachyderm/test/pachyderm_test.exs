defmodule FixedGenerator do
  def generate({FixedGenerator, id}) do
    id
  end
end

defmodule PachydermTest do
  use ExUnit.Case
  doctest Pachyderm

  alias VendingMachine.Command.{AddCoin, PushButton}

  test "integration test of application" do
    assert {:error, :no_records} = VendingMachine.add_coin("no machine")
    {:ok, machine} = VendingMachine.create()
    assert {:ok, %VendingMachine.State.OneCoin{}} = VendingMachine.add_coin(machine) |> IO.inspect
    assert {:ok, %VendingMachine.State.TwoCoins{}} = VendingMachine.add_coin(machine)
    assert {:error, {:unknown_command, _command}} = VendingMachine.add_coin(machine)
    {:ok, logs} = Pachyderm.Ledger.view_log()
    IO.inspect(logs)
    assert {:error, {:unknown_entity, "no machine"}} = VendingMachine.add_coin("no machine")
    # VendingMachine.add_coin(machine)
    # {:ok, transaction} = Pachyderm.Ledger.InMemory.record(ledger, adjustments ++ adjustments2, {:creation, :id})
    # # Have each entity as a pid so lookup logic can be handled slowely
    # {:ok, supervisor} = Pachyderm.Entity.Supervisor.start_link()
    # {:ok, entity} = Pachyderm.Entity.Supervisor.start_child(supervisor, ["some-id", ledger])
    # {:error, {:already_started, ^entity}} = Pachyderm.Entity.Supervisor.start_child(supervisor, ["some-id", ledger])
    # {:ok, other_entity} = Pachyderm.Entity.Supervisor.start_child(supervisor, ["some-other-id", ledger])
    # # {:error, "no memory of bad uuid"} = Pachyderm.Registry.find(:bad_uuid)
    # Pachyderm.Entity.instruct("some-other-id", %AddCoin{})
    # Process.exit(other_entity, :kill)
    # :timer.sleep(1000)
    # # Pachyderm.Entity.instruct("some-other-id", %AddCoin{})
    # # |> IO.inspect
    # # {:ok, entity} = Pachyderm.Registry.find(:uuid)
    # {:ok, state} = Pachyderm.Entity.instruct(entity, %AddCoin{})
    # IO.inspect(state)
  end

  @tag :skip
  test "the truth" do
    {:ok, ledger} = Pachyderm.Ledger.InMemory.start_link()
    {:ok, id} = VendingMachine.create(%{
      random: {FixedGenerator, 1234},
      ledger: {Pachyderm.Ledger.InMemory, ledger}
    })
    {:ok, entity} = Pachyderm.Entity.start_link(id, ledger)
    {:ok, state} = Pachyderm.Entity.instruct(entity, %AddCoin{})
    IO.inspect(state)
    {:ok, state} = Pachyderm.Entity.instruct(entity, %AddCoin{})
    IO.inspect(state)
    {:ok, state} = Pachyderm.Entity.instruct(entity, %PushButton{})

    # Read the ledger
    Pachyderm.Ledger.InMemory.inspect(ledger, self)
    receive do
      {:"$LedgerEntry", %{adjustments: adjustments}} ->
        Enum.each(adjustments, fn
          (%{entity: e, attribute: a, value: v, set: s}) ->
            IO.puts("#{e}, #{a}, #{v}, #{s}")
        end)
    end
    receive do
      {:"$LedgerEntry", %{adjustments: adjustments}} ->
        Enum.each(adjustments, fn
          (%{entity: e, attribute: a, value: v, set: s}) ->
            IO.puts("#{e}, #{a}, #{v}, #{s}")
        end)
    end
    receive do
      {:"$LedgerEntry", %{adjustments: adjustments}} ->
        Enum.each(adjustments, fn
          (%{entity: e, attribute: a, value: v, set: s}) ->
            IO.puts("#{e}, #{a}, #{v}, #{s}")
        end)
    end
  end
end
