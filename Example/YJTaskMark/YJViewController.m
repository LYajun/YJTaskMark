//
//  YJViewController.m
//  YJTaskMark
//
//  Created by lyj on 07/04/2019.
//  Copyright (c) 2019 lyj. All rights reserved.
//

#import "YJViewController.h"
#import "TestEngineViewController.h"
#import <YJTaskMark/YJSpeechMark.h>
@interface YJViewController ()<UIDocumentPickerDelegate>

@end

@implementation YJViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [[YJSpeechManager defaultManager] setMicrophoneAuthorization];
   
}

- (IBAction)btn1:(id)sender {
    TestEngineViewController *testVC = [[TestEngineViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}
- (IBAction)btn2:(id)sender {
    [[YJSpeechManager defaultManager] speechEngineResult:^(YJSpeechResultModel *resultModel) {
        
           if (resultModel.isError) {
               NSLog(@"");
           }else{
              NSLog(@"");
           }
       }];
    
    
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc]
                                                      initWithDocumentTypes:@[@"public.audio"] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:documentPicker animated:YES completion:nil];
}


#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSString *voiceUrl = urls.firstObject.absoluteString;
    voiceUrl = [voiceUrl stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    [[YJSpeechManager defaultManager] startEngineAtRefText:voiceUrl markType:YJSpeechMarkTypeASR fileASR:YES];
}
@end
