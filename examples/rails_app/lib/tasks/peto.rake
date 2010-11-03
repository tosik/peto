require "peto/rake_task"

Peto::RakeTask.new do |t|
  t.output_dir = "contracts/generated/"
  t.contracts  << "contracts/foo.yml"
end

task :test => :peto

