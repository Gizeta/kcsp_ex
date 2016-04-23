defmodule KcspEx.DB do
  @type db_path       :: binary
  @type db_reference  :: binary
  @type db_key        :: binary
  @type db_val        :: binary | boolean | number
  @type write_options :: [{:sync, boolean}]

  @spec open(db_path) :: {:ok, db_reference} | {:error, any}
  def open(path) do
    path
    |> to_char_list
    |> :eleveldb.open([create_if_missing: true])
  end

  @spec close(db_reference) :: :ok | {:error, any}
  def close(db), do: :eleveldb.close(db)

  @spec get(db_reference, db_key) :: {:ok, binary} | :not_found | {:error, any}
  def get(db, key), do: :eleveldb.get(db, key, [])

  @spec put(db_reference, db_key, db_val, write_options) :: :ok | {:error, any}
  def put(db, key, val, opts \\ []), do: :eleveldb.put(db, key, to_string(val), opts)

  @spec delete(db_reference, db_key, write_options) :: :ok | {:error, any}
  def delete(db, key, opts \\ []), do: :eleveldb.delete(db, key, opts)

  @spec destroy(db_path) :: :ok | {:error, any}
  def destroy(path) do
    path
    |> to_char_list
    |> :eleveldb.destroy([])
  end
end
