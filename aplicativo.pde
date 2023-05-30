import processing.sound.*;
SoundFile music;

PImage backgroundImage;
boolean gameStarted = false;
boolean gameOver = false;

class Snake {
  ArrayList<PVector> segments;
  int direction;
  int speed;

  Snake() {
    segments = new ArrayList<PVector>();
    segments.add(new PVector(10, 10));
    direction = RIGHT;
    speed = 10;
  }

  void move() {
    PVector head = segments.get(0).copy();
    switch (direction) {
      case UP:
        head.y -= 1;
        break;
      case DOWN:
        head.y += 1;
        break;
      case LEFT:
        head.x -= 1;
        break;
      case RIGHT:
        head.x += 1;
        break;
    }
    if (head.x < 0) {
      head.x = width / 10 - 1;
    }
    if (head.x > width / 10 - 1) {
      head.x = 0;
    }
    if (head.y < 0) {
      head.y = height / 10 - 1;
    }
    if (head.y > height / 10 - 1) {
      head.y = 0;
    }
    segments.add(0, head);
    segments.remove(segments.size() - 1);
  }

  void draw() {
    for (PVector segment : segments) {
      fill(255);
      rect(segment.x * 10, segment.y * 10, 10, 10);
    }
  }

  boolean checkCollision() {
    PVector head = segments.get(0);
    for (int i = 1; i < segments.size(); i++) {
      PVector segment = segments.get(i);
      if (head.equals(segment)) {
        return true;
      }
    }
    return false;
  }
}

Snake snake;
PVector food;
int score;

void setup() {
  size(500, 500);
  backgroundImage = loadImage("capa.jpg");
  music = new SoundFile(this, "audio.mp3");
  music.play();
}

void draw() {
  if (!gameStarted) {
    image(backgroundImage, 0, 0, width, height);
    fill(0);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("Aperte a tecla ESPAÇO para iniciar o jogo!", width/2, height/2);
    return;
  }

  if (gameOver) {
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("Você morreu por colisão, quanta burrice.", width/2, height/2);
    music.stop();
    return;
  }

  // jogo iniciado, desenha o cenario e a cobra
  background(0);
  if (frameCount % (19 - snake.speed) == 0) {//altera a velocidade da cobra
    snake.move();
    if (snake.checkCollision()) { // verifica colisão
      gameOver = true;
      music.stop();
      return;
    }
    if (snake.segments.get(0).equals(food)) {
      snake.segments.add(snake.segments.get(snake.segments.size() - 1).copy());
      spawnFood();
      score++;
      snake.speed = min(15, snake.speed + 1); // aumenta a velocidade da cobra
      if (!music.isPlaying()) {
        music.play();
      }
    }
  }
  snake.draw();
  fill(255);
  rect(food.x * 10, food.y * 10, 10, 10);

  fill(255, 255, 255, 200);
  textSize(24);
  textAlign(LEFT, TOP);
  text("Score: " + score, 10, 10);
}

void spawnFood() {
  food = new PVector(floor(random(width / 10)), floor(random(height / 10)));
}

void keyPressed() {
  if (!gameStarted) {
    if (keyCode == 32) { // 32 é espaço na tabela ASCII
      snake = new Snake();
      spawnFood();
      score = 0;
      gameStarted = true;
    }
    return;
  }

  if (keyCode == UP && snake.direction != DOWN) {
    snake.direction = UP;
  } else if (keyCode == DOWN && snake.direction != UP) {
    snake.direction = DOWN;
  } else if (keyCode == LEFT && snake.direction != RIGHT) {
    snake.direction = LEFT;
  } else if (keyCode == RIGHT && snake.direction != LEFT) {
    snake.direction = RIGHT;
  } else if (keyCode == 32) { // 32 é espaço na tabela ASCII
    gameStarted = true;
  }
}
