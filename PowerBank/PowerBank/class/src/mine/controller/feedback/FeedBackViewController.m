//
//  FeedBackViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/13.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "FeedBackViewController.h"
#import <TZImagePickerController.h>
#import "WMTextView.h"
#import "WMFeekBackCollectionViewCell.h"

static NSString * WMFeekBackCellID = @"WMFeekBackCell";

@interface FeedBackViewController ()
<UITextViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
TZImagePickerControllerDelegate,
WMFeekBackCollectionViewCellDelegate>
/** 自定义输入框 */
@property (weak, nonatomic) WMTextView *customTextView;
/** 照片显示view */
@property (weak, nonatomic) UICollectionView *mainCollectionView;
/** 数据源 */
@property (strong, nonatomic) NSMutableArray *imageArray;
/** 添加图片 */
@property (strong, nonatomic) UIImage *addImage;
/** 上传照片返回的名字数组 */
@property (strong, nonatomic) NSMutableArray * imageNameArray;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -initUI
- (void)initUI
{
    self.title = @"意见反馈";
    (void)self.customTextView;
    self.view.backgroundColor = ThemeColor;
    _addImage = [UIImage imageNamed:@"addImage"];
    [self.imageArray addObject:_addImage];
    (void)self.mainCollectionView;
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setTitle:@"提交" forState:UIControlStateNormal];
    [messageButton setTitleColor:ThemeBarTextColor forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    messageButton.frame = CGRectMake(0, 0, 40, 20);
    UIBarButtonItem *messageNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    messageNagetiveSpacer.width = -10;
    UIBarButtonItem *messageBarItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    self.navigationItem.rightBarButtonItems = @[ messageNagetiveSpacer, messageBarItem];
}

#pragma mark -methods
-(void)commit
{
    NSLog(@"提交反馈");
    [WMRequestHelper uploadContent:_customTextView.text images:self.imageNameArray withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                [PromptView autoHideWithText:@"反馈成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMFeekBackCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:WMFeekBackCellID forIndexPath:indexPath];
    cell.feekbackImage.image = self.imageArray[indexPath.row];
    cell.delegate = self;
    cell.index = indexPath.row;
    if (cell.feekbackImage.image == _addImage) {
        cell.deleteButton.hidden = true;
    } else {
        cell.deleteButton.hidden = false;
    }
    return cell;
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", indexPath);
    // 通过数据源的个数来确定还能添加几张
    if (indexPath.row == self.imageArray.count - 1) {
        NSInteger count = 10 - self.imageArray.count;
        if (count <= 0) {
            [PromptView autoHideWithText:@"添加照片数量已经到达上限"];
            return;
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
        // 你可以通过block或者代理，来得到用户选择的照片.
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 85);
}

#pragma mark -TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [self.imageArray removeLastObject];
    
    for (int i = 0; i < photos.count; i++) {
        [self.imageArray addObject:photos[i]];
    }
    
    [self.imageArray addObject:_addImage];
    
    NSMutableArray * dataArray = self.imageArray;
    
    if (dataArray.count > 1) {
        for (int i = 0; i < dataArray.count - 1; i++) {
            [WMRequestHelper uploadFeedBackImage:self.imageArray[i] withCompletionHandle:^(BOOL success, id dataDic) {
                if (success) {
                    if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                        NSString * imageName = [dataDic objectForKey:@"data"];
                        NSLog(@"%@", imageName);
                        [self.imageNameArray addObject:imageName];
                    }
                }
            }];
        }
    }
    
    [_mainCollectionView reloadData];
}

#pragma mark -WMFeekBackCollectionViewCellDelegate
- (void)deleteImageWithCell:(WMFeekBackCollectionViewCell *)cell
{
    [self.imageArray removeObjectAtIndex:cell.index];
    [_mainCollectionView reloadData];
}

#pragma mark -lazy
- (WMTextView *)customTextView
{
    if (!_customTextView) {
        WMTextView *customTextView = [[WMTextView alloc] init];
        customTextView = [[WMTextView alloc] init];
        customTextView.frame = CGRectMake(0, 84, SCREEN_WIDTH, 200);
        customTextView.delegate = self;
        customTextView.placehoder = @"请输入遇到的问题或建议";
        customTextView.placehoderColor = [UIColor colorWithHexString:@"#414141"];
        [self.view addSubview:customTextView];
        _customTextView = customTextView;
    }
    return _customTextView;
}

- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView * mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, SCREEN_HEIGHT - 300) collectionViewLayout:flowLayout];
        mainCollectionView.delegate = self;
        mainCollectionView.dataSource = self;
        [mainCollectionView registerNib:[UINib nibWithNibName:@"WMFeekBackCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WMFeekBackCellID];
        mainCollectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:mainCollectionView];
        _mainCollectionView = mainCollectionView;
    }
    return _mainCollectionView;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)imageNameArray
{
    if (!_imageNameArray) {
        _imageNameArray = [NSMutableArray array];
    }
    return _imageNameArray;
}


@end
