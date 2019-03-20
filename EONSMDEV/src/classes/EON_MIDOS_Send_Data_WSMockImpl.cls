//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)
/**
Description : This is a Mock Class for below classes.
              EON_MIDOS_Send_Data_WS
              EON_MIDOS_Send_Data_Schema_WS
**/

/*
    Created By      : Dharmendra Pahadiya
    Created Date    : 13/07/2016
    Service Request : SR_Isis_EON_021
    Change History  : 
*/
@isTest
public class EON_MIDOS_Send_Data_WSMockImpl implements WebServiceMock {
	public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
       
		System.debug(LoggingLevel.INFO, 'EON_MIDOS_Send_Data_WSMockImpl.doInvoke() - ' +
			'\n request: ' + request +
			'\n response: ' + response +
			'\n endpoint: ' + endpoint +
			'\n soapAction: ' + soapAction +
			'\n requestName: ' + requestName +
			'\n responseNS: ' + responseNS +
			'\n responseName: ' + responseName +
			'\n responseType: ' + responseType);

		if(request instanceOf EON_MIDOS_Send_Data_WS.ConfigureSmsAsset_element) {
			response.put( 'response_x', new EON_MIDOS_Send_Data_WS.ConfigureSmsAssetResponse_element());
		}
		else if(request instanceOf EON_MIDOS_Send_Data_WS.ProvideServiceStatus_element) {
			EON_MIDOS_Send_Data_Schema_WS.ResponseMessageHeaderDto headerElem = new EON_MIDOS_Send_Data_Schema_WS.ResponseMessageHeaderDto();
			headerElem.AcknowledgementId = '1111';
			headerElem.AuditDate = datetime.now();
			headerElem.ErrorMessage = '';
			headerElem.OrgId = 'EON';
			headerElem.Status = 1;
			
			EON_MIDOS_Send_Data_Schema_WS.ServiceStatusResponseDto respElem = new EON_MIDOS_Send_Data_Schema_WS.ServiceStatusResponseDto();
			respElem.Header = headerElem;
			
			EON_MIDOS_Send_Data_WS.ProvideServiceStatusResponse_element resp = new EON_MIDOS_Send_Data_WS.ProvideServiceStatusResponse_element();
			resp.ProvideServiceStatusResult = respElem;
			response.put( 'response_x', resp);
		}
		else if(request instanceOf EON_MIDOS_Send_Data_WS.SubmitCreditMeterReading_element) {
			response.put( 'response_x', new EON_MIDOS_Send_Data_WS.SubmitCreditMeterReadingResponse_element());
		}
		else if(request instanceOf EON_MIDOS_Send_Data_WS.SubmitPrePayBalance_element) {
			response.put( 'response_x', new EON_MIDOS_Send_Data_WS.SubmitPrePayBalanceResponse_element());
		}
		else if(request instanceOf EON_MIDOS_Send_Data_WS.ValidateSmsAsset_element) {
			response.put( 'response_x', new EON_MIDOS_Send_Data_WS.ValidateSmsAssetResponse_element());
		}
	}
}