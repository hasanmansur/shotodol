using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100Extension : Extension {
	M100Command?cmd;
	public M100Extension(M100Command gCommand, Module mod) {
		base(mod);
		cmd = gCommand;
	}
	public override Replicable?getInterface(extring*service) {
		return cmd;
	}
	public override int desc(OutputStream pad) {
		base.desc(pad);
		extring dlg = extring.stack(128);
		dlg.concat_string("\tCommand,\t\t");
		pad.write(&dlg);
		cmd.desc(M100Command.CommandDescType.COMMAND_DESC_TITLE, pad);
		return 0;
	}
}
/** @}*/
