//
//  GameLogicPage.m
//  MemoryGameApp
//
//  Created by Surjit Joshi on 22/06/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import "GameLogicPage.h"

@implementation GameLogicPage
@synthesize selectedLevel;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    imagesToRemove = [[NSMutableArray alloc] init];
    
    //self.view.backgroundColor = [UIColor lightGrayColor];
    
    //self.navigationController.navigationItem.hidesBackButton = YES;
    
//    UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:@"Quit" style:UIBarButtonItemStylePlain target:self action:@selector(quitAction:)];
//    self.navigationItem.leftBarButtonItem = quitButton;
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    backgroundImageView.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:backgroundImageView];
    
    UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBack.png"]];
    navImage.frame = CGRectMake(0, 0, 320, 44);
    navImage.userInteractionEnabled = YES;
    [self.view addSubview:navImage];
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(10, 6, 72, 24);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [navImage addSubview:backBtn];
    
    UIButton *quitBtn = [[UIButton alloc] init];
    quitBtn.frame = CGRectMake(235, 6, 73, 24);
    quitBtn.backgroundColor = [UIColor clearColor];
    [quitBtn setImage:[UIImage imageNamed:@"quitBtn.png"] forState:UIControlStateNormal];
    [quitBtn addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
    [navImage addSubview:quitBtn];
    
    animalArray = [[NSMutableArray alloc] init];
//    [animalArray addObject:[UIImage imageNamed:@"angel.png"]];
//    [animalArray addObject:[UIImage imageNamed:@"bat-head.png"]];
//    [animalArray addObject:[UIImage imageNamed:@"birds.png"]];
//    [animalArray addObject:[UIImage imageNamed:@"coy.png"]];
//    [animalArray addObject:[UIImage imageNamed:@"fly.png"]];
//    [animalArray addObject:[UIImage imageNamed:@"gift.png"]];
    
    for(int i = 1; i < 47; i++)
    {
        
        [animalArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"smiley%d.png", i]]];
    
    }
    
    NSLog(@"%d", [animalArray count]);
    
    numbersArr = [self makeRandomNumberArr:[animalArray count]];
    
    allOpenedImages = [[NSMutableArray alloc] init];
    indivisualArray = [[NSMutableArray alloc] init];
    
    [self setInitialValues : selectedLevel];
    
}

-(IBAction)goBack:(id)sender
{
    //[self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)quitAction:(id)sender
{
    
    UIAlertView *quitAlertView = [[UIAlertView alloc] initWithTitle:@"Quite to menu?" message:@"Are you sure you want to quit ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Quit", nil];
    [quitAlertView show];
    
}

-(void) setInitialValues : (int) SelectedLevel
{
    score = 0;
    int totalImages, rows, columns;
    firstOpenedImage = 0;
    secondOpenedImage = 0;
    
    if([imagesToRemove count] > 0)
        [imagesToRemove removeAllObjects];
    
    self.title = [NSString stringWithFormat:@"Easy - Level %d", SelectedLevel];
    
    UIImageView *scoreImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"score.png"]];
    scoreImage.frame = CGRectMake(180, 45, 70, 15);
    [self.view addSubview:scoreImage];
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 45, 50, 15)];
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.textAlignment = UITextAlignmentCenter;
    scoreLabel.textColor = [UIColor orangeColor];
    scoreLabel.font = [UIFont systemFontOfSize:20];
    
    [self.view addSubview:scoreLabel];
    
