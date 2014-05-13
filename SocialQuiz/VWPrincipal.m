//
//  ViewController.m
//  SocialQuiz
//
//  Created by Jair Serrano on 25/03/14.
//  Copyright (c) 2014 Jair Serrano. All rights reserved.
//

#import "VWPrincipal.h"

@interface VWPrincipal ()

@end

@implementation VWPrincipal

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"idJug"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://148.239.63.25:8080/SWSocialQuiz/webresources" forKey:@"urlserv"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
