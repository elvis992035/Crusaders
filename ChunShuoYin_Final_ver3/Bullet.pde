/// to set the basic information of Bullet class

class BulletBaseInfo
{
  PImage BulletImg;
  
  int x = 0;
  int x_added = 20;  // the width of the image
  int y = 0;
  int y_added = 5;  // the height of the image
  int Damage = 50;  
  int Speed = 20;
 // boolean isGuided;
  boolean isDead = false;  // check the bullet is dead or not
}

//  to inherit the basic information of the bullet

class EnemyBullet extends BulletBaseInfo
{
  EnemyBullet(int x1, int y1, PImage img, int Damage_1, int Speed_1)
  {
    x = x1;
    y = y1;
    BulletImg = img;
    Damage = Damage_1;
    Speed = Speed_1;
  }
  
  void MoveFoward()
  {
    y += Speed; // bullet move
  }
  
  //  to remove bullet form the game
  
  void CheckBulletDead()
  {
    if(y+100 > 1000)
      isDead = true;
  }
  
  void DrawObj()
  {
    image(BulletImg, x, y, x_added, y_added);
  }
}

//  to inherit the basic information of the bullet

class PlayerBullet extends BulletBaseInfo
{
  PlayerBullet(int x1, int y1, PImage img)
  {
    x = x1;
    y = y1;
    BulletImg = img;
  }
  
  void MoveFoward()
  {
    y -= Speed;
  }
  
  void CheckBulletDead()
  {
    if(y < -50)
      isDead = true;
  }
  
  void DrawObj()
  {
    image(BulletImg, x, y, x_added, y_added);
  }
}