//
//  MainTableViewController.m
//  CoreDataTest
//
//  Created by Ge-Yunsheng on 2014/10/27.
//  Copyright (c) 2014年 geys. All rights reserved.
//

#import "MainTableViewController.h"
#import "AddViewController.h"
#import "Person.h"

@interface MainTableViewController ()
//声明通过CoreData读取数据要用到的变量
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//用来存储查询并适合TableView来显示的数据
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.title = @"通讯录";
    self.tableView = [[[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(setEdit)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [leftButtonItem release];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(moveToAdd)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //通过application对象的代理对象获取上下文
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    
    /*********
     通过CoreData获取sqlite中的数据
     *********/
    
    //通过实体名获取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Person class])];
    
    //定义分组和排序规则
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstN" ascending:YES];
    
    //把排序和分组规则添加到请求中
    [request setSortDescriptors:@[sortDescriptor]];
    
    //把请求的结果转换成适合tableView显示的数据
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"firstN" cacheName:nil];
    
    //执行fetchedResultsController
    NSError *error;
    if ([self.fetchedResultsController performFetch:&error]) {
    }
    
    self.fetchedResultsController.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
//   // self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshValue:) forControlEvents:UIControlEventValueChanged];
    
}
//
-(void)refreshValue:(id)sender
{
    if (self.refreshControl.refreshing)
    {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中"];
    }
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:2];
}

-(void)refreshData
{
    [self.refreshControl endRefreshing];
////    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.tableView reloadData];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Refreshed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //我们的数据中有多少个section, fetchedResultsController中的sections方法可以以数组的形式返回所有的section
    //sections数组中存的是每个section的数据信息
    NSArray *sections = [self.fetchedResultsController sections];
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];
    
    //返回每个section中的元素个数
    return [sectionInfo numberOfObjects];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   // return 80;
//}

//通过获取section中的信息来获取header和每个secion中有多少数据

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController  sections];
    //获取对应section的sectionInfo
    id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];
    
    //返回header
    return [sectionInfo name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strIndentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIndentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strIndentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    //获取实体对象
    Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = person.number;
    
    if (person.imageData != nil) {
        UIImage *image = [UIImage imageWithData:person.imageData];
        cell.imageView.image = image;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddViewController *addView = [[[AddViewController alloc]init]autorelease];
    Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [addView setValue:person forKey:@"person"];
    [self.navigationController pushViewController:addView animated:YES];
}

-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}

//开启编辑
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //通过coreData删除对象
        //通过indexPath获取我们要删除的实体
        Person * person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        //通过上下文移除实体
        [self.managedObjectContext  deleteObject:person];
        
        //保存
        NSError *error;
        [self.managedObjectContext save:&error];
       
    }
}

//设置删除的名字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*
 Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
 subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
 with information from a managed object at the given index path in the fetched results controller.
 */

//当CoreData的数据正在发生改变是，FRC产生的回调
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

//分区改变状况
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

//数据改变状况
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            //让tableView在newIndexPath位置插入一个cell
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //让tableView刷新indexPath位置上的cell
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

//当CoreData的数据完成改变是，FRC产生的回调
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

//给我们的通讯录加上索引，下面的方法返回的时一个数组
-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //通过fetchedResultsController来获取section数组
    NSArray *sectionArray = [self.fetchedResultsController sections];
    
    //新建可变数组来返回索引数组，大小为sectionArray中元素的多少
    NSMutableArray *index = [NSMutableArray arrayWithCapacity:sectionArray.count];
    
    //通过循环获取每个section的header,存入addObject中
    for (int i = 0; i < sectionArray.count; i ++)
    {
        id <NSFetchedResultsSectionInfo> info = sectionArray[i];
        [index addObject:[info name]];
    }
    
    //返回索引数组
    return index;
}

- (void)setEdit
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

-(void)moveToAdd
{
    AddViewController *addViewController = [[[AddViewController alloc]init]autorelease];
    [self.navigationController pushViewController:addViewController animated:YES];
}
@end
