using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
internal errordomain shotodol.M100CommandOptionError.ParseError {
	MISSING_ARGUMENT,
}
internal class shotodol.M100CommandOption : Searchable {
	str prefix;
	str elab;
	M100Command.OptionType tp;
	aroop_hash hash;
	
	internal void build(estr*pre, M100Command.OptionType opt_type, aroop_hash id, estr*help) {
		core.assert(prefix == null && elab == null);
		str p = new str.copy_on_demand(pre);
		str h = new str.copy_on_demand(help);
		build2(p, opt_type, id, h);
	}
	internal void build2(str pre, M100Command.OptionType opt_type, aroop_hash id, str help) {
		core.assert(prefix == null && elab == null);
		prefix = pre;
		elab = help;
		tp = opt_type;
		hash = id;
		set_hash(prefix.ecast().getStringHash());
	}
	internal int desc(OutputStream pad) {
		estr tpText = estr.stack(16);
		tp.asText(&tpText);
		tpText.zero_terminate();
		estr x = estr.stack(128);
		x.printf("\t%10.10s\t\t%10.10s\t%s\n", prefix.ecast().to_string(), tpText.to_string(),  elab.ecast().to_string());
		pad.write(&x);
		return 0;
	}
	internal static int parseOptions(estr*cmdstr, ArrayList<str>*val, SearchableFactory<M100CommandOption>*opts) throws M100CommandOptionError.ParseError {
		estr token = estr();
		estr inp = estr.stack_copy_deep(cmdstr);
		while(true) {
			LineAlign.next_token(&inp, &token);
			if(token.is_empty_magical()) {
				break;
			}
			if(token.char_at(0) != '-') {
				continue;
			}
			M100CommandOption? opt = opts.search(token.getStringHash(), null);
			if(opt == null) {
				// TODO say unknown option
				continue;
			}
			if(token.equals((aroop.estr*)opt.prefix)) {
				if(opt.tp == M100Command.OptionType.TXT) {
					LineAlign.next_token(&inp, &token);
					if(token.is_empty_magical() || token.char_at(0) == '-') {
						//it.destroy();
						throw new M100CommandOptionError.ParseError.MISSING_ARGUMENT("Expected text value here");
					}
					str x = new str.copy_on_demand(&token);
					//val.add_container(x, opt.hash);
					val.set(opt.hash,x);
				} else if(opt.tp == M100Command.OptionType.INT) {
					LineAlign.next_token(&inp, &token);
					if(token.is_empty_magical() || (token.char_at(0) - '0') > 9) {
						//it.destroy();
						throw new M100CommandOptionError.ParseError.MISSING_ARGUMENT("Expected decimal value here");
					}
					str x = new str.copy_on_demand(&token);
					val.set(opt.hash,x);
					//val.add_container(x, opt.hash);
				} else if(opt.tp == M100Command.OptionType.NONE) {
					//val.add_container(str.BLANK_STRING, opt.hash);
					val.set(opt.hash, str.BLANK_STRING);
				}
			}
		}
		return 0;
	}
}
/** @}*/
