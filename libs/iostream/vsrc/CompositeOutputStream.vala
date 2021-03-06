using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public class shotodol.CompositeOutputStream : OutputStream {
	bool closed;
	OPPList<OutputStream> collection;
	public CompositeOutputStream(int inc = 16, uchar mark = aroop.factory_flags.HAS_LOCK | aroop.factory_flags.SWEEP_ON_UNREF) {
		closed = false;
		collection = OPPList<OutputStream>(inc, mark | aroop.factory_flags.EXTENDED /* token will only work when it is EXTENDED */);
	}
	~CompositeOutputStream() {
		collection.destroy();
	}

	public aroop_uword16 addOutputStream(OutputStream ostrm) {
		if(closed)
			return 0;
		AroopPointer<OutputStream> ptr = collection.add_pointer(ostrm);
		return ptr.get_token();
	}

	public unowned OutputStream? getOutputStream(aroop_uword16 token) {
		if(closed)
			return null;
		AroopPointer<OutputStream>?ptr = collection.get_by_token(token);
		if(ptr == null) 
			return null;
		return ptr.getUnowned();
	}

	public override int write(extring*buf) throws IOStreamError.OutputStreamError {
		if(closed)
			return 0;
		int len = buf.length();
		if(len <= 2)
			return len;
		aroop_uword16 token = buf.char_at(0);
		token = token << 8;
		token |= buf.char_at(1);
		buf.shift(2);
		unowned OutputStream? ostrm = getOutputStream(token);
		if(ostrm == null) 
			return -1;
		return ostrm.write(buf) + 2;
	}

	public override void close() throws IOStreamError.OutputStreamError {
		if(closed)return;
		closed = true;
		collection.destroy(); // XXX should we close each of them ??
	}
}


/* @} */
