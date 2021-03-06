using aroop;
using shotodol;

/** \addtogroup idle
 *  @{
 */
public class shotodol.IdleModule : DynamicModule {
	IdleModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		extring spindle = extring.set_static_string("MainFiber");
		IdleCommand.IdleFiber sp = new IdleCommand.IdleFiber();
		PluginManager.register(&spindle, new AnyInterfaceExtension(sp, this));
		extring command = extring.set_static_string("command");
		PluginManager.register(&command, new M100Extension(new IdleCommand(sp), this));
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new IdleModule();
	}
}
/* @} */

