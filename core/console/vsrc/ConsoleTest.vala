using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */

internal class ConsoleTest : UnitTest {
	public ConsoleTest() {
		extring tname = extring.copy_static_string("Console");
		base(&tname);
	}
	public override int test() throws UnitTestError {
		throw new UnitTestError.FAILED("Unimplemented\n");
	}
}

/* @} */
