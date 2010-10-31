$: << "lib"
require_relative "generated"

include Peto
Procedure.do_a(1, "two", TypeB.new(:foo=>"hoge"))
Procedure.do_b(TypeA.new(:baz=>[1,2,3]))
Procedure.do_c()

