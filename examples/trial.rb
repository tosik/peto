$: << "lib"
require_relative "generated"

include Peto
p Procedure.do_a(1, "two", TypeB.new(:foo=>"hoge"))
p Procedure.do_b(TypeA.new(:baz=>[1,2,3]))
p Procedure.do_c()
p Procedure.do_a_error_invalid_id("oh no!!!")

p TypeC.new(:foo=>["one", "two", "three"])
p TypeC.new(:foo=>[1, 2, 3])
#p TypeB.new(:foo=>4)

