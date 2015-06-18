//
//  HighScorePage.h
//  Safari Shuffle
//
//  Created by Ankita Chordia on 12/7/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <sqlite3.h>
#import <AVFoundation/AVFoundation.h>

@interface HighScorePage : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    AppDelegate *mainDelegate;
    
    float w,h ;
    
    UITableView *easyTableView, *hardTableView;
    
    //Database
    
    const char* dbpath;
    sqlite3 *memoryappDB;
    
    NSMutableArray *easyUserArray, *hardUserArray;
    
    AVAudioPlayer *buttonClickMusic;

}

- (void) initDatabase;

-(void) getDataFromDb;

@end
