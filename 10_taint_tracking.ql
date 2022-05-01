import cpp 
import semmle.code.cpp.dataflow.TaintTracking 
import DataFlow::PathGraph 

class NetworkByteSwap extends Expr {
    NetworkByteSwap() {
        exists(MacroInvocation f| 
            f.getMacroName().regexpMatch("ntoh(s|l|ll)") 
            | this=f.getExpr())
    }
}

class Config extends TaintTracking::Configuration {
    Config() { this = "NetworkToMemFuncLength"} 
    override predicate isSource(DataFlow::Node source) {
        exists(NetworkByteSwap f| source.asExpr() = f)
    }
    override predicate isSink(DataFlow::Node sink) {
        exists(FunctionCall f| f.getTarget().hasName("memcpy") | sink.asExpr() = f.getArgument(2))
    }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink 
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Newwork byte swap flows to memcpy"
