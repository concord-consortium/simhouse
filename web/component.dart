part of energy2d;

class Component {

  Math.MutableRectangle boundBox;
  String fillStyle = "rgba(255, 0, 0, 0.5)";
  String strokeColor = "black";
  int lineWidth = 4;

  Component(int left, int top, int width, int height) {
    boundBox = new Math.MutableRectangle(left, top, width, height);
  }
  
  void move(int dx, int dy) {
    boundBox.left += dx;
    boundBox.top += dy;
    if(boundBox.left < 0) boundBox.left = 0;
    else if(boundBox.left > canvas.width - boundBox.width) boundBox.left = canvas.width - boundBox.width;
    if(boundBox.top < 0) boundBox.top = 0;
    else if(boundBox.top > canvas.height - boundBox.height) boundBox.top = canvas.height - boundBox.height;
  }

}
