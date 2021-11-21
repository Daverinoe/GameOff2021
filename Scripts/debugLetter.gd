extends KinematicBody2D

signal sentenceFinished

var direction : Vector2 = Vector2.RIGHT
var damage : float = 0.5
var letterNum = 0
var sentenceNum = 0

export(int, 0, 800) var speed : int = 400

var sentences = ["What.the.bug.did.you.just.bugging.say.about.me,you.little.bug?.I'll.have.you.know.I.graduated.top.of.my.computer.science.class,and.I've.been.involved.in.numerous.secret.raids.on.Facebook,.and.I.have.over.300.confirmed.PRs..I.am.trained.in.cpp.warfare.and.I'm.the.top.coder.in.the.entire.US.IT.department.You.are.nothing.to.me.but.just.another.target..I.will.wipe.you.the.bug.out.with.precision.the.likes.of.which.has.never.been.seen.before.on.this.Earth,.mark.my.bugging.words..You.think.you.can.get.away.with.saying.that.shit.to.me.over.the.Internet?.Think.again,.bug..As.we.speak.I.am.contacting.my.secret.network.of.spies.across.the.USA.and.your.IP.is.being.traced.right.now.so.you.better.prepare.for.the.storm,.maggot..The.storm.that.wipes.out.the.pathetic.little.thing.you.call.your.digital.life..You're.bugging.dead,.kid..I.can.be.anywhere,.anytime,.and.I.can.decompile.you.in.over.seven.hundred.languages,.and.that's.just.with.my.bare.hands..Not.only.am.I.extensively.trained.in.unarmed.coding,.but.I.have.access.to.the.entire.digital.arsenal.of.the.United.States.IT.Corps.and.I.will.use.it.to.its.full.extent.to.wipe.your.miserable.digital.fingerprint.off.the.face.of.the.continent,.you.little.shit..If.only.you.could.have.known.what.unholy.retribution.your.little.'clever'.comment.was.about.to.bring.down.upon.you,.maybe.you.would.have.held.your.bugging.tongue..But.you.couldn't,.you.didn't,.and.now.you're.paying.the.price,.you.goddamn.idiot..I.will.code.fury.all.over.you.and.you.will.drown.in.it..You're.bugging.dead,.kiddo.",\
				"Has.Anyone.Really.Been.Far.Even.as.Decided.to.Use.Even.Go.Want.to.do.Look.More.Like?",\
				"Why.is.a.mouse.when.it.spins?.The.higher,the.fewer.",\
				"Did.you.ever.hear.the.tragedy.of.Darth.Plagueis.The.Wise?.I.thought.not.It’s.not.a.story.the.Jedi.would.tell.you..It’s.a.Sith.legend..Darth.Plagueis.was.a.Dark.Lord.of.the.Sith,.so.powerful.and.so.wise.he.could.use.the.Force.to.influence.the.midichlorians.to.create.life…He.had.such.a.knowledge.of.the.dark.side.that.he.could.even.keep.the.ones.he.cared.about.from.dying..The.dark.side.of.the.Force.is.a.pathway.to.many.abilities.some.consider.to.be.unnatural..He.became.so.powerful….the.only.thing.he.was.afraid.of.was.losing.his.power,.which.eventually,.of.course,.he.did.Unfortunately,.he.taught.his.apprentice.everything.he.knew,.then.his.apprentice.killed.him.in.his.sleep..Ironic..He.could.save.others.from.death,.but.not.himself.",\
				]

var sentence = ""

func _ready() -> void:
	sentence = sentences[sentenceNum]
	$Label.text = sentence[letterNum % sentence.length()]
	if letterNum == sentence.length() - 1:
		emit_signal("sentenceFinished")

func _physics_process(delta) -> void:
	var velocity = direction * speed * delta
	var collision = move_and_collide(velocity)
	check_collision(collision)

func check_collision(collision : KinematicCollision2D) -> void:
	if collision != null:
		if collision.collider.is_in_group("Enemy"):
			collision.collider.on_hit(damage)
			call_deferred("queue_free")
		elif !collision.collider.is_in_group("Friendly"):
			call_deferred("queue_free")
