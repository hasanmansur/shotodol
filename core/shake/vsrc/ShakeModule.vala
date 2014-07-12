using aroop;
using shotodol;

/** \addtogroup make
 *  @{
 */
public class shotodol.ShakeModule : DynamicModule {
	public ShakeModule() {
		name = etxt.from_static("shake");
	}
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new ShakeCommand(), this));
		txt test = new txt.from_static("unittest");
		Plugin.register(test, new AnyInterfaceExtension(new ShakeTest(), this));
		txt onLoad = new txt.from_static("onLoad");
		Plugin.register(onLoad, new HookExtension(greetHook, this));
		return 0;
	}
	int greetHook(etxt*msg, etxt*output) {
		etxt greet = etxt.from_static("echo Welcome to opensource shotodol environment. This toy comes with no guaranty. Use it at your own risk.\n");
		CommandModule.server.cmds.act_on(&greet, new StandardOutputStream(), null);
		etxt cmd = etxt.from_static("shake -f ./shotodol.ske -t onLoad\n");
		CommandModule.server.cmds.act_on(&cmd, new StandardOutputStream(), null);
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ShakeModule();
	}
}
/* @} */

