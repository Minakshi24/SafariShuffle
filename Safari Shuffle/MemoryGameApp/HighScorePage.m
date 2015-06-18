//
//  HighScorePage.m
//  Safari Shuffle
//
//  Created by Ankita Chordia on 12/7/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import "HighScorePage.h"
#import "User.h"

@implementation HighScorePage

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    w = mainDelegate.window.frame.size.width;
    h = mainDelegate.window.frame.size.height;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"highScoreBack.png"]];
    backgroundImageView.frame = CGRectMake(0, 0, 320*w/320, 480*h/480);
    [self.view addSubview:backgroundImageView];
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(19*w/320, 14*h/480, 95*w/320, 49*h/480);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"backBtn_iPad.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"backBtnPressed_iPad.png"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [self getDataFromDb];
    
    //Music
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/buttonClick.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error1;
    buttonClickMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error1];
    [buttonClickMusic prepareToPlay];
    
    easyTableView = [[UITableView alloc] initWithFrame:CGRectMake(38*w/320, 174.5*h/480, 120.5*w/320, 162*h/480) style:UITableViewStylePlain];
    easyTableView.delegate = self;
    easyTableView.dataSource = self;
    easyTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:easyTableView];
    
    hardTableView = [[UITableView alloc] initWithFrame:CGRectMake((38 + 121)*w/320, 174.5*h/480, 120.5*w/320, 162*h/480) style:UITableViewStylePlain];
    hardTableView.delegate = self;
    hardTableView.dataSource = self;
    hardTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:hardTableView];
    
}

-(void) getDataFromDb
{
    
        
    easyUserArray = [[NSMutableArray alloc] init];
    
    hardUserArray = [[NSMutableArray alloc] init];
    
    [self initDatabase];
    
    sqlite3_stmt *imageSelectStmt;
    if(sqlite3_open(dbpath, &memoryappDB) == SQLITE_OK){
        
        NSString *selectQuery = @"select Name, Score, Level from UserTable";
        
        NSLog(@"%@", selectQuery);
        //int i;
        const char *query_stmt1 = [selectQuery UTF8String];
        
        selectQuery = nil;
        
        if (sqlite3_prepare_v2(memoryappDB, query_stmt1, -1, &imageSelectStmt, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(imageSelectStmt) == SQLITE_ROW)
            {
                
                NSString *name = [[ NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(imageSelectStmt,0)];
                NSString *score = [[ NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(imageSelectStmt,1)];
                NSString *level = [[ NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(imageSelectStmt,2)];
                
                User *tempObj = [[User alloc] init];
                tempObj.name = name;
                tempObj.score = score;
                tempObj.level = level;
                
                NSLog(@"%@", name);
                if([level isEqualToString:@"Easy"])
                {
                    [easyUserArray addObject:tempObj];
                }
                else if([level isEqualToString:@"Hard"])
                {
                    [hardUserArray addObject:tempObj];
                }
                
                if(tempObj != nil)
                {
                    [tempObj release];
                    tempObj = nil;
                }
                
            }
            sqlite3_finalize(imageSelectStmt);
        }
        sqlite3_close(memoryappDB);
    }
    else 
    {
        NSLog(@"Error : %s", sqlite3_errmsg(memoryappDB));
        sqlite3_close(memoryappDB);
    }	

}

-(IBAction)goBack:(id)sender
{
    UIButton *tappedBtn = (UIButton *)sender;
    
    [buttonClickMusic play];
    
    tappedBtn.selected = TRUE;
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Local database function

- (void) initDatabase
{	
	BOOL success; 
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    NSError *error; 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"MemoryAppDb.sqlite"]; 
    success = [fileManager fileExistsAtPath:writableDBPath];
	dbpath = [writableDBPath UTF8String];
	
	NSLog(@"path : %@", writableDBPath); 
    if (success) return;
	
	// The writable database does not exist, so copy the default to the appropriate location. 
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MemoryAppDb.sqlite"];
	
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error]; 
	if (!success)  
	{ 
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]); 
	} 
	
	dbpath = [writableDBPath UTF8String];
	NSLog(@"path : %@", writableDBPath); 
}


