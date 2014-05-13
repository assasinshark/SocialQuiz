//
//  VWListaJuego.m
//  SocialQuiz
//
//  Created by Jair Serrano on 07/04/14.
//  Copyright (c) 2014 Jair Serrano. All rights reserved.
//

#import "VWListaJuego.h"

@interface VWListaJuego ()

@end

@implementation VWListaJuego

int sel = 0;

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
    _idspartidas = [[NSMutableArray alloc] init];
    _nombrescont = [[NSMutableArray alloc] init];
    _segues = [[NSMutableArray alloc] init];
    [self infoWebService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Sección tabla!

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nombrescont count];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CeldaJugador * celda = (CeldaJugador *)[tableView dequeueReusableCellWithIdentifier:@"celda"];
    if(celda == nil)
    {
        celda = [[CeldaJugador alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"celda"];
    }
    [[celda lbljugador] setText:(NSString *)[_nombrescont objectAtIndex:indexPath.row]];
    //[[celda imgjugador] setImage:[UIImage imageNamed:imgs[indexPath.row]]];
    NSString * rutaimg = @"/ws.imagen/StringImagenUsu/";
    NSURL *urlimg = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@/%d",_urlserv,rutaimg,[_idspartidas objectAtIndex:indexPath.row],2]];
    [[celda imgjugador] setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:urlimg]]];
    return celda;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:[_segues objectAtIndex:indexPath.row] sender:self];
    sel = indexPath.row;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //NSString * segid = [segue identifier];
    if ([[segue identifier] isEqualToString:@"segresp"])
    {
        //View Respuesta
        VWRespuesta * vdest = (VWRespuesta *)[segue destinationViewController];
        vdest.idpartida=[[_idspartidas objectAtIndex:sel] integerValue];
    }
    else if([[segue identifier] isEqualToString:@"segpreg"])
    {
        //View Pregunta
        VWPregunta * vdest = (VWRespuesta *)[segue destinationViewController];
        vdest.idPartida=[[_idspartidas objectAtIndex:sel] integerValue];
    }
    else if ([[segue identifier] isEqualToString:@"segesp"])
    {
        //View Espera
    }
    //else if () //Segue Agregar amigos
    {}
}

- (void) infoWebService
{
    //Consultar SWeb
    //NSString * idbusq = @"1";
    NSString * ruta = @"/ws.partida/MisPartidas/";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",_urlserv,ruta,_idJug]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSError* error = nil;
             NSArray *datos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             
             //NSLog((NSString * )[( (NSDictionary *)[datos objectAtIndex:0]) valueForKey:@"usuario"]);
             NSMutableString * idscontrincantes = [NSMutableString stringWithString:@""];
             NSMutableString * idspart = [NSMutableString stringWithString:@""];
             for (int pib = 0; pib< [datos count]; pib++)
             {
                 NSString * idp = [NSString stringWithFormat:@"%ld",[[( (NSDictionary *)[datos objectAtIndex:pib]) valueForKey:@"idPartida"] longValue]];
                 [_idspartidas addObject:idp];
                 [idspart appendString:((NSString *)[_idspartidas lastObject])];
                 
                 NSString * jug1 = [NSString stringWithFormat:@"%ld",[[( (NSDictionary *)[datos objectAtIndex:pib]) valueForKey:@"idJug1"] longValue]];
                 NSString * jug2 = [NSString stringWithFormat:@"%ld",[[( (NSDictionary *)[datos objectAtIndex:pib]) valueForKey:@"idJug2"] longValue]];
                 if([_idJug isEqualToString:jug1])
                 {
                     //Yo soy jugador 1, agrego a jugador 2
                     
                     [idscontrincantes appendString:jug2];
                 }
                 else
                 {
                     //Yo soy jugador 2, agrego a jugador 1
                     [idscontrincantes appendString:jug1];
                 }
                 if(pib<[datos count]-1)
                 {
                     [idscontrincantes appendString:@":"];
                     [idspart appendString:@":"];
                 }
             }
             
             //NSString * idscontrincantes = @"1:2:3";
             
             
             NSString * ruta2 = @"/ws.jugador/ListaContrincantes/";
             NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",_urlserv,ruta2,idscontrincantes]];
             NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
             
             [NSURLConnection sendAsynchronousRequest:request2 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response2,NSData *data2, NSError *connectionError2)
              {
                  if (data2.length > 0 && connectionError2 == nil)
                  {
                      NSError* error2 = nil;
                      NSArray *datos2 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:&error2];
                      for (int pib = 0; pib< [datos2 count]; pib++)
                      {
                          [_nombrescont addObject:(NSString *)[ ((NSDictionary *)[datos2 objectAtIndex:pib])  valueForKey:@"usuario"]];
                      }
                      [_tbljuegos reloadData];
                  }
              }];
             
             //Aqui obtengo los turnos, apenas estaba editando
             NSString * ruta3 = @"/ws.turno/UltimosTurnos/";
             NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",_urlserv,ruta3,idspart]];
             NSURLRequest *request3 = [NSURLRequest requestWithURL:url3];
             [NSURLConnection sendAsynchronousRequest:request3 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response3,NSData *data3, NSError *connectionError3)
              {
                  if (data3.length > 0 && connectionError3 == nil)
                  {
                      //NSLog([NSString stringWithUTF8String:[data bytes]]);
                      NSError* error3 = nil;
                      NSArray *datos3 = [NSJSONSerialization JSONObjectWithData:data3 options:NSJSONReadingMutableContainers error:&error3];
                      for (int pib = 0; pib< [datos3 count]; pib++)
                      {
                          
                          NSString * jug = [NSString stringWithFormat:@"%ld",[[( (NSDictionary *)[datos3 objectAtIndex:pib]) valueForKey:@"idJug"] longValue]];
                          if([_idJug isEqualToString:jug])
                          {
                              //Tiene que contestar
                              NSString * estado = [NSString stringWithFormat:@"%ld",[[( (NSDictionary *)[datos3 objectAtIndex:pib]) valueForKey:@"estado"] longValue]];
                              if([estado isEqualToString:@"0"])
                              {
                                  //Aun no responde
                                  [_segues addObject:@"segresp"];
                              }
                              else
                              {
                                  //Ya respondió manda pregunta!!
                                  [_segues addObject:@"segpreg"];
                              }
                          }
                          else
                          {
                              //El envia pregunta (Debe esperar)
                              [_segues addObject:@"segesp"];
                          }
                      }
                  }
              }];
         }
         else
         {
             //No llegó nada - error
         }
     }];
}



@end
