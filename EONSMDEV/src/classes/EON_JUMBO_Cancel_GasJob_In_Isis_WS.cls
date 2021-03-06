/**
    Description: This class used to generate a WSDL for the cancel GAS job in Isis. This WSDL will be consumed by JUMBO and 
                send job information, as part of this an Appointment record will be updated to cancel.
    Test Class :  EON_JUMBO_Cancel_GasJob_In_Isis_WS_Test               
**/
/*
    Created By : Praveen G
    Created Date : 21-March-2016
    Service Request : SR_EON_Jumbo_011
    Change History  :
    CH01 # SR_EON_Jumbo_024 # 21/04/2016 # Chandan K #Received data from Jumbo and and appointment has been sent to Oracle (If Sent to Oracle = TRUE) then we need to call F.24 and O.14 to cancel the relevant appointment in Oracle.
    CH02 # SR_EON_Jumbo_040 # 13/07/2016 # Mehboob Alam # Populated 'Cancellation DateTime' Value. 
*/

global with sharing class EON_JUMBO_Cancel_GasJob_In_Isis_WS {

    /**
        Description : Request Parameter
    **/
    global with sharing class GasWorkRequest{    
        Webservice String MPRN;
        Webservice String ExternalJobReference;
        Webservice String JUMBOID;
        Webservice String TransactionStatusChangeReasonCode;       
    } 
    
    /**
        Description : Response Parameter
    **/
    global with sharing class JumboToIsisGasWorkResponse{
        Webservice String Success;
        Webservice String Message;
        Webservice String ExternalJobReference;
    }  
    
    /**
        cancelGasJobInIsis(GasWorkRequest cancelGasRequest) - 
                This method is used to cancel an Appointment record in Isis.
    **/
    webservice static JumboToIsisGasWorkResponse cancelGasJobInIsis(GasWorkRequest cancelGasRequest){ 
         JumboToIsisGasWorkResponse response = new JumboToIsisGasWorkResponse();
         JUMBO_Data_Tracker__c pTracker = new JUMBO_Data_Tracker__c();
         Oracle_Data_Tracker__c cTracker= new Oracle_Data_Tracker__c();
         
         //tracker information
         pTracker.Direction__c = EON_Utility.DIRECTION_IN;
         pTracker.Command__c = JUMBO_Utility.CMD_JUMBO_CancelGJ;
         pTracker.Status__c = EON_Utility.RESULT_PASS;         
         String result = ''; 
         try{
            if(!EON_Utility.validateRequired(cancelGasRequest)){
               pTracker.Request_Data__c = string.valueOf(cancelGasRequest);
               //Validation for mandatory fields
               if(EON_Utility.validateRequired(cancelGasRequest.MPRN))
                  result =result + 'Mandatory field MPRN is missing.\n';   
               if(EON_Utility.validateRequired(cancelGasRequest.JUMBOID))
                  result =result + 'Mandatory field JUMBOID is missing.\n';   
                  if(EON_Utility.validateRequired(result)){
                  	  EON_Appointment__c[] appointment = [select id,Name, Sent_to_Oracle__c from EON_Appointment__c 
                  	                                     where MPRN__c =: cancelGasRequest.MPRN and JUMBO_ID__c=:cancelGasRequest.JUMBOID];
                  	   if(!appointment.isEmpty()){
                          appointment[0].Cancel_Reason__c = system.label.EON_Jumbo_CancelationReason;
                          appointment[0].Status__c = EON_Utility.STATUS_CANCELLED;
                          appointment[0].JUMBO_Cancel_Reason__c = cancelGasRequest.TransactionStatusChangeReasonCode;
                          appointment[0].Cancellation_DateTime__c = datetime.now(); //CH02
                         
                         
                          // Below coe of block is added to create Exception only for test class coverage. .
                          if(!EON_Utility.validateRequired(EON_Utility.genException))
                              if(EON_Utility.genException)
                                  appointment[0].Start_Time__c='12345678';
                          
                          
                          response.externalJobReference = appointment[0].Name;    
                          pTracker.EON_Appointment__c = appointment[0].id;
	                         if(appointment[0].Sent_to_Oracle__c){
	                         	 //Calling Web Service to cancel this Appointment in OFSC
	                             string cnclRes =EON_Cancel_Activity_OFSC.cancelActivitiesInOFSC(appointment[0].id);
	                             if(cnclRes.equalsIgnoreCase('Activity cancelled in OFSC successfully')){
	                                 update appointment;                        
	                                 response.success = EON_Utility.RESULT_PASS;                                              
	                             }
	                               else{
	                               	   response.message = cnclRes;     
	                                   response.success = EON_Utility.RESULT_FAIL;
	                               }
	                        } 
	                         else{
	                         	 update appointment; 
	                             response.success = EON_Utility.RESULT_PASS;
	                         } 
                  	} 
                  	  else 
                  	     result = 'No Appointment found with the MPRN :'+ cancelGasRequest.MPRN+' and JUMBOID :'+cancelGasRequest.JUMBOID ;                              
                  }                                     
             }else{
                 result = 'No Request found (Request is null)';
             }               
          }catch(Exception ex){
            result = 'An Unknown error has occurred while processing this request. Please contact to System Administrator';
            pTracker.Status__c = EON_Utility.RESULT_FAIL;
            pTracker.Response_Data__c = ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber();
         }
         
        finally{          
             //This is error message block
             if(!EON_Utility.validateRequired(result)){
                 response.success = EON_Utility.RESULT_FAIL;
                 response.message = result;    
             } 
             
             //Updating tracker values
             pTracker.Response_Data__c = string.valueOf(response)+'\n'+(!EON_Utility.validateRequired(pTracker.Response_Data__c)?pTracker.Response_Data__c:'');
             insert pTracker;
             
             //CH01.Start
             //Updating child tracker record 
             if(!EON_Utility.validateRequired(EON_Cancel_Activity_OFSC.requestOut)){
             	 cTracker =EON_Cancel_Activity_OFSC.requestOut; 
             	 cTracker.JUMBO_Data_Tracker__c=pTracker.id;
                 update cTracker;
             }
             //CH01.End
         }    
         return response;
    }            
    
       
}