#pragma mark - 
#pragma mark UITableView delagate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CGFloat ht;
    
    ht = 35*w/320;
    
    return ht;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int cnt;
    
    if(tableView == easyTableView)
    {
        if([easyUserArray count] > 5)
        {
            cnt = [easyUserArray count];
            easyTableView.contentSize = CGSizeMake(120.5*w/320, (35*cnt)*h/480);
        }
        else
        {
            cnt = 5;
        }
    }
    
    if(tableView == hardTableView)
    {
        if([hardUserArray count] > 5)
        {
            cnt = [hardUserArray count];
            hardTableView.contentSize = CGSizeMake(120.5*w/320, (35*cnt)*h/480);
        }
        else
        {
            cnt = 5;
        }
    }
        
    return cnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier] ;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *subviewsArray = [cell.contentView subviews];
    
    for(int i = 0; i < [subviewsArray count]; i++)
    {
        if([[subviewsArray objectAtIndex:i] isKindOfClass:[UILabel class]])
        {
            [[subviewsArray objectAtIndex:i] removeFromSuperview];
        }
    }
    
    UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 121*w/320, 35*h/480)];
    av.backgroundColor = [UIColor clearColor];
    av.opaque = NO;
    av.image = [UIImage imageNamed:@"cellBack.png"];
    cell.backgroundView = av;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(5*w/320, 5*h/480, 60*w/320, 25*h/480);
    nameLabel.backgroundColor = [UIColor clearColor];
    if(w > 640)
    {
        nameLabel.font = [UIFont fontWithName:@"GoodDog Cool" size:36];
    }
    else
    {
    nameLabel.font = [UIFont fontWithName:@"GoodDog Cool" size:22];
    }
    nameLabel.textAlignment = UITextAlignmentCenter;
    if(tableView == easyTableView)
    {
        nameLabel.textColor = [UIColor colorWithRed:34.0/255.0 green:185.0/255.0 blue:227.0/255.0 alpha:1.0];
    }
    else if(tableView == hardTableView)
    {
        nameLabel.textColor = [UIColor colorWithRed:167.0/255.0 green:56.0/255.0 blue:144.0/255.0 alpha:1.0];
    }
    if(tableView == easyTableView)
    {
        
        if(indexPath.row < [easyUserArray count])
        {
            User *temp = (User *)[easyUserArray objectAtIndex:indexPath.row];
            nameLabel.text = temp.name;
        }
        else
        {
            nameLabel.text = @"-";
        }
    }
    
    if(tableView == hardTableView)
    {
        
        if(indexPath.row < [hardUserArray count])
        {
            User *temp = (User *)[hardUserArray objectAtIndex:indexPath.row];
            nameLabel.text = temp.name;
        }
        else
        {
            nameLabel.text = @"-";
        }
    }
    [cell.contentView addSubview:nameLabel];
    [nameLabel release];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.frame = CGRectMake(61*w/320, 5*h/480, 60*w/320, 25*h/480);
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.textAlignment = UITextAlignmentCenter;
    if(w > 640)
    {
        scoreLabel.font = [UIFont fontWithName:@"GoodDog Cool" size:36];
    }
    else
    {
    scoreLabel.font = [UIFont fontWithName:@"GoodDog Cool" size:22];
    }
    if(tableView == easyTableView)
    {
        scoreLabel.textColor = [UIColor colorWithRed:34.0/255.0 green:185.0/255.0 blue:227.0/255.0 alpha:1.0];
    }
    else if(tableView == hardTableView)
    {
        scoreLabel.textColor = [UIColor colorWithRed:167.0/255.0 green:56.0/255.0 blue:144.0/255.0 alpha:1.0];
    }
    if(tableView == easyTableView)
    {
        
        if(indexPath.row < [easyUserArray count])
        {
            User *temp = (User *)[easyUserArray objectAtIndex:indexPath.row];
            scoreLabel.text = temp.score;
        }
        else
        {
            scoreLabel.text = @"-";
        }
    }
    if(tableView == hardTableView)
    {
        
        if(indexPath.row < [hardUserArray count])
        {
            User *temp = (User *)[hardUserArray objectAtIndex:indexPath.row];
            scoreLabel.text = temp.score;
        }
        else
        {
            scoreLabel.text = @"-";
        }
    }
    [cell.contentView addSubview:scoreLabel];
    [scoreLabel release];
    
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
