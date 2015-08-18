//
//  ViewController.m
//  GuessTheFlag
//
//  Created by Lucas Eduardo on 06/11/14.
//  Copyright (c) 2014 Lucas Eduardo. All rights reserved.
//

#import "ViewController.h"

#define TURNS_NUMBER 5

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) int turn;
@property (nonatomic, strong) NSMutableArray *imagesNames;
@property (nonatomic, strong) NSMutableArray *currentGameImagesNames;

@property(nonatomic, strong) NSMutableArray *datasource;
@property(nonatomic, strong) NSString *rightChoice;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.datasource = [NSMutableArray new];
    
    //Load all images from the folder Teste
    NSArray *namesArray = [[NSBundle mainBundle] pathsForResourcesOfType:@".png" inDirectory:@"Flags"];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=/)([^/]*)(?=.png)" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    //regex to get only the image name, instead the fullpath /Users/..../Brazil.png
    self.imagesNames = [[NSMutableArray alloc] initWithCapacity:namesArray.count];
    for (NSString *string in namesArray) {
        NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        [self.imagesNames addObject:[string substringWithRange:match.range]];
    }
    
    //initing a new game
    self.currentGameImagesNames = [self.imagesNames mutableCopy];
    [self newTurn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.datasource[row];
}

-(void)sortOptions {
    [self.datasource removeAllObjects];
    
    NSMutableArray *copyNames = [self.currentGameImagesNames mutableCopy];
    
    for (int i = 0; i < 4; i++) {
        int index = arc4random() % copyNames.count;
        [self.datasource addObject:copyNames[index]];
        [copyNames removeObjectAtIndex:index];
    }
    
    int rightChoiceIndex = arc4random() % 4;
    [self.datasource replaceObjectAtIndex:rightChoiceIndex withObject:self.rightChoice];
    
    [self.picker reloadComponent:0];
}


-(void)newTurn {
    
    if (self.turn == TURNS_NUMBER) {
        self.okBtn.enabled = NO;
        self.statusLabel.text = @"The game is over! Tap the restart button to start a new game.";
    } else {
        
        //begin a new turn
        self.turn++;
        self.turnLabel.text = [NSString stringWithFormat:@"%d", self.turn];
        
        int index = arc4random() % self.currentGameImagesNames.count;
        self.rightChoice = self.currentGameImagesNames[index];
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Flags/%@.png", self.rightChoice]];
        [self.currentGameImagesNames removeObjectAtIndex:index];
        
        [self sortOptions];
    }
}

- (IBAction)okBtnDidTouch:(id)sender {
    
    //check the answer of the user
    NSString *selectedChoice = self.datasource[[self.picker selectedRowInComponent:0]];
    if ([selectedChoice isEqualToString:self.rightChoice])
    {
        int score = self.scoreLabel.text.intValue;
        self.scoreLabel.text = [NSString stringWithFormat:@"%d", score + 20];
        self.statusLabel.text = @"Congratulations! You scored =)";
    }
    else
    {
        self.statusLabel.text = @"You missed =(";
    }
    
    [self newTurn];
}

- (IBAction)resetBtnDidTouch:(id)sender {
    self.currentGameImagesNames = [self.imagesNames mutableCopy];
    self.statusLabel.text = @"Choose an option!";
    self.okBtn.enabled = YES;
    self.turn = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.turn];
    [self newTurn];
}

@end
