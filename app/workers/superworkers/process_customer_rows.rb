Superworker.define(:ProcessCustomerRows, :row_ids, :file_id) do
  WorkerStart()
  batch row_ids: :row_id do
    ProcessCustomerRow :row_id
  end
  WorkerEnd :file_id

end
