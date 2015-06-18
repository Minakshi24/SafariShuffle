//
//  GameLogicPage.h
//  MemoryGameApp
//
//  Created by Surjit Joshi on 22/06/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface GameLogicPage : UIViewController
{
    int firstOpenedImage, secondOpenedImage;
    
    NSMutableArray *imagesToRemove;
    
    int selectedLevel;
    
    NSMutableArray *numbersArr;
    NSMutableArray *animalArray;
    
    int score;
    UILabel *scoreLabel;
    
    NSArray *openedImages;
    NSMutableArray *allOpenedImages, *indivisualArray;
    
    int numRemainingImages;
    
    AppDelegate *mainDelegate;
    
   
}

-(void) removeImages;

@property int selectedLevel;
-(NSMutableArray *) makeRandomNumberArr : (int) totalImages;
-(void) setInitialValues : (int) selectedLevel;


@end
