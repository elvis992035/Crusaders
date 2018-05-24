import ddf.minim.*;

//  use this class to process main game

class MainGame
{
  PImage EnemyBulletImg;
  PImage PlayerBulletImg;
  PImage EnemyImg;
  PImage LuciferImg;
  Minim minim;
  AudioPlayer Hit; // declare BGM
  
  int Score = 0;
  int EnemyMakeDelay = 0;  // to control the enemy numbers
  
  Player m_Player = new Player();      
  ArrayList<Enemy_1> m_Enemy1 = new ArrayList<Enemy_1>();  // declare enemy in arraylist
  ArrayList<Lucifer> m_Lucifer = new ArrayList<Lucifer>(); // declare boss in arraylist
    
  boolean GameOver = false;
  boolean GameWin = false;
  
  void SetUp()
  {
    EnemyBulletImg = loadImage("EnemyBullet.png");
    EnemyImg = loadImage("enemy.png");
    LuciferImg = loadImage("Lucifer.png");    
        
  }
 
  // to run all the methods in this class
 
  void update() {    
    m_Player.Update();
    MakeEnemy();
    UpdateEnemy();
    
    CheckCollision();
    UpdateUI();
    CheckGameOver();  
    CheckGameWin();    
  
  }
  
  // to update the UI of the game
  
  void UpdateUI() {
    
    //  to show the player's HP
    
    fill(255,255,255,255);
    textSize(20);
    text("Hp ", 30, height-125);
    
    noStroke();
    fill(255,255,255,255);
    rect(30,height-100,200,20);
    
    if(m_Player.Health > 800)
      fill(0,216,255,255);
    else if(m_Player.Health <= 800 && m_Player.Health > 400)
      fill(29,219,22,255);
    else if(m_Player.Health <= 400 && m_Player.Health > 200)
      fill(255,228,0,255);
    else
      fill(255,0,0,255);
      
    rect(30, height-100, m_Player.Health/5, 20);
    
    
    //  to show the boss' hp
    
    for(int i = m_Lucifer.size(); i > 0; i--) 
    {
      Lucifer lu = m_Lucifer.get(i-1);
      
      stroke(100);
      fill(255, 0, 0, 255);
      textSize(20);
      textAlign(LEFT);
      text("Lucifer", 30, 45);
    
      noStroke();
      fill(255,255,255,255);
      rect(100, 30, 400, 20);
    
      if(lu.Health > 1600)
        fill(0,216,255,255);
      else if(lu.Health <= 1600 && lu.Health > 800)
        fill(29,219,22,255);
      else if(lu.Health <= 800 && lu.Health > 400)
        fill(255,228,0,255);
      else
        fill(255,0,0,255);
      
      rect(100, 30, lu.Health/5, 20);
    }
    
    stroke(255);    
    textSize(30);
    fill(29, 219, 22, 255);
    textAlign(LEFT);
    text("Score : "+ Score, 30, height-25);
  }
  
  //  create enemies in random 
  // enemies will come more when the player's score get higher
  // when player reach the 1000 points, the boss appears
  
  void MakeEnemy() 
  {
    int rnd = (int)random(0,1000);
    if(rnd > (965-EnemyMakeDelay))
    {
      if(Score < 500)
        m_Enemy1.add(new Enemy_1(random(0, width-20), -20, EnemyImg, EnemyBulletImg, 100, 3, 50, 10, 0));
      else if(Score >= 500 && Score < 1000)
        m_Enemy1.add(new Enemy_1(random(0, width-20), -20, EnemyImg, EnemyBulletImg, 200, 5, 50, 10, 250));
      else if(Score >= 1000 && Score < 2000) {
        m_Enemy1.add(new Enemy_1(random(0, width-20), -20, EnemyImg, EnemyBulletImg, 300, 8, 75, 15, 500));
        if(m_Lucifer.size() == 0) {
          m_Lucifer.add(new Lucifer(width/4, 100, LuciferImg, EnemyBulletImg, 2000, 0, 75, 15, 1000));
        }        
      }
      else if(Score >= 2000 && Score < 3000)
        m_Enemy1.add(new Enemy_1(random(0, width-20), -20, EnemyImg, EnemyBulletImg, 400, 8, 75, 15, 750));
      else 
        m_Enemy1.add(new Enemy_1(random(0, width-20), -20, EnemyImg, EnemyBulletImg, 500, 10, 100, 20, 1000));
      
    }
    
    if(Score > 1500) 
    {
      if(Score > 3000)
        EnemyMakeDelay = 40;
      else
        EnemyMakeDelay = 15;
    }
    else
      EnemyMakeDelay = 0;
  }
  
