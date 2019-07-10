//
//  TestEngineViewController.m
//  LGResStudyDemo
//
//  Created by 刘亚军 on 2018/4/24.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "TestEngineViewController.h"

#import <YJTaskMark/YJSpeechMark.h>


@interface TestEngineViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UITextField *refTextField;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *playbackBtn;
@property (weak, nonatomic) IBOutlet UILabel *playStateLab;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (nonatomic,assign) YJSpeechMarkType markType;
@end

@implementation TestEngineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refTextField.text = @"room";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.recordBtn addTarget:self action:@selector(recordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.playbackBtn addTarget:self action:@selector(playbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof(self) weakSelf = self;
    self.stateLab.text = [[YJSpeechManager defaultManager] isInitEngine] ? @"已配置好": @"配置中...";
    [[YJSpeechManager defaultManager] initResult:^(BOOL success) {
        if (success) {
            weakSelf.stateLab.text = @"已配置好";
        }else{
            weakSelf.stateLab.text = @"配置中...";
        }
    }];
    
    [[YJSpeechManager defaultManager] setMicrophoneAuthorization];
    self.playStateLab.text = @"";
    self.resultTextView.text = @"";
    [[YJSpeechManager defaultManager] speechEngineResult:^(YJSpeechResultModel *resultModel) {
        weakSelf.recordBtn.selected = NO;
        weakSelf.playStateLab.text = @"完成";
        if (resultModel.isError) {
            weakSelf.resultTextView.text = resultModel.errorMsg;
        }else{
            if (weakSelf.markType == YJSpeechMarkTypeASR) {
               weakSelf.resultTextView.text = [NSString stringWithFormat:@"识别结果: %@",resultModel.recognition];
            }else{
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"得分: %.f分",resultModel.totalScore];
            }
        }
    }];
    self.markType = YJSpeechMarkTypeWord;
}
- (IBAction)segment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.markType = YJSpeechMarkTypeWord;
    }else if (sender.selectedSegmentIndex == 1) {
        self.markType = YJSpeechMarkTypeSen;
    }else if (sender.selectedSegmentIndex == 2) {
        self.markType = YJSpeechMarkTypeASR;
    }else{
        self.markType = YJSpeechMarkTypeParagraph;
        self.refTextField.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)recordPressed:(UIButton *) btn{
    if (btn.selected) {
        self.playStateLab.text = @"评分中...";
        btn.selected = NO;
        [[YJSpeechManager defaultManager] stopEngine];
    }else{
        self.resultTextView.text = @"";;
        self.playStateLab.text = @"准备录音";
        [[YJSpeechManager defaultManager] startEngineAtRefText:self.refTextField.text markType:self.markType];
        btn.selected = YES;
    }
}

- (void)playbackPressed:(UIButton *) btn{
    [[YJSpeechManager defaultManager] playback];
}
@end
