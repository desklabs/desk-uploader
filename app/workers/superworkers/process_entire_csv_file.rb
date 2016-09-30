Superworker.define(:CreateJobsForCSVFile, :jobs, :username) do
  WorkerStart()
  batch jobs: :job do
    ProcessInboundCustomerRow :job
  end
  WorkerEnd()

end
