using aroop;
using shotodol;

public class shotodol.Watchdog : Replicable {
	internal OutputStream pad;
	internal static Watchdog? watch;
	public Watchdog(OutputStream logger) {
		pad = logger;
		if(watch == null) {
			watch = this;
		}
	}
	public static int watchvar_helper(etxt*buf, etxt*varname, etxt*varval) {
		etxt EQUALS = etxt.from_static("=");
		etxt NEW_LINE = etxt.from_static("\n");
		etxt header = etxt.stack(8);
		buf.concat(varname);
		buf.concat(&EQUALS);
		header.printf("%d:", varval.length());
		buf.concat(&header);
		buf.concat(varval);
		buf.concat(&NEW_LINE);
		return 0;
	}
	public static int watchvar(int mod_id, int severity, int subtype, int id, etxt*varname, etxt*varval) {
		etxt buf = etxt.stack(128);
		watchvar_helper(&buf, varname, varval);
		watchit(mod_id, severity, subtype, id, &buf);
		return 0;
	}
	public static int watchit(int mod_id, int severity, int subtype, int id, etxt*msg) {
		if(watch == null) return 0;
		watch.pad.write(msg);
		return 0;
	}
	public static int reset(Watchdog?w) {
		watch = w;
		return 0;
	}
}