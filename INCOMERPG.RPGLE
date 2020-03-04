     FINCOMETDSPCF   E             WORKSTN                                                          
       ////////////////////// START PROGRAM ////////////////////////////////                        
       EXFMT GETINCOME;   // SHOW RECORD AND PAUSE                                                  
       DOW NOT(*IN03);    // DO WHILE EXIT INDICATOR NOT ON                                         
         IF INCOMEAMT = 0;                                                                          
           *IN98 = *ON;   // SHOW "ZERO INCOME AMOUNT"                                              
           EXFMT GETINCOME;     // KEEP SHOWING RECORD                                              
           *IN98 = *OFF;     // TURN INDICATOR BACK OFF                                             
           ITER; // RETURN TO BEGINNING OF LOOP                                                     
         ENDIF;                                                                                     
         IF MARRIED = ' '; // IF MARRIED IS EMPTY                                                   
           *IN97 = *ON; // SHOW "BLANK MARITAL STATUS"                                              
           EXFMT GETINCOME;                                                                         
           *IN97 = *OFF;                                                                            
           ITER;                                                                                    
         ENDIF;                                                                                     
         *IN60 = *ON; // IF USER PRESSES ENTER                                                      
         EXSR GETTAXRATE; // STARTS SUBROUTINE                                                      
         EXSR CALCULATETAX;  // GENERATES TAX REPORT || LAB3B                                       
        // LAB3A: DAYSTOPAY = 5;                                                                    
        // DUEDATE: APRIL 30TH, 2020.                                                               
          DAYSTOPAY = %DIFF(d'2020-04-30': %DATE(): *DAYS); // CALCULATES DAYS LEFT TO PAY          
        //LAB3A: TAXOWE = 1000;                                                                     
         WRITE GETINCOME; // REDISPLAYS FIRST SCREEN AND PREPS IT TO ACCEPT AN OVERLAY              
         EXFMT YOURTAX; // EXECUTES OVERLAY                                                         
         *IN60 = *OFF; // TURN INDICATOR OFF                                                        
         IF *IN03 = *ON; // IF EXIT INDICATOR IS NOT PRESSED                                        
           EXSR CLEAR; // RUN CLEAR FORM SUBROUTINE                                                 
           EXFMT GETINCOME; // GO BACK TO MAIN DISPLAY                                              
         ENDIF;                                                                                     
       ENDDO;                                                                                       
       *INLR = *ON; // IN LAST ROW                                                                  
       RETURN;                                                                                      
       ////////////////////////// END PROGRAM //////////////////////////////                        
                                                                                                    
       //////////////////////// SUBROUTINES BELOW ///////////////////////////                       
       // THIS SUBROUTINE EXECUTES NESTED SUBROUTINES BASED ON MARRIAGE STATUS                      
       BEGSR GETTAXRATE;                                                                            
        // LAB3A: TAXRATE = .22;                                                                    
        SELECT;                                                                                     
          WHEN MARRIED = 'Y';                                                                       
            EXSR MARRIEDRATE;                                                                       
          WHEN MARRIED = 'N';                                                                       
            EXSR SINGLERATE;                                                                        
        ENDSL;                                                                                      
       ENDSR;                                                                                       
       // THIS SUBROUTINE CALCULATES TAXRATE FOR A MARRIED INCOME HOUSEHOLD                         
       BEGSR MARRIEDRATE;                                                                           
         SELECT;                                                                                    
           WHEN INCOMEAMT <= 19050;                                                                 
             TAXRATE = .10;                                                                         
           WHEN INCOMEAMT <= 77400;                                                                 
             TAXRATE = .12;                                                                         
           WHEN INCOMEAMT <= 165000;                                                                
             TAXRATE = .22;                                                                         
           WHEN INCOMEAMT <= 315000;                                                                
             TAXRATE = .24;                                                                         
           WHEN INCOMEAMT <= 400000;                                                                
             TAXRATE = .32;                                                                         
           WHEN INCOMEAMT <= 600000;                                                                
             TAXRATE = .35;                                                                         
           WHEN INCOMEAMT <= 600001;                                                                
             TAXRATE = .37;                                                                         
         ENDSL;                                                                                     
       ENDSR;                                                                                       
       // THIS SUBROUTINE CALCULATES THE TAX RATE FOR A SINGLE HOUSEHOLD INCOME                     
       BEGSR SINGLERATE;                                                                            
         SELECT;                                                                                    
           WHEN INCOMEAMT <= 9525;                                                                  
             TAXRATE = .10;                                                                         
           WHEN INCOMEAMT <= 38700;                                                                 
             TAXRATE = .12;                                                                         
           WHEN INCOMEAMT <= 82500;                                                                 
             TAXRATE = .22;                                                                         
           WHEN INCOMEAMT <= 157500;                                                                
             TAXRATE = .24;                                                                         
           WHEN INCOMEAMT <= 200000;                                                                
             TAXRATE = .32;                                                                         
           WHEN INCOMEAMT <= 500000;                                                                
             TAXRATE = .35;                                                                         
           WHEN INCOMEAMT <= 500001;                                                                
             TAXRATE = .37;                                                                         
         ENDSL;                                                                                     
       ENDSR;                                                                                       
       // THIS SUBROUTINE GENERATES NUMBERS FOR THE TAX REPORT                                      
       BEGSR CALCULATETAX;                                                                          
           // SETTING MAX AMOUNTS FOR EXPENSES AND DONATIONS || LAB3B                               
           IF EXPENSES >= 4000;                                                                     
             EXPENSES = 4000;                                                                       
           ENDIF;                                                                                   
           IF DONATIONS >= 10000;                                                                   
             DONATIONS = 10000;                                                                     
           ENDIF;                                                                                   
           // CALCULATING TAXES                                                                     
         DEDUCTIONS = EXPENSES + DONATIONS;                                                         
         AINCOMEAMT = INCOMEAMT - DEDUCTIONS;                                                       
         TAXOWE = AINCOMEAMT * TAXRATE; // LAB3B                                                    
       ENDSR;                                                                                       
       // THIS SUBROUTINE RESETS THE ENTIRE FORM                                                    
       BEGSR CLEAR;                                                                                 
         INCOMEAMT = 0;                                                                             
         MARRIED = ' ';                                                                             
         TAXRATE = .10;                                                                             
         DAYSTOPAY = 0;                                                                             
         TAXOWE = 0;                                                                                
         DONATIONS = 0;                                                                             
         DEDUCTIONS = 0;                                                                            
         EXPENSES = 0;                                                                              
         AINCOMEAMT = 0;                                                                            
       ENDSR;                                                                                        
