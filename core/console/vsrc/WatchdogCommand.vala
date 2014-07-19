using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */
internal class shotodol.WatchdogCommand : shotodol.M100Command {
	enum Options {
		LEVEL = 1,
		FILENAME,
		LINENO,
		SEVERITY,
		NAME,
	}
	
	Watchdog ?wd;
	HashTable<xtring,xtring?> namedCmds;
	public WatchdogCommand() {
		extring prefix = extring.set_static_string("watchdog");;
		base(&prefix);
		namedCmds = HashTable<xtring,xtring?>(xtring.hCb,xtring.eCb);
		wd = new Watchdog(null, 100);
		addOptionString("-l", M100Command.OptionType.INT, Options.LEVEL, "Set log level");
		addOptionString("-fn", M100Command.OptionType.TXT, Options.FILENAME, "Match filename");
		addOptionString("-ln", M100Command.OptionType.INT, Options.LINENO, "Match Line number");
		addOptionString("-s", M100Command.OptionType.INT, Options.SEVERITY, "Match severity");
		addOptionString("-n", M100Command.OptionType.TXT, Options.NAME, "Name a watch settings, like \n watchdog -fn main.c -n main \n watchdog -n main");
	}

	~WatchdogCommand() {
		wd.stop();
		wd = null;
		namedCmds.destroy();
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		extring*sourcefile = null;
		int lineno = -1;
		int logLevel = 3;
		int severity = -1;
		
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring? arg = null;
		bool newNamedCmd = false;
		if((sourcefile = vals[Options.FILENAME]) != null) {newNamedCmd = true;} 
		if((arg = vals[Options.LINENO]) != null) {lineno = arg.ecast().to_int();newNamedCmd = true;} 
		if((arg = vals[Options.LEVEL]) != null) {logLevel = arg.ecast().to_int();newNamedCmd = true;} 
		if((arg = vals[Options.SEVERITY]) != null) {severity = arg.ecast().to_int();newNamedCmd = true;} 
		if((arg = vals[Options.NAME]) != null) {
			xtring nm = arg; 
			if(newNamedCmd) {
				xtring remember = new xtring.copy_deep(cmdstr);
				namedCmds.set(nm, remember);
			} else {
				xtring?oldCmd = namedCmds.get(nm);
				if(oldCmd != null) {
					return act_on(oldCmd, pad, cmds);
				}
			}
		} 
		wd.dump(pad, sourcefile, lineno, logLevel, severity);
		return 0;
	}
}
/* @} */
