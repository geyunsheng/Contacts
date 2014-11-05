//
//  AddViewController.m
//  CoreDataTest
//
//  Created by Ge-Yunsheng on 2014/10/27.
//  Copyright (c) 2014年 geys. All rights reserved.
//

#import "AddViewController.h"
#import "MainTableViewController.h"
#import "pinyin.h"


@interface AddViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation AddViewController
BOOL saveFlag = YES;

-(void)loadView
{
    self.title = @"编辑";
    self.view = [[[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame ]autorelease];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(50.0f, 100.0f, 50.0f, 30.0f)];
    labelName.text = @"姓名:";
    labelName.font = [UIFont systemFontOfSize:17.0f];
    labelName.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelName];
    [labelName release];
    
    UILabel *labelNumber = [[UILabel alloc]initWithFrame:CGRectMake(50.0f, 150.0f, 50.0f, 30.0f)];
    labelNumber.text = @"号码:";
    labelNumber.font = [UIFont systemFontOfSize:17.0f];
    labelNumber.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelNumber];
    [labelNumber release];
    
    UITextField *textName = [[UITextField alloc]initWithFrame:CGRectMake(100.0f, 100.0f, 170.0f, 30.0f)];
    textName.placeholder = @"请输入姓名";
    [textName setBorderStyle:UITextBorderStyleRoundedRect];
    [textName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    textName.font = [UIFont systemFontOfSize:17.0f];
    textName.backgroundColor = [UIColor clearColor];
    textName.textColor = [UIColor blackColor];
    textName.delegate = self;
    textName.text = self.person.name;
    self.nameTextField = textName;
    [self.view addSubview:textName];
    [textName release];
    
    UITextField *textNumber = [[UITextField alloc]initWithFrame:CGRectMake(100.0f, 150.0f, 170.0f, 30.0f)];
    textNumber.placeholder = @"请输入电话号码";
    [textNumber setBorderStyle:UITextBorderStyleRoundedRect];
    [textNumber setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    textNumber.font = [UIFont systemFontOfSize:17.0f];
    textNumber.backgroundColor = [UIColor clearColor];
    textNumber.textColor = [UIColor blackColor];
    textNumber.delegate = self;
    textNumber.text = self.person.number;
    self.numberTextField = textNumber;
    [self.view addSubview:textNumber];
    [textNumber release];
    
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(110.0f, 220.0f, 100.0f, 100.0f)];
    [imageButton setImage:[UIImage imageNamed:@"person.png"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    self.personButton = imageButton;
    [self.view addSubview:imageButton];
    [imageButton release];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake(100.0f, 380.0f, 120.0f, 50.0f);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //通过application对象的代理对象获取上下文
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    
    if (self.person.imageData != nil)
    {
        UIImage *image = [UIImage imageWithData:self.person.imageData];
        [self.personButton setImage:image forState:UIControlStateNormal];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    
    int offset = (frame.origin.y + frame.size.height) - (self.view.frame.size.height - 216.0) + 10;//键盘高度216,空余高度10
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if(offset > 0)
    {
        self.view.frame = CGRectMake(0.0f, 64 - offset, self.view.frame.size.width, self.view.frame.size.height);//64是导航栏和状态栏高度
    }
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)save
{
    //如果person为空则新建，如果已经存在则更新
    if (self.person == nil)
    {
        self.person = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Person class]) inManagedObjectContext:self.managedObjectContext];
    }

    if ((self.nameTextField.text.length == 0)||(self.numberTextField.text.length == 0))
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"姓名和号码不能为空！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    //赋值
    self.person.name = self.nameTextField.text;
    self.person.number = self.numberTextField.text;
    self.person.firstN = [NSString stringWithFormat:@"%c",pinyinFirstLetter([self.person.name characterAtIndex:0])-32];

    //把button上的图片存入对象
    UIImage *buttonImage = [self.personButton imageView].image;
    self.person.imageData = UIImagePNGRepresentation(buttonImage);
    
    //保存
    NSError *error;
    [self.managedObjectContext save:&error];
  
    //保存成功后POP到表视图
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addImage
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"请选择照片来源" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Image Gallary", nil ];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];
    [sheet release];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            UIImagePickerController *picker = [[[UIImagePickerController alloc] init]autorelease];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            saveFlag = YES;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        }
        case 1:
        {
            UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = YES;
            saveFlag = NO;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = info[UIImagePickerControllerEditedImage];

    [self.personButton setImage:image forState:UIControlStateNormal];

    if (YES == saveFlag)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了!" message:@"存不了T_T" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else {
        NSLog(@"保存成功");
    }
}

- (void)dealloc {
    [super dealloc];
}
@end