//    UIBarButtonItem *scoreButton = [[UIBarButtonItem alloc] initWithCustomView:scoreLabel];
//    self.navigationItem.rightBarButtonItem = scoreButton;
    
    switch (SelectedLevel) 
    {
        case 1:
        {
            totalImages = 2;
            rows = 1;
            columns = 1;
            
            UIImageView *imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level1Rect.png"]];
            imageview1.frame = CGRectMake(25, 76, 260, 169);
            imageview1.userInteractionEnabled = YES;
            imageview1.tag = 1;
            [self.view addSubview:imageview1];
            
            UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level1Rect.png"]];
            imageview2.frame = CGRectMake(25, 278, 260, 169);
            imageview2.userInteractionEnabled = YES;
            imageview2.tag = 2;
            [self.view addSubview:imageview2];
            
            if([allOpenedImages count] > 0)
                [allOpenedImages removeAllObjects];
            if([indivisualArray count] > 0)
                [indivisualArray removeAllObjects];

            NSArray *arr1 = [[NSArray alloc] initWithObjects:@"1", @"2", @"0", nil];
            [allOpenedImages addObject:arr1];
            
            for(int i = 1; i <= totalImages; i++)
            {
                NSArray *indi_arr1 = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", i], @"0", nil];
                [indivisualArray addObject:indi_arr1];
            }
            
            break;
        }
        case 2:
        {
            totalImages = 4;
            rows = 2;
            columns = 2;
            
            UIImageView *imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level2Rect.png"]];
            imageview1.frame = CGRectMake(15, 76, 135, 140);
            imageview1.userInteractionEnabled = YES;
            imageview1.tag = 1;
            [self.view addSubview:imageview1];
            
            UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level2Rect.png"]];
            imageview2.frame = CGRectMake(170, 76, 135, 140);
            imageview2.userInteractionEnabled = YES;
            imageview2.tag = 2;
            [self.view addSubview:imageview2];
            
            UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level2Rect.png"]];
            imageview3.frame = CGRectMake(15, 278, 135, 140);
            imageview3.userInteractionEnabled = YES;
            imageview3.tag = 3;
            [self.view addSubview:imageview3];
            
            UIImageView *imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level2Rect.png"]];
            imageview4.frame = CGRectMake(170, 278, 135, 140);
            imageview4.userInteractionEnabled = YES;
            imageview4.tag = 4;
            [self.view addSubview:imageview4];
            
            NSArray *arr1 = [[NSArray alloc] initWithObjects:@"1", @"2", @"0", nil];
            NSArray *arr2 = [[NSArray alloc] initWithObjects:@"1", @"3", @"0", nil];
            NSArray *arr3 = [[NSArray alloc] initWithObjects:@"1", @"4", @"0", nil];
            NSArray *arr4 = [[NSArray alloc] initWithObjects:@"2", @"3", @"0", nil];
            NSArray *arr5 = [[NSArray alloc] initWithObjects:@"2", @"4", @"0", nil];
            NSArray *arr6 = [[NSArray alloc] initWithObjects:@"3", @"3", @"0", nil];
            NSArray *arr7 = [[NSArray alloc] initWithObjects:@"3", @"4", @"0", nil];
            
            if([allOpenedImages count] > 0)
                [allOpenedImages removeAllObjects];
            if([indivisualArray count] > 0)
                [indivisualArray removeAllObjects];

            
            [allOpenedImages addObject:arr1];
            [allOpenedImages addObject:arr2];
            [allOpenedImages addObject:arr3];
            [allOpenedImages addObject:arr4];
            [allOpenedImages addObject:arr5];
            [allOpenedImages addObject:arr6];
            [allOpenedImages addObject:arr7];
                        
            for(int i = 1; i <= totalImages; i++)
            {
                NSArray *indi_arr1 = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", i], @"0", nil];
                [indivisualArray addObject:indi_arr1];
            }
            
            break;
        }
            
        case 3:
        {
            totalImages = 6;
            rows = 3;
            columns = 2;
            
            UIImageView *imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview1.frame = CGRectMake(17, 56, 135, 125);
            imageview1.userInteractionEnabled = YES;
            imageview1.tag = 1;
            [self.view addSubview:imageview1];
            
            UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview2.frame = CGRectMake(163, 56, 135, 125);
            imageview2.userInteractionEnabled = YES;
            imageview2.tag = 2;
            [self.view addSubview:imageview2];
            
            UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview3.frame = CGRectMake(17, 191, 135, 125);
            imageview3.userInteractionEnabled = YES;
            imageview3.tag = 3;
            [self.view addSubview:imageview3];
            
            UIImageView *imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview4.frame = CGRectMake(163, 191, 135, 125);
            imageview4.userInteractionEnabled = YES;
            imageview4.tag = 4;
            [self.view addSubview:imageview4];
            
            UIImageView *imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview5.frame = CGRectMake(17, 326, 135, 125);
            imageview5.userInteractionEnabled = YES;
            imageview5.tag = 5;
            [self.view addSubview:imageview5];
            
            UIImageView *imageview6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview6.frame = CGRectMake(163, 326, 135, 125);
            imageview6.userInteractionEnabled = YES;
            imageview6.tag = 6;
            [self.view addSubview:imageview6];
            
            if([allOpenedImages count] > 0)
                [allOpenedImages removeAllObjects];
            if([indivisualArray count] > 0)
                [indivisualArray removeAllObjects];
            
            NSArray *arr1 = [[NSArray alloc] initWithObjects:@"1", @"2", @"0", nil];
            NSArray *arr2 = [[NSArray alloc] initWithObjects:@"1", @"3", @"0", nil];
            NSArray *arr3 = [[NSArray alloc] initWithObjects:@"1", @"4", @"0", nil];
            NSArray *arr4 = [[NSArray alloc] initWithObjects:@"1", @"5", @"0", nil];
            NSArray *arr5 = [[NSArray alloc] initWithObjects:@"1", @"6", @"0", nil];
            NSArray *arr6 = [[NSArray alloc] initWithObjects:@"2", @"3", @"0", nil];
            NSArray *arr7 = [[NSArray alloc] initWithObjects:@"2", @"4", @"0", nil];
            NSArray *arr8 = [[NSArray alloc] initWithObjects:@"2", @"5", @"0", nil];
            NSArray *arr9 = [[NSArray alloc] initWithObjects:@"2", @"6", @"0", nil];
            NSArray *arr10 = [[NSArray alloc] initWithObjects:@"3", @"3", @"0", nil];
            NSArray *arr11 = [[NSArray alloc] initWithObjects:@"3", @"4", @"0", nil];
            NSArray *arr12 = [[NSArray alloc] initWithObjects:@"3", @"5", @"0", nil];
            NSArray *arr13 = [[NSArray alloc] initWithObjects:@"3", @"6", @"0", nil];
            NSArray *arr14 = [[NSArray alloc] initWithObjects:@"4", @"5", @"0", nil];
            NSArray *arr15 = [[NSArray alloc] initWithObjects:@"4", @"6", @"0", nil];
            NSArray *arr16 = [[NSArray alloc] initWithObjects:@"5", @"6", @"0", nil];
            
            [allOpenedImages addObject:arr1];
            [allOpenedImages addObject:arr2];
            [allOpenedImages addObject:arr3];
            [allOpenedImages addObject:arr4];
            [allOpenedImages addObject:arr5];
            [allOpenedImages addObject:arr6];
            [allOpenedImages addObject:arr7];
            [allOpenedImages addObject:arr8];
            [allOpenedImages addObject:arr9];
            [allOpenedImages addObject:arr10];
            [allOpenedImages addObject:arr11];
            [allOpenedImages addObject:arr12];
            [allOpenedImages addObject:arr13];
            [allOpenedImages addObject:arr14];
            [allOpenedImages addObject:arr15];
            [allOpenedImages addObject:arr16];
                        
            for(int i = 1; i <= totalImages; i++)
            {
                NSArray *indi_arr1 = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", i], @"0", nil];
                [indivisualArray addObject:indi_arr1];
            }
            
            break;
        }
        case 4:
        {
            totalImages = 8;
            rows = 2;
            columns = 4;
            
            UIImageView *imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview1.frame = CGRectMake(30, 60, 110, 90);
            imageview1.userInteractionEnabled = YES;
            imageview1.tag = 1;
            [self.view addSubview:imageview1];
            
            UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview2.frame = CGRectMake(180, 60, 110, 90);
            imageview2.userInteractionEnabled = YES;
            imageview2.tag = 2;
            [self.view addSubview:imageview2];
            
            UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview3.frame = CGRectMake(30, 158, 110, 90);
            imageview3.userInteractionEnabled = YES;
            imageview3.tag = 3;
            [self.view addSubview:imageview3];
            
            UIImageView *imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview4.frame = CGRectMake(180, 158, 110, 90);
            imageview4.userInteractionEnabled = YES;
            imageview4.tag = 4;
            [self.view addSubview:imageview4];
            
            UIImageView *imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview5.frame = CGRectMake(30, 258, 110, 90);
            imageview5.userInteractionEnabled = YES;
            imageview5.tag = 5;
            [self.view addSubview:imageview5];
            
            UIImageView *imageview6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview6.frame = CGRectMake(180, 258, 110, 90);
            imageview6.userInteractionEnabled = YES;
            imageview6.tag = 6;
            [self.view addSubview:imageview6];
            
            UIImageView *imageview7 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview7.frame = CGRectMake(30, 354, 110, 90);
            imageview7.userInteractionEnabled = YES;
            imageview7.tag = 7;
            [self.view addSubview:imageview7];
            
            UIImageView *imageview8 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level3Rect.png"]];
            imageview8.frame = CGRectMake(180, 354, 110, 90);
            imageview8.userInteractionEnabled = YES;
            imageview8.tag = 8;
            [self.view addSubview:imageview8];
            
            if([allOpenedImages count] > 0)
                [allOpenedImages removeAllObjects];
            if([indivisualArray count] > 0)
                [indivisualArray removeAllObjects];
            
            NSArray *arr1 = [[NSArray alloc] initWithObjects:@"1", @"2", @"0", nil];
            NSArray *arr2 = [[NSArray alloc] initWithObjects:@"1", @"3", @"0", nil];
            NSArray *arr3 = [[NSArray alloc] initWithObjects:@"1", @"4", @"0", nil];
            NSArray *arr4 = [[NSArray alloc] initWithObjects:@"1", @"5", @"0", nil];
            NSArray *arr5 = [[NSArray alloc] initWithObjects:@"1", @"6", @"0", nil];
            NSArray *arr6 = [[NSArray alloc] initWithObjects:@"1", @"7", @"0", nil];
            NSArray *arr7 = [[NSArray alloc] initWithObjects:@"1", @"8", @"0", nil];
            NSArray *arr8 = [[NSArray alloc] initWithObjects:@"2", @"3", @"0", nil];
            NSArray *arr9 = [[NSArray alloc] initWithObjects:@"2", @"4", @"0", nil];
            NSArray *arr10 = [[NSArray alloc] initWithObjects:@"2", @"5", @"0", nil];
            NSArray *arr11 = [[NSArray alloc] initWithObjects:@"2", @"6", @"0", nil];
            NSArray *arr12 = [[NSArray alloc] initWithObjects:@"2", @"7", @"0", nil];
            NSArray *arr13 = [[NSArray alloc] initWithObjects:@"2", @"8", @"0", nil];
            NSArray *arr14 = [[NSArray alloc] initWithObjects:@"3", @"3", @"0", nil];
            NSArray *arr15 = [[NSArray alloc] initWithObjects:@"3", @"4", @"0", nil];
            NSArray *arr16 = [[NSArray alloc] initWithObjects:@"3", @"5", @"0", nil];
            NSArray *arr17 = [[NSArray alloc] initWithObjects:@"3", @"6", @"0", nil];
            NSArray *arr18 = [[NSArray alloc] initWithObjects:@"3", @"7", @"0", nil];
            NSArray *arr19 = [[NSArray alloc] initWithObjects:@"3", @"8", @"0", nil];
            NSArray *arr20 = [[NSArray alloc] initWithObjects:@"4", @"5", @"0", nil];
            NSArray *arr21 = [[NSArray alloc] initWithObjects:@"4", @"6", @"0", nil];
            NSArray *arr22 = [[NSArray alloc] initWithObjects:@"4", @"7", @"0", nil];
            NSArray *arr23 = [[NSArray alloc] initWithObjects:@"4", @"8", @"0", nil];
            NSArray *arr24 = [[NSArray alloc] initWithObjects:@"5", @"6", @"0", nil];
            NSArray *arr25 = [[NSArray alloc] initWithObjects:@"5", @"7", @"0", nil];
            NSArray *arr26 = [[NSArray alloc] initWithObjects:@"5", @"8", @"0", nil];
            NSArray *arr27 = [[NSArray alloc] initWithObjects:@"6", @"7", @"0", nil];
            NSArray *arr28 = [[NSArray alloc] initWithObjects:@"6", @"8", @"0", nil];
            NSArray *arr29 = [[NSArray alloc] initWithObjects:@"7", @"8", @"0", nil];
            
            [allOpenedImages addObject:arr1];
            [allOpenedImages addObject:arr2];
            [allOpenedImages addObject:arr3];
            [allOpenedImages addObject:arr4];
            [allOpenedImages addObject:arr5];
            [allOpenedImages addObject:arr6];
            [allOpenedImages addObject:arr7];
            [allOpenedImages addObject:arr8];
            [allOpenedImages addObject:arr9];
            [allOpenedImages addObject:arr10];
            [allOpenedImages addObject:arr11];
            [allOpenedImages addObject:arr12];
            [allOpenedImages addObject:arr13];
            [allOpenedImages addObject:arr14];
            [allOpenedImages addObject:arr15];
            [allOpenedImages addObject:arr16];
            [allOpenedImages addObject:arr17];
            [allOpenedImages addObject:arr18];
            [allOpenedImages addObject:arr19];
            [allOpenedImages addObject:arr20];
            [allOpenedImages addObject:arr21];
            [allOpenedImages addObject:arr22];
            [allOpenedImages addObject:arr23];
            [allOpenedImages addObject:arr24];
            [allOpenedImages addObject:arr25];
            [allOpenedImages addObject:arr26];
            [allOpenedImages addObject:arr27];
            [allOpenedImages addObject:arr28];
            [allOpenedImages addObject:arr29];
            
            indivisualArray = [[NSMutableArray alloc] init];
            
            for(int i = 1; i <= totalImages; i++)
            {
                NSArray *indi_arr1 = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", i], @"0", nil];
                [indivisualArray addObject:indi_arr1];
            }
            
            break;
        }
            
    }
    
    numRemainingImages = totalImages;
}


