//
//  Person.h
//  CoreDataTest
//
//  Created by Ge-Yunsheng on 2014/10/28.
//  Copyright (c) 2014年 geys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * firstN;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSData * imageData;

@end
