using aroop;
using shotodol;

/** \addtogroup str_arms
 *  @{
 */
public class shotodol.BrainEngine<G> : Replicable {
	//OPPFactory<LineAlign> response;
	OPPFactory<LineAlign<G>> sandbox;
	OPPFactory<LineAlign<G>> memory;
	WordSet words;
	
	public BrainEngine() {
		memory = OPPFactory<LineAlign<G>>.for_type(16, 0, factory_flags.MEMORY_CLEAN);
		//response = OPPFactory<LineAlign>.for_type();
		sandbox = OPPFactory<LineAlign<G>>.for_type(16, 0, factory_flags.MEMORY_CLEAN);
		words = new WordSet();
	}

	~BrainEngine() {
		memory.destroy();
		sandbox.destroy();
	}
	
	public int memorize_estr(extring*wds, G? sense) {
		if(wds == null || wds.is_empty_magical()) {
			return -1;
		}
		LineAlign<G> ln = LineAlign.factoryBuild(&memory,words,sense);
		ln.pin();
		return ln.align_estr(wds);
	}
	
	public int memorize(InputStream strm, G? sense) {
		LineAlign<G> ln = LineAlign.factoryBuild(&memory,words,sense);
		ln.pin();
		return ln.align(strm);
	}
	
	public G? percept_prefix_match(extring*wds) {
		if(wds.is_empty_magical()) {
			return null;
		}		
		G?ret = null;
		int strength = 0;
		memory.visit_each((data) =>{
			unowned LineAlign<G> ln = (LineAlign<G>)data;
			int len = 0;
			G?sense = ln.percept_prefix_match(wds, &len);
			if(strength < len) {
				ret = sense;
				strength = len;
			}
			sense = null;
			return 0;
		}, Replica_flags.ALL, 0, 0);
		return ret;
	}
	
	public int percept(extring word) {
		int similarity = 0;
		// calculate similarity with memory
		return similarity;
	}
}
/** @}*/
