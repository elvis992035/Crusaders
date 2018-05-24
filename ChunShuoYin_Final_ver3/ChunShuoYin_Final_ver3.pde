import ddf.minim.*;

PImage TitleImg;  
PImage StoryImg;
PImage InstructionImg;
PImage LoseImg;
PImage WinImg;

Minim minim;
AudioPlayer FullGameSong;

MainGame mg = new MainGame();  // declare the class Main = mg

boolean[] keys = new boolean[255];  // declare the keys in array 

boolean isTitle = true;
boolean isStory = false;
boolean isInstruction = false;
boolean isInGame = false;
boolean isGameOver = false;
boolean isWin = false;
boolean NextPage = false;  // use this boolean to control the page from title to story and intruction

float Score = 0;

void setup()
{   
  minim = new Minim(this);
  LoseImg = loadImage("lose.png");
  WinImg = loadImage("win.jpg");
  TitleImg = loadImage("Title.png");
  StoryImg = loadImage("story.png");
  InstructionImg = loadImage("instruction.png");
  
  FullGameSong = minim.loadFile("01. 翼.mp3");  
  
  size(600, 1000);
  background(255);
  mg.SetUp();  // set the main game
  mg.m_Player.SetUpPlayerImage();  //  set the player
}

void draw()
{
  background(0); 
    
  if(isTitle)
  {        
    FullGameSong.play();
    imageMode(CORNER);
    image(TitleImg, 0, 200, 600, 600);    
  }
  
  if(isStory)
  {
    imageMode(CORNER);
    image(StoryImg, 0, 200, 600, 600);
  }
  
  if(isInstruction)
  {
    imageMode(CORNER);
    image(InstructionImg, 0, 200, 600, 600);
  } 
  
  //  main game process
    
  if(isInGame)
  {
    mg.update();
    updatePlayer();
    if(mg.GameOver == true)
    {
      Score = mg.Score;
      isInGame = false;
      isGameOver = true;
      mg.GameOver = false;
      mg.Clean();  //  clean the bullets
    }
    
    if(mg.GameWin == true)
    {
      Score = mg.Score;
      isInGame = false;
      isWin = true;
      mg.GameWin = false;
      mg.Clean();      
    } 
  }
  
  if(isGameOver)
  {
    imageMode(CENTER);
    image(LoseImg, width/2, height/2-50, 600, 400);      
    
    textAlign(CENTER);
    textSize(30);
    fill(255, 255, 255, 255);
    text("You Lose, So sad....  ", width/2, 150);
    text("Your Score : " + Score, width/2, height/2+300);
    text("Left Click to go back to Title  ", width/2, height/2+400);    
               
  }
   
  if(isWin)
  {
    imageMode(CENTER);
    image(WinImg, width/2, height/2, 500, 400);
    
    textAlign(CENTER);
    textSize(30);
    fill(255, 255, 255, 255);
    text("Congrat!! You Win  ", width/2, 250);
    text("Your Score : " + Score, width/2, height/2+300);
    text("Left Click to go back to Title  ", width/2, height/2+400);          
    
  } 
}

void keyPressed()
{
  keys[keyCode] = true;
  if(key == 'w') mg.GameWin = true;  // to win this game directly
  if(key == 'l') mg.GameOver = true;  // to end this game directly
}

void keyReleased()
{
  keys[keyCode] = false;
}

//  move player and control shooting

void updatePlayer()
{
  if(keys[UP]){if(mg.m_Player.y > 0) mg.m_Player.y -= 10;}
  if(keys[DOWN]){if(mg.m_Player.y < height-50) mg.m_Player.y += 10;}
  if(keys[LEFT]){if(mg.m_Player.x > 0) mg.m_Player.x -= 10;}
  if(keys[RIGHT]){if(mg.m_Player.x < width-50) mg.m_Player.x += 10;}
  if(keys[CONTROL]){mg.m_Player.FireWeapon();}
}

//  to change the stage of the game

void mouseClicked()
{
  NextPage = !NextPage;
  
  if(isTitle)
  {
    isTitle = false;    
    isStory = true;
    NextPage = true;
  }
  
  if(isStory && NextPage == false)
  {
    isStory = false;
    isInstruction = true;
  } 
  
  if(isInstruction && NextPage == true)
  {
    isInstruction = false;
    isInGame = true;
  }
  
  if(isGameOver)
  {
    isGameOver = false;
    isTitle = true;
    FullGameSong.play();
  }
  
  if(isWin)
  {
    isWin = false;
    isTitle = true;
    
  }
}