  void UpdateEnemy() 
  {
    for(int i = m_Enemy1.size() ; i > 0 ; i--)
    {
      Enemy_1 e1 = m_Enemy1.get(i-1);
      
      e1.Draw();
      e1.Move();
      e1.FireWeapon();
      
      e1.UpdateBullet();
      e1.CheckBulletDead();
      e1.CheckJetDead();
      
      // when enemy is dead, remove it from the enemy array and add scores.
      
      if(e1.isDead)
      {
        
        e1.CleanBullets();
        m_Enemy1.remove(i-1);
        if(!e1.isDeadOutLine)
          Score += 50;
      }
    }
    
    for(int i = m_Lucifer.size() ; i > 0 ; i--)
    {
      Lucifer lu = m_Lucifer.get(i-1);
      
      lu.Draw();  
      lu.FireWeapon();
      
      lu.UpdateBullet();
      lu.CheckBulletDead();
      lu.CheckDead();
      
      // when lucifer is dead, remove lucifer from lucifer array
      
      if(lu.isDead)
      {
        lu.CleanBullets();
        m_Lucifer.remove(i-1);
        if(!lu.isDeadOutLine)
          Score += 10000;
      }
    }
  }  
  
  // to check whether the player and enemies collide or not
  
  void CheckCollision()
  {
    
    // check enemies and playerbullet
    
    for(int i = m_Enemy1.size(); i > 0 ; i--)
    {
      Enemy_1 e1 = m_Enemy1.get(i-1);
      for(int j = m_Player.m_PlayerBullets.size(); j > 0 ; j--)
      {
        PlayerBullet pb = m_Player.m_PlayerBullets.get(j-1);
        if(pb.x > e1.x && pb.x < e1.x+ e1.x_added &&
        pb.y > e1.y && pb.y < e1.y +  e1.y_added)
        {
          
          pb.isDead = true;
          e1.Health -= pb.Damage;
          
        }
      }
    }
    
    // check boss and playerbullet
    
    for(int i = m_Lucifer.size(); i > 0 ; i--)
    {
      Lucifer lu = m_Lucifer.get(i-1);
      for(int j = m_Player.m_PlayerBullets.size(); j > 0 ; j--)
      {
        PlayerBullet pb = m_Player.m_PlayerBullets.get(j-1);
        if(pb.x > lu.x && pb.x < lu.x+ lu.x_added &&
        pb.y > lu.y && pb.y < lu.y +  lu.y_added)
        {
          
          pb.isDead = true;          
          lu.Health -= pb.Damage;
          if(pb.isDead) println("Lucifer Hp = " + lu.Health);
        }
      }
    }
    
    // check enemybullet and player
    
    for(int i = m_Enemy1.size() ; i > 0 ; i--)
    {
      Enemy_1 e1 = m_Enemy1.get(i-1);
      for(int j = e1.m_EnemyBullets.size() ; j > 0 ; j--)
      {
        EnemyBullet eb = e1.m_EnemyBullets.get(j-1);
        if(eb.x > m_Player.x && eb.x < m_Player.x + m_Player.x_added
        && eb.y > m_Player.y && eb.y < m_Player.y + m_Player.y_added)
        {
          eb.isDead = true;
          m_Player.Health -= eb.Damage;
        }
      }
    }
    
    // check boss and player
    
    for(int i = m_Lucifer.size() ; i > 0 ; i--)
    {
      Lucifer lu = m_Lucifer.get(i-1);
      for(int j = lu.m_EnemyBullets.size() ; j > 0 ; j--)
      {
        EnemyBullet eb = lu.m_EnemyBullets.get(j-1);
        if(eb.x > m_Player.x && eb.x < m_Player.x + m_Player.x_added
        && eb.y > m_Player.y && eb.y < m_Player.y + m_Player.y_added)
        {
          eb.isDead = true;
          m_Player.Health -= eb.Damage;
        }
      }
    }
  } 
    
  void CheckGameOver()
  {
    if(m_Player.Health <= 0)
      GameOver = true;
  }
  
  void CheckGameWin() 
  {
    for(int i = m_Lucifer.size(); i > 0; i--) 
    {
      Lucifer lu = m_Lucifer.get(i-1);
      if(lu.Health <= 0)
        GameWin = true;
    }
    
  } 
  
  // if the gameover or win, run this method to clean all arrays. 
  
  void Clean()
  {
    m_Player.Health = 1000;
    Score = 0;
    
    for(int i = m_Player.m_PlayerBullets.size() ; i > 0 ; i--)
      m_Player.m_PlayerBullets.remove(i-1);
      
    for(int i = m_Enemy1.size() ; i > 0 ; i--)
    {
      Enemy_1 e1 = m_Enemy1.get(i-1);
      e1.CleanBullets();
      m_Enemy1.remove(i-1);
    }  
    
    for(int i = m_Lucifer.size() ; i > 0 ; i--)
    {
      Lucifer lu = m_Lucifer.get(i-1);
      lu.CleanBullets();
      m_Lucifer.remove(i-1);
    }   
   
  }
}