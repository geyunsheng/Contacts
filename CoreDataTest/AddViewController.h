//
//  AddViewController.h
//  CoreDataTest
//
//  Created by Ge-Yunsheng on 2014/10/27.
//  Copyright (c) 2014年 geys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface AddViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    Person *_person;
    UITextField *_nameTextField;
    UITextField *_numberTextField;
    UIButton *_personButton;
}

@property (strong,nonatomic)Person *person;
@property (retain,nonatomic) UITextField *nameTextField;
@property (retain,nonatomic) UITextField *numberTextField;
@property (retain,nonatomic) UIButton *personButton;


@end
