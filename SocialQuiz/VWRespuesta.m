//
//  VWRespuesta.m
//  SocialQuiz
//
//  Created by Jair Serrano on 07/04/14.
//  Copyright (c) 2014 Jair Serrano. All rights reserved.
//

#import "VWRespuesta.h"

@interface VWRespuesta ()

@end

@implementation VWRespuesta

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _idJug = [[NSUserDefaults standardUserDefaults] valueForKey:@"idJug"];
    _urlserv = [[NSUserDefaults standardUserDefaults] valueForKey:@"urlserv"];
    [self infoWebService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) infoWebService
{
    NSString * ruta2 = @"/ws.turno/UltimoTurno/";
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%ld",_urlserv,ruta2,(long)_idpartida]];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
    
    [NSURLConnection sendAsynchronousRequest:request2 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response2,NSData *data2, NSError *connectionError2)
     {
         if (data2.length > 0 && connectionError2 == nil)
         {
             NSError* error2 = nil;
             NSDictionary *datos2 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:&error2];
             _resp = (NSString *)[ datos2  valueForKey:@"resp"];
             _pistas = (NSString *)[ datos2  valueForKey:@"pistas"];
             //Zona de peligro!
             _puntos = [((NSString *)[ datos2  valueForKey:@"pistas"]) integerValue];
             _idturno = [[datos2 valueForKey:@"idTurno"] longValue];
             _nturno = [[datos2 valueForKey:@"nturno"] longValue];
             _fecha = [[datos2 valueForKey:@"fecha"] longValue];
             [self llenarInfo];
         }
     }];
    
    NSString * rutaimg = @"/ws.imagen/StringImagen/";
    NSURL *urlimg = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%ld/%d",_urlserv,rutaimg,(long)_idpartida,1]];
    
    [_img1 setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:urlimg]]];
    NSURL *urlimg2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%ld/%d",_urlserv,rutaimg,(long)_idpartida,2]];
    [_img2 setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:urlimg2]]];
    //[_img2 setImage:[UIImage ]]
}
- (void)llenarInfo
{
    NSMutableString * guiones = [NSMutableString stringWithFormat:@""];
    for(int pib =0; pib<[_resp length];pib++)
    {
        [guiones appendString:@"_ "];
    }
    [_lblletras setText:guiones];
    [_txtpistas setText:_pistas];
    [_txtrespuesta setText:@""];
}



-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _txtrespuesta)
    {
        if([[_txtrespuesta text] isEqualToString:_resp])
        {
            [self registrarRespuesta];
            NSLog(@"Respuesta Correcta");
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
}
- (void) registrarRespuesta
{
    NSString * rutaresp = @"/ws.turno";
    NSURL *urlresp = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_urlserv,rutaresp]];
    //Corregir fecha, la obtengo con long? XD devolver 0?
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys: [ NSString stringWithFormat:@"%ld",_idturno], @"idTurno",[ NSString stringWithFormat:@"%ld",_idpartida], @"idPartida",_idJug, @"idJug",[ NSString stringWithFormat:@"%d",_nturno], @"nturno",_pistas, @"pistas",_resp, @"resp",@"0"/*[ NSString stringWithFormat:@"%ld",_fecha]*/, @"fecha",[ NSString stringWithFormat:@"%d",_puntos], @"puntos",@"1", @"estado", nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlresp];
    
    NSString *postLength =  [NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]];
    
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"PUT"];
    
    [request setHTTPBody:postdata];
    
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [myConnection start];
    
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

@end
