//
//  ViewController.m
//  DocumentDemo
//
//  Created by flagadmin on 2019/6/18.
//  Copyright © 2019 flagadmin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIDocumentPickerDelegate,
UIDocumentInteractionControllerDelegate>
/**文件目录*/
@property(nonatomic, strong) UIDocumentPickerViewController *documentPickerVC;
/**文件预览*/
@property (nonatomic, strong) UIDocumentInteractionController* documentInteractionVC;
@end

@implementation ViewController{
    BOOL _isDocumentAppear;//用来解决UIDocumentInteractionController内存泄漏问题

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _isDocumentAppear = YES;
    if (self.documentInteractionVC) {
        self.documentInteractionVC.delegate = self;
    }
     //预览文件的控制器消失的时候恢复默认设置颜色
    [UINavigationBar appearance].tintColor = [UIColor blueColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
}
- (void)fileLocalClick{
    //更改导航栏字体颜色
    [UINavigationBar appearance].tintColor = [UIColor blueColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    [self presentViewController:self.documentPickerVC animated:YES completion:^{
        
    }];
}
- (IBAction)openFile:(id)sender {
    [self fileLocalClick];
}
- (IBAction)openLocalFile:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wangzhao" ofType:@"docx"];
    NSURL *filePathURL = [NSURL fileURLWithPath:path];
    [self previewFileWithURL:filePathURL];
}

#pragma mark -
#pragma mark UIDocumentPickerDelegate,
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url{
    //获取授权
    BOOL fileUrlAuthozied = [url startAccessingSecurityScopedResource];
    if (fileUrlAuthozied) {//授权成功
        //通过文件协调工具来得到新的地址,以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL * _Nonnull newURL) {
            //读取文件
            NSError *error = nil;
            NSString *fileName = [newURL lastPathComponent];
            NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
            NSLog(@"%@,%@",fileName,fileData);
            if (error) {
                //读取出错
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }else{
                //文件 上传或者其他操作
                
            }
        }];
        [url stopAccessingSecurityScopedResource];
    }else{//授权失败
        
    }
    
}


#pragma mark - UIDocumentInteractionControllerDelegate
//返回一个视图控制器，代表在此视图控制器弹出
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}
//返回一个视图，将此视图作为父视图
- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.view;
}
//返回一个CGRect，做为预览文件窗口的坐标和大小
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller {
    return self.view.frame;
}
//预览视图出现
- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller{
    //设置导航栏信息
    [UINavigationBar appearance].tintColor = [UIColor blueColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (UIDocumentPickerViewController *)documentPickerVC{
    if (!_documentPickerVC) {
        _documentPickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.content",
                                                                                            @"public.text", @"public.source-code ", @"public.image",@"public.mp3", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt",@"com.pkware.zip-archive",@"public.html"] inMode:UIDocumentPickerModeOpen];
        //设置可打开文件去看官方文档^_^
        _documentPickerVC.navigationController.navigationBar.tintColor = [UIColor blueColor];
        _documentPickerVC.delegate = self;
        _documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet; //设置模态弹出方式
    }
    return _documentPickerVC;
}
/**预览文件*/
- (void)previewFileWithURL:(NSURL *)url {
    if (!_isDocumentAppear) {
        return;
    }
    if (self.documentInteractionVC == nil) {
        self.documentInteractionVC = [[UIDocumentInteractionController alloc] init];
        self.documentInteractionVC.delegate = self;
    }
    if ([url isFileURL]) {
        if ([[[NSFileManager alloc] init] fileExistsAtPath:url.path]) {
            
            if ([url.path containsString:@"pdf"]||
                [url.path containsString:@"ppt"]||
                [url.path containsString:@"doc"]||
                [url.path containsString:@"xls"]||
                [url.path containsString:@"txt"]||
                [url.path containsString:@"mp3"]||
                [url.path containsString:@"text"]
                ) {
                //指定预览文件的URL
                self.documentInteractionVC.URL = url;
                //弹出预览文件窗口
                [self.documentInteractionVC presentPreviewAnimated:YES];
            }else{
                //如果不支持预览
        
            }
        }
        else {
            NSLog(@"文件不存在");
        }
        
    }
    else {
        NSLog(@"文件地址错误");
    }
}
@end
