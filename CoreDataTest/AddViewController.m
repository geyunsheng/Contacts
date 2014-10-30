//
//  AddViewController.m
//  CoreDataTest
//
//  Created by Ge-Yunsheng on 2014/10/27.
//  Copyright (c) 2014年 geys. All rights reserved.
//

#import "AddViewController.h"
#import "pinyin.h"
#import "MainTableViewController.h"


@interface AddViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (strong, nonatomic) UIImagePickerController *picker;
@property (retain, nonatomic) IBOutlet UIButton *imageButton;

- (IBAction)addImage:(id)sender;
- (IBAction)tapAdd:(id)sender;
@end

@implementation AddViewController


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
    self.nameTextField.delegate = self;
    self.numberTextField.delegate = self;
    // Do any additional setup after loading the view.
    //通过application对象的代理对象获取上下文
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    self.nameTextField.text = self.person.name;
    self.numberTextField.text = self.person.number;
    
    if (self.person.imageData != nil)
    {
        UIImage *image = [UIImage imageWithData:self.person.imageData];
        [self.imageButton setImage:image forState:UIControlStateNormal];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    
    int offset = (frame.origin.y + frame.size.height) - (self.view.frame.size.height - 216.0) + 10;//键盘高度216,空余高度10
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if(offset > 0)
    {
        self.view.frame = CGRectMake(0.0f, - offset, self.view.frame.size.width, self.view.frame.size.height);//64是导航栏和状态栏高度
    }
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)tapAdd:(id)sender
{
    //如果person为空则新建，如果已经存在则更新
    if (self.person == nil)
    {
        self.person = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Person class]) inManagedObjectContext:self.managedObjectContext];
    }
    //赋值
    if ((self.nameTextField.text.length == 0)||(self.numberTextField.text.length == 0))
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"姓名和号码不能为空！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    self.person.name = self.nameTextField.text;
    self.person.number = self.numberTextField.text;
    self.person.firstN = [NSString stringWithFormat:@"%c",pinyinFirstLetter([self.person.name characterAtIndex:0])-32];
    
    //把button上的图片存入对象
    UIImage *buttonImage = [self.imageButton imageView].image;
    self.person.imageData = UIImagePNGRepresentation(buttonImage);
    
    //保存
    NSError *error;
    [self.managedObjectContext save:&error];
//    if (![self.managedObjectContext save:&error]) {
//        NSLog(@"%@", [error localizedDescription]);
//    }
    
    //保存成功后POP到表视图
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)addImage:(id)sender
{
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init]autorelease];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//实现图片回调方法，从相册获取图片
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //获取到编辑好的图片
    UIImage * image = info[UIImagePickerControllerEditedImage];
    
    //把获取的图片设置成用户的头像
    [self.imageButton setImage:image forState:UIControlStateNormal];
    
    //返回到原来View
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}
- (void)dealloc {
    [_imageButton release];
    [super dealloc];
}
@end
