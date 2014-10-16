using aroop;
using shotodol;
using shotodol_platform;

/**
 * \ingroup core
 * \defgroup console Console command support(console)
 */
/** \addtogroup console
 *  @{
 */
public class shotodol.ConsoleModule : DynamicModule {

	public ConsoleModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	public override int init() {
		extring entry = extring.set_static_string("command");
		Plugin.register(&entry, new M100Extension(new WatchdogCommand(), this));
		entry.rebuild_and_set_static_string("unittest");
		Plugin.register(&entry, new AnyInterfaceExtension(new ConsoleTest(), this));
		entry.rebuild_and_set_static_string("onLoad");
		Plugin.register(&entry, new HookExtension(onLoadHook, this));
#if false
		entry.rebuild_and_set_static_string("onQuit");
		Plugin.register(&entry, new HookExtension((onQuitHook), this));
#endif
		return 0;
	}

#if false
	int onQuitHook(extring*msg, extring*output) {
		// Do we need this ?
		return 0;
	}
#endif

	int onLoadHook(extring*msg, extring*output) {
		bool hasConsole = true;
		Unbundler ubndlr = Unbundler();
		ubndlr.build(msg, BundlerAffixes.PREFIX);
		do {
			try {
				int key = ubndlr.next();
				if(key == -1) break;
				if(ubndlr.getContentType() != BundledContentType.STRING_CONTENT) continue;
				extring uarg = extring.set_content((string)ubndlr.getContent(), (int)ubndlr.getContentLength());
				if(uarg.equals_string("-noconsole")) {
					hasConsole = false;
				} else if(uarg.equals_string("--help")) {
					print("-noconsole Use this argument to run the shotodol without shell.\n");
					hasConsole = false;
				}
			} catch(BundlerError err) {
				break;
			}
		} while(true);
		if(!hasConsole) return 0;

		print("Loading console spindle\n");
		extring entry = extring.set_static_string("MainSpindle");
		ConsoleHistory sp = new ConsoleHistory();
		Plugin.register(&entry, new AnyInterfaceExtension(sp, this));
		entry.rebuild_and_set_static_string("command");
		Plugin.register(&entry, new M100Extension(new ConsoleCommand(sp), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ConsoleModule();
	}
}

/* @} */
