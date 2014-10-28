//
//  AddViewController.h
//  CoreDataTest
//
//  Created by Ge-Yunsheng on 2014/10/27.
//  Copyright (c) 2014年 geys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface AddViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    Person *_person;
}

@property (strong,nonatomic)Person *person;
@end
