using aroop;
using shotodol;

public class shotodol.Command : Replicable {
	public etxt?cmdprefix;
	public virtual int act_on(ArrayList<txt> tokens, StandardIO io) {
		return 0;
	}
}
