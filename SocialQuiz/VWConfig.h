//
//  VWConfig.h
//  SocialQuiz
//
//  Created by Jair Serrano on 07/04/14.
//  Copyright (c) 2014 Jair Serrano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VWConfig : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtid;
- (IBAction)clickBtnCambiarJug:(id)sender;

@end
