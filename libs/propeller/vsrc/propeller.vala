using aroop;
using shotodol;

public abstract class shotodol.Propeller : Spindle {
	protected Set<Spindle> sps; 
	protected Queue<Replicable> msgs; // message queue
	protected bool cancelled;
	
	public Propeller() {
		sps = Set<Spindle>();
		msgs = Queue<Replicable>((uchar)get_id());
	}
	
	protected override int start(Propeller?p) {
		cancelled = false;
		sps.visit_each((data) => {
			unowned Spindle sp = ((container<Spindle>)data).get();
			sp.start(this);
			return 0;
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		run();
		return 0;
	}
	
	public virtual uint get_id() {
		return 0;
	}
	
	protected override int step() {
		sps.visit_each((data) => {
			unowned Spindle sp = ((container<Spindle>)data).get();
			sp.step();
			return 0;
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		return 0;
	}
	
	protected void run() {
		while(!cancelled) {
			step();
		}
	}
	
	public override int cancel() {
		cancelled = true;
		return 0;
	}
	
	~Propeller() {
		msgs.destroy();
		sps.destroy();
	}
}
