using aroop;
using shotodol;

/**
 * // C code
 * struct {
 *  unsigned char key;
 *  unsigned int type:2;
 *  unsigned int len:6;
 *  char data[4];
 * };
 *
 * */


public errordomain BundlerError {
	too_big_value,
	faulty_ctn,
	ctn_full,
}

public struct shotodol.Carton {
	public aroop_uword8 data[16];
}

public enum shotodol.BundledContentType {
	BINARY_CONTENT = 0,
	STRING_CONTENT,
	NUMERIC_CONTENT,
}

public struct shotodol.Bundler {
	Carton*ctn;
	int entries;
	int bytes;
	int size;
	public void setCarton(Carton*ctn, int size) {
		core.assert(ctn != null);
		this.ctn = ctn;
		entries = 0;
		bytes = 0;
		this.size = size;
	}
	public void close() {
		this.size = bytes;
		entries = 0;
		bytes = 0;
	}
	public int writeInt(aroop_uword8 key, int val) throws BundlerError {
		// TODO check Carton.size
		if(bytes+6 > size) {
			throw new BundlerError.ctn_full("No space to write int\n");
		}
		
		ctn.data[bytes++] = (aroop_uword8)key;
		if(val >= 0xFFFF) {
			ctn.data[bytes++] = /*(0<<6) |*/ 4; // 0 means numeral , 4 is the numeral size
			ctn.data[bytes++] = (aroop_uword8)((val & 0xFF000000)>>24);
			ctn.data[bytes++] = (aroop_uword8)((val & 0x00FF0000)>>16);
			ctn.data[bytes++] = (aroop_uword8)((val & 0x0000FF00)>>8);
			ctn.data[bytes++] = (aroop_uword8)(val & 0x000000FF);
			entries++;
			return 6;
		} else {
			ctn.data[bytes++] = /*(0<<6) |*/ 2; // 0 means numeral , 2 is the numeral size
			ctn.data[bytes++] = (aroop_uword8)((val & 0xFF00)>>8);
			ctn.data[bytes++] = (aroop_uword8)(val & 0x00FF);
			entries++;
			return 4;
		}
	}
	public int writeETxt(aroop_uword8 key, etxt*val) throws BundlerError {
		// TODO check Carton.size
		int len = val.length();
		if(len > 100) { // make sure that the string is sizable
			throw new BundlerError.too_big_value("Too big string to write\n");
		}
		ctn.data[bytes++] = (aroop_uword8)key;
		ctn.data[bytes++] = (1<<6) | (len+1); // 1 means string
		if(len > 0) {
			((mem)ctn.data).shift(bytes).copy_from((mem)val.to_string(), len);
			bytes+= len;
		}
		ctn.data[bytes++] = '\0'; // null terminate
		return len+1+2;
	}
	public int writeBin(aroop_uword8 key, mem val, int len) throws BundlerError {
		// TODO check Carton.size
		if(len > 100) { // make sure that the string is sizable
			throw new BundlerError.too_big_value("Too big binary data to write\n");
		}
		ctn.data[bytes++] = (aroop_uword8)key;
		ctn.data[bytes++] = (2<<6) | len; // 2 means numeric
		if(len > 0) {
			((mem)ctn.data).shift(bytes).copy_from(val, len);
			bytes+= len;
		}
		return len+2;
	}
	public int getCartonOccupied() {
		return bytes;
	}
	int cur_key;
	int cur_type;
	int cur_len;
	public int next() throws BundlerError {
		if((bytes+2) >= size) {
			return -1;
		}
		cur_key = ctn.data[bytes++];
		cur_type = (ctn.data[bytes] >> 6);
		cur_len = (ctn.data[bytes++] & 0x3F); // 11000000
		if((bytes+cur_len) > size) {
			throw new BundlerError.faulty_ctn("Faulty packet\n");
		}
		return cur_key;
	}
	public int getContentKey() throws BundlerError {
		return cur_key;
	}
	public int getContentType() throws BundlerError {
		return cur_type;
	}
	public unowned mem getContent() throws BundlerError {
		return ((mem)ctn.data).shift(bytes);
	}
	public int getContentLength() throws BundlerError {
		return cur_len;
	}
}