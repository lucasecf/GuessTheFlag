//
//  ViewController.h
//  GuessTheFlag
//
//  Created by Lucas Eduardo on 06/11/14.
//  Copyright (c) 2014 Lucas Eduardo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

- (IBAction)okBtnDidTouch:(id)sender;
- (IBAction)resetBtnDidTouch:(id)sender;
@end
