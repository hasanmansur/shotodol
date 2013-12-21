using aroop;
using shotodol;

internal class FileConfigTest : UnitTest {
	etxt tname;
	public FileConfigTest() {
		tname = etxt.from_static("FileConfig Test");
	}
	public override aroop_hash getHash() {
		return tname.get_hash();
	}
	public override void getName(etxt*name) {
		name.dup_etxt(&tname);
	}
	public override int test() throws UnitTestError {
		print("FileConfigTest:~~~~TODO fill me\n");
		return 0;
	}
}
