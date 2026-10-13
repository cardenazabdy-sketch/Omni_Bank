ERD actualizado, incluyendo los nuevos atributos, tipos de llaves y notas de constraints.
_______________________    
|     Clientes        |                       
|_____________________|                        
| Cliente_ id (PK)    | UUID                   
| Nombre              | Obligatorio            
| Correo              | Único                  
| No.Telefono         | Único                  
| Fecha de nacimiento | Obligatorio            
| No.Identificación   | UUID                   
|_____________________|                     

+ ----------------<-                                  

 _____________________
|     Cuentas         |                       
|_____________________|                        
| Cuenta_id (PK)      | UUID                   
| Cliente_id (FK)     | UUID                    
| No. Venta           | UUID                    
| Moneda              | ENUM
| Tipo de cuenta      | ENUM
| Saldo actual        | No.Negativo
| Límite de cuenta    | NUMERIC            
|_____________________|                     

+ ----------------<-                                   

 _____________________
|    Transacciones    |                       
|_____________________|                        
| Tipo_transacción    | UUID                   
| Fecha_exacta        | Automático                
| Cuenta_destino      | Único                  
| Monto (FK)          | NUMERIC, mayor a 0                
| Estado              | VARCHAR
|_____________________|