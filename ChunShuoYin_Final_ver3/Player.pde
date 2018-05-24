//  use this class to create player

class Player
{
  PImage PlayerImg;
  PImage PlayerBullet;
  
  int x = 300;
  int x_added = 90;  // the width of the image
  int y = 900;
  int y_added = 90;  //  the height of the image
  
  int Damage;
  int Health = 1000;  
  
  boolean isDead;
  
  float TimeTofire = 0;  //  control the fire
  
  ArrayList<PlayerBullet> m_PlayerBullets = new ArrayList<PlayerBullet>();  
  
  boolean Up=false, Down=false, Left=false, Right=false;  // control player move
  
  void SetUpPlayerImage()
  {      
    PlayerImg = loadImage("angel_1.png");    
    PlayerBullet = loadImage("playerbullet.png");
  }
  
  void Update()
  {
    UpdateBullet();
    CheckBulletDead();
    
    image(PlayerImg, x, y, x_added, y_added);
  }
  
  void UpdateBullet()
  {
    for(int i = m_PlayerBullets.size() ; i > 0 ; i--)
    {
      PlayerBullet pb = m_PlayerBullets.get(i-1);
      pb.MoveFoward();
      pb.DrawObj();
      pb.CheckBulletDead();
    }
  }
  
  void CheckBulletDead()
  {
    for(int i = m_PlayerBullets.size() ; i > 0 ; i--)
    {
      PlayerBullet eb = m_PlayerBullets.get(i-1);
      if(eb.isDead)
        m_PlayerBullets.remove(i-1);
    }
  }
  
  void FireWeapon()
  {
    if(millis() - TimeTofire > 75)
    {
      TimeTofire = millis();
     // m_PlayerBullets.add(new PlayerBullet(x + x_added-30, y + y_added/2 + 9, PlayerBullet));
      m_PlayerBullets.add(new PlayerBullet(x + 40, y + y_added/2 - 2, PlayerBullet));
     // m_PlayerBullets.add(new PlayerBullet(x + x_added-30, y + y_added/2 - 11, PlayerBullet));
    }
  }
}