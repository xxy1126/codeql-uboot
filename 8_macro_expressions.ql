import cpp 

from MacroInvocation f, Expr output 

where f.getMacroName().regexpMatch("ntoh(s|l|ll)") and 
    output = f.getExpr()
select output