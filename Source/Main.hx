package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

typedef Pt = {x:Float,y:Float};

class Main extends Sprite
{
  var building:Array<Pt> = [];

  public function new()
  {
   super();
   stage.addEventListener( MouseEvent.CLICK, handleClick);
   //stage.addEventListener( MouseEvent.MOUSE_WHEEL, handleWheel);
   stage.addEventListener( KeyboardEvent.KEY_DOWN, handleKey );
  }

  static inline var ONE_DEGREE = 0.017453;
  
  function handleKey (e: KeyboardEvent)
  {
    var direction = 
      switch (e.keyCode)
        {
        case Keyboard.UP: -1;
        case Keyboard.DOWN: 1;
        default: 0;
        };

    rotatePtAboutPivot( building[0], building[1], direction * ONE_DEGREE);
    render();

  }

  function handleClick (e)
  {
    if (building.length == 3)
        clearAngle();
    building.push({x:e.localX, y:e.localY});
    render();
  }

  function clearAngle ()
  {
    graphics.clear ();
    building = [];
  }

  function render ()
  {
    graphics.clear ();
    graphics.lineStyle(4, 0);
    
    for (pt in building)
      graphics.drawCircle( pt.x, pt.y , 3);

    if (building.length == 3)
      {
        graphics.moveTo(building[0].x, building[0].y);
        graphics.lineTo(building[1].x, building[1].y);
        graphics.moveTo(building[0].x, building[0].y);
        graphics.lineTo(building[2].x, building[2].y);        
        trace('Angle = ${calcAngleBetween( building[0], building[1], building[2] )}');
      }

  }


  static function calcAngleBetween (center:Pt, p1:Pt, p2:Pt):Float
  {
    var v1 = {x: p1.x - center.x, y: p1.y - center.y};
    var v2 = {x: p2.x - center.x, y: p2.y - center.y};
    
    var dot = (p:Pt,q:Pt) -> p.x * q.x + p.y * q.y;

    var angle =  Math.acos( dot(v1,v2) / Math.sqrt( dot(v1,v1) * dot(v2,v2) ));    

    return if ( isCounterClockwiseOrder(p1, center, p2)) angle else -1 * angle;    
  }


  static inline function rotatePtAboutPivot( pivot:Pt, butt:Pt, radians: Float)
  {
    var sine = Math.sin( radians );
    var cosine = Math.cos( radians );

    butt.x -= pivot.x;
    butt.y -= pivot.y;

    var newx = cosine * butt.x - sine * butt.y;
    var newy = sine * butt.x + cosine * butt.y;

    butt.x = newx + pivot.x;
    butt.y = newy + pivot.y;

  }

  static function ptDist(p1:Pt,p2:Pt) : Float
  {
    if (p1 == null || p2 == null) return 0;
    var dx = p2.x - p1.x;
    var dy = p2.y - p1.y;
    return Math.sqrt( dx*dx + dy*dy);
  }

  static function isCounterClockwiseOrder(a:Pt,b:Pt,c:Pt) {
    return (b.x - a.x) * (c.y - a.y) > (b.y - a.y) * (c.x - a.x);
  }

}