-(NSMutableArray *) makeRandomNumberArr : (int) totalImages
{
    NSMutableArray *randoms = [[NSMutableArray alloc] init];
    while ([randoms count] != totalImages) 
    {
        int random  = arc4random()%(totalImages);
        
        //        if(random == 0)
        //            continue;
        //        else 
        {
            BOOL present = FALSE;
            for(int j = 0; j < [randoms count]; j++)
            {
                if([[randoms objectAtIndex:j] intValue] == random)
                {
                    present = TRUE;
                    break;
                }
            }
            if(present == FALSE)
            {
                [randoms addObject:[NSString stringWithFormat:@"%d",random]];
            }
        }
    }
    NSLog(@"%@", randoms);
    
    return randoms;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event allTouches] anyObject];
    UIView *view = [touch view];
    
    
    if([view isKindOfClass:[UIImageView class]] == TRUE)
    {
        if(selectedLevel == 1)
        {
            UIImageView *imageView = (UIImageView *) view;
            switch (imageView.tag) 
            {
                case 1:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 1;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2)
                        secondOpenedImage = 1;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:0] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];
                    break;
                }
                case 2:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 2;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2)
                        secondOpenedImage = 2;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:0] intValue]];
                    
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }
            }
        }
        if(selectedLevel == 2)
        {
            UIImageView *imageView = (UIImageView *) view;
            switch (imageView.tag) 
            {
                case 1:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 1;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4)
                        secondOpenedImage = 1;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:0] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }
                case 2:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 2;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4)
                        secondOpenedImage = 2;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:1] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }
                case 3:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 3;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4)
                        secondOpenedImage = 3;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:0] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }
                case 4:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 4;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4)
                        secondOpenedImage = 4;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:1] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }            
            }
        }
        if(selectedLevel == 3)
        {
            UIImageView *imageView = (UIImageView *) view;
            switch (imageView.tag) 
            {
                case 1:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 1;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6)
                        secondOpenedImage = 1;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:0] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }
                case 2:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 2;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6)
                        secondOpenedImage = 2;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:1] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }
                case 3:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 3;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6)
                        secondOpenedImage = 3;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:2] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }
                case 4:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 4;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6)
                        secondOpenedImage = 4;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:0] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }  
                case 5:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 5;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6)
                        secondOpenedImage = 5;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:1] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }   
                case 6:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 6;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6)
                        secondOpenedImage = 6;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:2] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }   
            }
        }
        if(selectedLevel == 4)
        {
            UIImageView *imageView = (UIImageView *) view;
            switch (imageView.tag) 
            {
                case 1:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 1;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6 || firstOpenedImage == 7 || firstOpenedImage == 8)
                        secondOpenedImage = 1;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:0] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }
                case 2:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 2;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6 || firstOpenedImage == 7 || firstOpenedImage == 8)
                        secondOpenedImage = 2;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:1] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }
                case 3:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 3;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6 || firstOpenedImage == 7 || firstOpenedImage == 8)
                        secondOpenedImage = 3;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:2] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }
                case 4:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 4;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6 || firstOpenedImage == 7 || firstOpenedImage == 8)
                        secondOpenedImage = 4;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:3] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }  
                case 5:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 5;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6 || firstOpenedImage == 7 || firstOpenedImage == 8)
                        secondOpenedImage = 5;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:0] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }   
                case 6:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 5;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6 || firstOpenedImage == 7 || firstOpenedImage == 8)
                        secondOpenedImage = 5;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:1] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                } 
                case 7:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 7;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6 || firstOpenedImage == 7 || firstOpenedImage == 8)
                        secondOpenedImage = 7;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:2] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                }   
                case 8:
                {
                    if(firstOpenedImage == 0)
                        firstOpenedImage = 8;
                    else if(firstOpenedImage == 1  || firstOpenedImage == 2 || firstOpenedImage == 3 || firstOpenedImage == 4 || firstOpenedImage == 5 || firstOpenedImage == 6 || firstOpenedImage == 7 || firstOpenedImage == 8)
                        secondOpenedImage = 8;
                    
                    [imagesToRemove addObject:imageView];
                    
                    imageView.image = [animalArray objectAtIndex:[[numbersArr objectAtIndex:3] intValue]];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                           forView:imageView 
                                             cache:YES];
                    [UIView commitAnimations];

                    break;
                } 
            }
        }
        if(firstOpenedImage != 0 && secondOpenedImage != 0)
        {
            if([imagesToRemove count] == 2)
            {
                UIImageView *img1 = [imagesToRemove objectAtIndex:0];
                UIImageView *img2 = [imagesToRemove objectAtIndex:1];
                
                if(img1.image == img2.image)
                {
                    score += 10;
                    scoreLabel.text = [NSString stringWithFormat:@" %d", score];
                    
                    firstOpenedImage = 0;
                    secondOpenedImage = 0;
                    
                    [self performSelector:@selector(removeImages) withObject:nil afterDelay:1.0];
                }
                else
                {
                    for(int m = 0; m < [allOpenedImages count]; m++)
                    {
                        NSArray *arr = [allOpenedImages objectAtIndex:m];
                        for(int n = 0; n < [arr count]; n++)
                        {
                            int a = [[arr objectAtIndex:0] intValue];
                            int b = [[arr objectAtIndex:1] intValue];
                            
                            if((a == firstOpenedImage && b == secondOpenedImage) || (b == firstOpenedImage && a == secondOpenedImage))
                            {
                                int count = [[arr objectAtIndex:2] intValue];
                                if(count == 0)
                                {
                                    NSArray *new_arr = [[NSArray alloc] initWithObjects:[arr objectAtIndex:0], [arr objectAtIndex:1], [NSString stringWithFormat:@"%d", count+1], nil];
                                    [allOpenedImages replaceObjectAtIndex:m withObject:new_arr];
                                    
                                    firstOpenedImage = 0;
                                    secondOpenedImage = 0;
                                    
                                    break;
                                }
                                else if(count > 0)
                                {
                                    score -= 2;
                                    scoreLabel.text = [NSString stringWithFormat:@" %d", score];
                                    
                                    firstOpenedImage = 0;
                                    secondOpenedImage = 0;
                                    
                                    break;
                                }
                            }
                            
                        }
                    }
                    
                    [self performSelector:@selector(resetImages) withObject:nil afterDelay:1.0];
                }
            }
        }
        
    }
    
}

