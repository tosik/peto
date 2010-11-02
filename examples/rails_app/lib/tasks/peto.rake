require "peto"

task :peto do
  sh "peto contracts/foo.yml -o contracts/generated/"
end
