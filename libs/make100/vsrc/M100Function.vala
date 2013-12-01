using aroop;
using shotodol;

internal class M100Function: Searchable {
	txt name;
	txt upper;
	ArrayList<txt> cmds;
	int ccount;
	internal void build(etxt*nm, etxt*proto) {
		name = new txt.memcopy_etxt(nm);
		upper = new txt.memcopy_etxt(proto);
		cmds = ArrayList<txt>();
		etxt varname = etxt.from_static("function");
		Watchdog.watchvar(5,0,0,0,&varname,name);
		ccount = 0;
	}
	~M100Function() {
		cmds.destroy();
	}
	internal int addCommand(etxt*cmd) {
		txt newcmd = new txt.memcopy_etxt(cmd);
		M100Parser.trim(newcmd);
		cmds[ccount++] = newcmd;
		etxt varname = etxt.from_static("function_command");
		Watchdog.watchvar(5,0,0,0,&varname,newcmd);
		return 0;
	}
	internal txt? getCommand(int index) {
		return cmds[index];
	}
}