-(void) removeImages
{
    firstOpenedImage = 0;
    secondOpenedImage = 0;
    
    UIImageView *img1 = [imagesToRemove objectAtIndex:0];
    UIImageView *img2 = [imagesToRemove objectAtIndex:1];
    [img1 removeFromSuperview];
    [img2 removeFromSuperview];
    
    [imagesToRemove removeAllObjects];
    
    numRemainingImages -= 2;
    
    if(numRemainingImages == 0)
    {
        if(selectedLevel != 6)
        {
            NSString *title = [NSString stringWithFormat:@"Level %d Completed", selectedLevel];
            
            UIAlertView *winAlert = [[UIAlertView alloc] initWithTitle:title message:scoreLabel.text delegate:self cancelButtonTitle:nil otherButtonTitles:@"Menu", @"Retry", nil, nil];
            [winAlert show];
            winAlert.tag = 1;
            [winAlert release];
        }
        else if(selectedLevel == 6)
        {
            UIAlertView *winAlert = [[UIAlertView alloc] initWithTitle:@"Winner" message:@"Congratulations.. All Levels Completed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Menu", @"Retry", nil];
            [winAlert show];
            winAlert.tag = 2;
            [winAlert release];
        }
    }
    
}

-(void) alertView:(UIAlertView *)AlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(AlertView.tag == 1)
    {
        NSLog(@"%d", buttonIndex);
        if(buttonIndex == 0)
        {
            mainDelegate.totalScore = mainDelegate.totalScore + score;
            
            //[self.navigationController popViewControllerAnimated:YES];
            
            [self dismissModalViewControllerAnimated:YES];
            
        }
        else if(buttonIndex == 1)
        {
            [self setInitialValues:selectedLevel];
        }
        else if(buttonIndex == 2)
        {
            if(selectedLevel < 4)
            {
                [self setInitialValues:selectedLevel+1];
            }
        }
    }
    else if(AlertView.tag == 2)
    {
        NSLog(@"%d", buttonIndex);
        if(buttonIndex == 0)
        {
            //[self.navigationController popViewControllerAnimated:YES];
            
            [self dismissModalViewControllerAnimated:YES];
        }
        else if(buttonIndex == 1)
        {
            [self setInitialValues:selectedLevel];
        }
     }
    
}

