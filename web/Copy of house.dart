library house;

import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'dart:web_gl';

part 'matrix.dart';

final HtmlElement container = querySelector("#container");
final HtmlElement appletWindow = querySelector("#applet_window");
final HtmlElement overlay = querySelector("#overlay");
final HtmlElement loadConductionButton = querySelector("#load_conduction");
final HtmlElement loadConvectionButton = querySelector("#load_convection");

CanvasElement canvas;
RenderingContext gl;
Buffer triangleVertexPositionBuffer;
GlProgram program;

/// Perspective matrix
Matrix4 pMatrix;

/// Model-View matrix.
Matrix4 mvMatrix;

void main() {
  
  mvMatrix = new Matrix4()..identity();
  
  canvas = container.children[0];
  gl = canvas.getContext3d();
  gl.clearColor(51.0/255.0, 204.0/255.0, 1.0, 1.0);
  
  program = new GlProgram('''
            precision mediump float;

            void main(void) {
                gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
            }
          ''','''
            attribute vec3 aVertexPosition;

            uniform mat4 uMVMatrix;
            uniform mat4 uPMatrix;

            void main(void) {
                gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
            }
          ''', ['aVertexPosition'], ['uMVMatrix', 'uPMatrix']);
  gl.useProgram(program.program);
  
  Buffer triangleVertexPositionBuffer = gl.createBuffer();
  gl.bindBuffer(ARRAY_BUFFER, triangleVertexPositionBuffer);
  gl.bufferData(ARRAY_BUFFER, new Float32List.fromList([ 0.0,  1.0,  0.0,
                                                        -1.0, -1.0,  0.0,
                                                         1.0, -1.0,  0.0]), STATIC_DRAW);
  gl.drawArrays(TRIANGLES, 0, 3);  

  _bind();

  //window.animationFrame.then(_vizLoop);

}

void _vizLoop(num delta) {
  requestRedraw();
  window.animationFrame.then(_vizLoop);
}

void _bind() {
  canvas.onDoubleClick.listen(_onCanvasDoubleClick);
  overlay.onMouseDown.listen(_onOverlayMouseDown);  
}

/* interactivity */

// canvas

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
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clear(COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT);
    gl.enable(DEPTH_TEST);
    gl.disable(BLEND);

    // Setup the perspective - you might be wondering why we do this every
    // time, and that will become clear in much later lessons. Just know, you
    // are not crazy for thinking of caching this.
    pMatrix = Matrix4.perspective(45.0, 1.0, 0.1, 100.0);

    // First stash the current model view matrix before we start moving around.
    mvPushMatrix();

    mvMatrix.translate([-1.5, 0.0, -7.0]);

    // Here's that bindBuffer() again, as seen in the constructor
    gl.bindBuffer(ARRAY_BUFFER, triangleVertexPositionBuffer);
    // Set the vertex attribute to the size of each individual element (x,y,z)
    gl.vertexAttribPointer(program.attributes['aVertexPosition'], 3, FLOAT, false, 0, 0);
    setMatrixUniforms();
    // Now draw 3 vertices
    gl.drawArrays(TRIANGLES, 0, 3);

    // Move 3 units to the right
    mvMatrix.translate([3.0, 0.0, 0.0]);

    // Finally, reset the matrix back to what it was before we moved around.
    mvPopMatrix();

}

List<Matrix4> mvStack = new List<Matrix4>();

/**
 * Add a copy of the current Model-View matrix to the the stack for future
 * restoration.
 */
mvPushMatrix() => mvStack.add(new Matrix4.fromMatrix(mvMatrix));

/**
 * Pop the last matrix off the stack and set the Model View matrix.
 */
mvPopMatrix() => mvMatrix = mvStack.removeLast();

/**
 * Write the matrix uniforms (model view matrix and perspective matrix) so
 * WebGL knows what to do with them.
 */
void setMatrixUniforms() {
  gl.uniformMatrix4fv(program.uniforms['uPMatrix'], false, pMatrix.buf);
  gl.uniformMatrix4fv(program.uniforms['uMVMatrix'], false, mvMatrix.buf);
}
