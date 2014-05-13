//
//  VWPregunta.m
//  SocialQuiz
//
//  Created by Jair Serrano on 07/04/14.
//  Copyright (c) 2014 Jair Serrano. All rights reserved.
//

#import "VWPregunta.h"

@interface VWPregunta ()

@end

@implementation VWPregunta

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _idJug = [[NSUserDefaults standardUserDefaults] valueForKey:@"idJug"];
    _urlserv = [[NSUserDefaults standardUserDefaults] valueForKey:@"urlserv"];
    [self infoWebService];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
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

- (void) infoWebService
{
    NSString * ruta2 = @"/ws.turno/UltimoTurno/";
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%ld",_urlserv,ruta2,(long)_idPartida]];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
    
    [NSURLConnection sendAsynchronousRequest:request2 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response2,NSData *data2, NSError *connectionError2)
     {
         if (data2.length > 0 && connectionError2 == nil)
         {
             NSError* error2 = nil;
             NSDictionary *datos2 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:&error2];
             
            _nturno = [[datos2 valueForKey:@"nturno"] longValue];
            //_idJug =(NSString *)[datos2 valueForKey:@"idJug"] ;
         }
     }];
    
    NSString * ruta = @"/ws.partida/";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%ld",_urlserv,ruta,_idPartida]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSError* error = nil;
             NSDictionary *datos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                 NSString * jug1 = [NSString stringWithFormat:@"%ld",[[datos valueForKey:@"idJug1"] longValue]];
                 NSString * jug2 = [NSString stringWithFormat:@"%ld",[[datos valueForKey:@"idJug2"] longValue]];
                 if([_idJug isEqualToString:jug1])
                 {
                     //Yo soy jugador 1, agrego a jugador 2
                     _idJugCont = jug2;
                 }
                 else
                 {
                     //Yo soy jugador 2, agrego a jugador 1
                     _idJugCont = jug1;
                 }
         }
         else
         {
             //No llegó nada - error
         }
     }];

    
}

- (IBAction)clic_btn_galeria:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = NO;
    }
}

- (IBAction)clic_btn_foto:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =UIImagePickerControllerCameraCaptureModePhoto;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = YES;
    }
}

- (IBAction)btn_clic_enviar:(id)sender
{
    
    [self subirImagen2:[_img1 image] :1];
    [self subirImagen2:[_img2 image] :2];
    [self registrarPregunta];
    [[self navigationController] popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        CGSize tam = CGSizeMake(125, 125);
        UIImage *resize = [self imageWithImage:image scaledToSize:tam];
        if(_img_1==YES)
        {
            
            [_img1 setImage:resize];
            _img_1=NO;
            _img_2=YES;
        }
        else
        {
            [_img2 setImage:resize];
            _img_1=YES;
            _img_2=NO;
        }
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:finishedSavingWithError:contextInfo:), nil);
    }
}


-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage*)imageWithImage : (UIImage*)image scaledToSize : (CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void) registrarPregunta
{
    NSString *pista= self.textPista.text;
    NSString *respuesta= self.textRespuesta.text;
    
    NSString * rutaresp = @"/ws.turno";
    NSURL *urlresp = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_urlserv,rutaresp]];
    //Necesitamos obtener jugador contrincante
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys: [ NSString stringWithFormat:@"%ld",0L], @"idTurno",[ NSString stringWithFormat:@"%ld",_idPartida], @"idPartida",_idJugCont, @"idJug",[ NSString stringWithFormat:@"%d",_nturno+1], @"nturno",pista, @"pistas",respuesta, @"resp",[ NSString stringWithFormat:@"%ld",0L], @"fecha",[ NSString stringWithFormat:@"%d",[respuesta length]], @"puntos",@"0", @"estado", nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlresp];
    
    NSString *postLength =  [NSString stringWithFormat:@"%d", [postdata length]];
    
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:postdata];
    
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [myConnection start];
}
- (void) subirImagen2 : (UIImage *) imagen : (int) indice
{
    
    
    NSString * rutaresp = @"/ws.imagen/Subir";
    NSURL *urlresp = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_urlserv,rutaresp]];
    
    
    NSData *imageData = UIImagePNGRepresentation(imagen);
    NSString * imgstring = [imageData base64EncodedStringWithOptions:kNilOptions];
    NSDictionary * tmp = [[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"tipo",[NSString stringWithFormat:@"%ld",_idPartida],@"id",[NSString stringWithFormat:@"%d",indice],@"indice",imgstring,@"datos", nil];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlresp];
    
    NSString *postLength =  [NSString stringWithFormat:@"%d", [postdata length]];
    
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:postdata];
    
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [myConnection start];
}
@end