-(void) resetImages
{
    firstOpenedImage = 0;
    secondOpenedImage = 0;
    
    UIImageView *img1 = [imagesToRemove objectAtIndex:0];
    UIImageView *img2 = [imagesToRemove objectAtIndex:1];
    img1.image = [UIImage imageNamed:@"level3Rect.png"];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                           forView:img1 
                             cache:YES];
    [UIView commitAnimations];

    img2.image = [UIImage imageNamed:@"level3Rect.png"];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                           forView:img2 
                             cache:YES];
    [UIView commitAnimations];

    
    [imagesToRemove removeAllObjects];
}

//-(IBAction)quitAction:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    
    if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else 
        return NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
/*
 
 int cnt = 0;
 UIImageView *imageview1;
 
 CGRect frame = self.view.frame;
 frame.origin.x = 0;
 
 int xx = 15+frame.origin.x, yy = 15; 
 int pageNum = 0;
 
 int columnCount = 0;
 int rowCount = 0;
 
 for(int i = 1; i <= totalImages; i++)
 {
 imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DarkImage_Big.png"]];
 imageview1.frame = CGRectMake(xx, yy, 135, 140);
 imageview1.userInteractionEnabled = YES;
 imageview1.tag = i;
 [self.view addSubview:imageview1];
 
 cnt += 1; // for array count
 
 columnCount += 1;
 
 if(columnCount == columns)
 {
 xx = 15+(frame.origin.x*pageNum);
 yy = yy + 100;
 rowCount += 1;
 columnCount = 0;
 }
 else
 {
 xx = xx + 100;
 }
 
 if(rowCount == rows)
 {
 pageNum+=1;
 xx = 15+(320*pageNum);
 yy = 50;
 frame.origin.x = frame.size.width;
 rowCount = 0;
 }
 }
 
 */


@end
