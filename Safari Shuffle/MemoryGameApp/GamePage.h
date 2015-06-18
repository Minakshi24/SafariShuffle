//
//  GamePage.h
//  MemoryGameApp
//
//  Created by Ankita Chordia on 7/3/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <sqlite3.h>
#import <AVFoundation/AVFoundation.h>

#import <GameKit/GameKit.h>
#import "GameCenterManager.h"
#import "AppSpecificValues.h"


#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>
#import "FbGraph.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@class GameCenterManager;

@interface GamePage : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate, SKRequestDelegate,SKProductsRequestDelegate,UIWebViewDelegate, UITextFieldDelegate>
{

    AppDelegate *mainDelegate;
    
    float width, height;
    
    int selectedLevel;
    
    NSMutableArray *imagesArray;
    
    UILabel *scoreLabel, *timeLabel;
    
    NSMutableArray *usedIdArray, *usedImagesArray;
    
    int prevTag;
    
    UIImage *firstImage, *secondImage;
    
    UIButton *firstBtn, *secondBtn;
    
    int score, minute, second;
    int totalNumberOfImages;
    
    //Database
    
    const char* dbpath;
    sqlite3 *memoryappDB;

    NSString *levelScore;
    
    UIView *scoreBoard;
    
    BOOL checkFlag;
    
    BOOL btnFlag;

    NSTimer *gameTimer;
    
    UIButton *backBtn;
    UIButton *quitBtn;
    
    AVAudioPlayer *correctMusic, *wrongMusic; 
    AVAudioPlayer *buttonClickMusic;
    
    int pairCounter;
    
    GameCenterManager *gameCenterManager;
    NSString* currentLeaderBoard;
    
    int64_t currentScore;
    
    int totalImages;
    
    UIImageView *achievementAlert;
    
    NSTimer *achievementTimer;
    
    
    //Promo screen
    
    UIImageView *promoView;
    
    
    
    
    MBProgressHUD *_hud;
    UIButton *restoreButton;
    
    UIView *detailView;
    int w,h;
    //UIButton *hint150,*hint300,*award20,*award200,*valuePack,*cancelBtn,*iTuneBtn;
    
    NSMutableArray *purchasedItemIDs;
    
    UIView *moreView;
    
    //Facebook
	
    FbGraph *fbGraph;
    
    NSMutableArray *assetGroups;
    //UIButton *backBtn;
    //AVAudioPlayer *buttonClickMusic;
    
    UIButton *restoreBtn;
    
    
    UIAlertView *photosPurchase, *fbPhotosPurchased;
    
    //Activity 
    
    UIAlertView *activityAlert;
    UIActivityIndicatorView *activityView;
    
    UIImageView *initialBg;
    
}

@property float width, height;

@property int selectedLevel;

@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, assign) int64_t currentScore;
@property (nonatomic, retain) NSString* currentLeaderBoard;

@property (retain) MBProgressHUD *hud;
@property (nonatomic, retain) FbGraph *fbGraph;

-(void) addImages;
-(void) checkForSimirality;
-(void) generateTheGameLogic;
-(void) writeNewScoreToDb : (NSString *)string;
-(NSMutableArray *) generateRandomId : (int) idCnt;
-(NSMutableArray *) generateRandomNumber : (int) levelCnt;

- (void) initDatabase;
-(void) getScoreFromTable;
-(void)fbPhotosBtnAction;
-(void)getFriendPicsFromFB;
-(void)getPhotosFromDevice;
- (void) checkAchievements;
-(void)loadImages : (ALAssetsGroup *)assetGrp;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
-(UIImage *) mergeTwoImages: (UIImage *)bottomImage :(UIImage *)upperImage : (CGRect)rect;




@property (nonatomic, retain) NSMutableArray *assetGroups;



-(void) enterNameInDb : (NSString *)name;
@end
