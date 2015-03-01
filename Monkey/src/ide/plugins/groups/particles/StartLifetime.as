package ide.plugins.groups.particles {
	
	import flash.events.Event;
	
	import ide.App;
	import ide.events.SelectionEvent;
	
	import monkey.core.entities.particles.ParticleSystem;
	import monkey.core.entities.particles.prop.value.PropConst;
	import monkey.core.entities.particles.prop.value.PropCurves;
	import monkey.core.entities.particles.prop.value.PropRandomTwoConst;
	
	import ui.core.Menu;
	import ui.core.container.Box;
	import ui.core.controls.CurvesEditor;
	import ui.core.controls.Label;
	import ui.core.controls.Spinner;
	import ui.core.event.ControlEvent;

	public class StartLifetime extends ParticleAttribute {
		
		[Embed(source="arrow.png")]
		private static var ARROW : Class;
		
		private var arrow	 : ImageButtonMenu;
		private var label	 : Label;
		private var header	 : Box;
		
		// const模式
		private var oneConst : Spinner;
		// curve模式
		private var curves	 : CurvesEditor;
		// two const
		private var minConst : Spinner;
		private var maxConst : Spinner;
		
		public function StartLifetime() {
			super(); 
			this.header	  = new Box();
			this.header.orientation = Box.HORIZONTAL;
			this.arrow	  = new ImageButtonMenu(new ARROW());
			this.label	  = new Label("Lifetime:", 160);
			this.header.addControl(this.arrow);
			this.header.addControl(this.label);
			this.header.maxHeight = 20;
			this.oneConst = new Spinner();
			this.curves   = new CurvesEditor();
			this.minConst = new Spinner();
			this.maxConst = new Spinner();
			this.curves   = new CurvesEditor(230, 150);
			var curveMenu : Menu = new Menu();
			curveMenu.addMenuItem("confirm", changeCurves);
			this.curves.view.contextMenu = curveMenu.menu;
			this.oneConst.addEventListener(ControlEvent.CHANGE, changeOne);
			this.minConst.addEventListener(ControlEvent.CHANGE, changeRandomTwoConst);
			this.maxConst.addEventListener(ControlEvent.CHANGE, changeRandomTwoConst);
			
			this.arrow.addMenu("Const", changeToConst);
			this.arrow.addMenu("Curve", changeToCurve);
			this.arrow.addMenu("RandomTwoConst", changeToRandomTwoConst);
		}
		
		private function changeToRandomTwoConst(e : Event) : void {
			this.particle.startLifeTime = new PropRandomTwoConst(5, 5);
			this.app.dispatchEvent(new SelectionEvent(SelectionEvent.CHANGE));
		}
		
		private function changeToCurve(e : Event) : void {
			this.particle.startLifeTime = new PropCurves();
			this.app.dispatchEvent(new SelectionEvent(SelectionEvent.CHANGE));
		}
		
		private function changeToConst(e : Event) : void {
			this.particle.startLifeTime = new PropConst();
			this.app.dispatchEvent(new SelectionEvent(SelectionEvent.CHANGE));
		}
				
		private function changeRandomTwoConst(event:Event) : void {
			this.particle.startLifeTime = new PropRandomTwoConst(minConst.value, maxConst.value);	
		}
		
		private function changeCurves(event:Event) : void {
			var data : PropCurves = new PropCurves();
			data.curve.datas = this.curves.points;
			data.yValue = this.curves.axisYValue;
			this.particle.startLifeTime = data;
		}
		
		private function changeOne(event:Event) : void {
			this.particle.startLifeTime = new PropConst(this.oneConst.value);		
		}
		
		override public function updateGroup(app:App, particle:ParticleSystem):void {
			super.updateGroup(app, particle);
			this.removeAllControls();
			this.addControl(this.header);
			this.particle.addEventListener(ParticleSystem.BUILD, onParticleBuild);
			if (particle.startLifeTime is PropConst) {
				this.orientation = HORIZONTAL;
				this.addControl(this.oneConst);
				this.oneConst.value = (particle.startLifeTime as PropConst).value;
				this.minHeight = 20;
				this.maxHeight = 20;
			} else if (particle.startLifeTime is PropRandomTwoConst) {
				this.orientation = HORIZONTAL;
				var randomTwoConst : PropRandomTwoConst = particle.startLifeTime as PropRandomTwoConst;
				this.addControl(this.minConst);
				this.addControl(this.maxConst);
				this.minConst.value = randomTwoConst.minValue;
				this.maxConst.value = randomTwoConst.maxValue;
				this.minHeight = 20;
				this.maxHeight = 20;
			} else if (particle.startLifeTime is PropCurves) {
				this.orientation = VERTICAL;
				var propCurves : PropCurves = particle.startLifeTime as PropCurves;
				this.addControl(this.curves);
				this.curves.axisXValue = particle.duration;
				this.curves.axisYValue = propCurves.yValue;
				this.curves.points = propCurves.curve.datas;
				this.minHeight = 230;
				this.maxHeight = 230;
			}
		}
		
		private function onParticleBuild(event:Event) : void {
			this.curves.axisXValue = particle.duration;
		}
		
	}
}
