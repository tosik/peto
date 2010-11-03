require "peto"

task :peto do
  peto = Peto::Master.new
  peto.load("contracts/foo.yml")
  peto.generate("contracts/generated/")
end

task :test => :peto

