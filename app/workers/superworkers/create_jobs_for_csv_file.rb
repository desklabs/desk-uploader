Superworker.define(:CreateJobsForCSVFile, :jobs) do
  WorkerStart()
  batch jobs: :job do
    ProcessInboundCustomerRow :job
  end
  WorkerEnd()

end
