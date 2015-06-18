//
//  LevelSelectionPage.h
//  MemoryGameApp
//
//  Created by Surjit Joshi on 22/06/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <sqlite3.h>
#import <AVFoundation/AVFoundation.h>

#import <GameKit/GameKit.h>
#import "GameCenterManager.h"
#import "AppSpecificValues.h"


#import <StoreKit/StoreKit.h>
#import "FbGraph.h"

@class GameCenterManager;

@interface LevelSelectionPage : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate>
{
    AppDelegate *mainDelegate;
    
    UILabel *grantTotal;
    
    //Database
    const char* dbpath;
    sqlite3 *memoryappDB;

    AVAudioPlayer *buttonClickMusic;
    
    //Game center
    
    UIButton *achievementsBtn, *leaderboardBtn, *moreBtn;
    
    GameCenterManager *gameCenterManager;
    
    int64_t  currentScore;
    
    NSString* currentLeaderBoard;
    
    IBOutlet UILabel *currentScoreLabel;
    
    UIView *moreView;
    
    //Facebook
	
    FbGraph *fbGraph;
    
}

@property (nonatomic, retain) FbGraph *fbGraph;

@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, assign) int64_t currentScore;
@property (nonatomic, retain) NSString* currentLeaderBoard;
@property (nonatomic, retain) UILabel *currentScoreLabel;

- (void) initDatabase;
-(void) getTotalScore;

@end
