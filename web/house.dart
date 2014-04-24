library house;

import 'dart:html';
import 'package:three/three.dart';

final HtmlElement container = querySelector("#container2");
final HtmlElement appletWindow = querySelector("#applet_window");
final HtmlElement overlay = querySelector("#overlay");
final HtmlElement loadConductionButton = querySelector("#load_conduction");
final HtmlElement loadConvectionButton = querySelector("#load_convection");

PerspectiveCamera camera;
WebGLRenderer renderer;
Scene scene;
Mesh cube;

void main() {
    init();
    //animate(0);
}

  void init() {

    scene = new Scene();

    camera = new PerspectiveCamera( 70.0, container.clientWidth / container.clientHeight, 1.0, 1000.0 );
    camera.position.z = 400.0;

    scene.add(camera);

    var geometry = new CubeGeometry( 200.0, 200.0, 200.0 );
    var material = new MeshBasicMaterial( color:0xff0000 );

    cube = new Mesh( geometry, material);
    scene.add( cube );

    renderer = new WebGLRenderer();
    renderer.setSize( container.clientWidth, container.clientHeight);
    container.nodes.add( renderer.domElement );
    
    _bind();

  }

  animate(num time) {

    print(time);
    window.requestAnimationFrame( animate );
    //cube.rotation.x += 0.005;
    //cube.rotation.y += 0.01;
    renderer.render( scene, camera );

  }


void _bind() {
  container.onDoubleClick.listen(_onCanvasDoubleClick);
  overlay.onMouseDown.listen(_onOverlayMouseDown);  
}

/* interactivity */

void _onCanvasDoubleClick(MouseEvent e) {
  e.preventDefault();
  appletWindow.style.display = "block";
  overlay.style.display = "block";
  int index = 1;
  switch(index){
    case 0:
      loadConductionButton.click();
      break;
    case 1:
      loadConvectionButton.click();
      break;
  }
  e.stopPropagation();
}


// others

void _onOverlayMouseDown(MouseEvent e) {
  appletWindow.style.display = "none";
  overlay.style.display = "none";
  requestRedraw();
}



/* visualization */

void requestRedraw() {
}

