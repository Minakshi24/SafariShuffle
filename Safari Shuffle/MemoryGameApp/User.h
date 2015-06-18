//
//  User.h
//  Safari Shuffle
//
//  Created by Ankita Chordia on 12/7/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    
    NSString *name, *score, *level;

}

@property (nonatomic, retain)  NSString *name, *score, *level;

@end
