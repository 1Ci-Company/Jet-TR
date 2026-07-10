  &AtServer
function SendToAi(Prompt) Export
	ServerAddres = "api.groq.com";
	Connection = New HTTPConnection(ServerAddres, , , , , , New OpenSSLSecureConnection);
	
	Structure = New Structure;
	Structure.Insert("model", "llama-3.1-8b-instant");
	
	MessageContent = New Structure;
	MessageContent.Insert("role", "user");
	MessageContent.Insert("content", Prompt);
	
	MessageArray = New Array;
	MessageArray.Add(MessageContent);
	
	Structure.Insert("messages" , MessageArray);   
	
	JSONWriter = New JSONWriter;
	JSONWriter.SetString();
	WriteJSON(JSONWriter, Structure);
	JSONText = JSONWriter.Close();
	
	RequestPath = "/openai/v1/chat/completions";
	Request = New HTTPRequest(RequestPath);
	
	Request.Headers.Insert("Content-Type", "application/json");
	Request.Headers.Insert("Authorization", StrTemplate("Bearer %1",Constants.GrokAPIKey.Get())); 
		
	Request.SetBodyFromString(JSONText, TextEncoding.UTF8);
	                                
	Try		                                                         
		Response = Connection.Post(Request);                If Response.StatusCode = 200 Then                        JSONReader = New JSONReader;            JSONReader.SetString(Response.GetBodyAsString());            ResponseData = ReadJSON(JSONReader);            JSONReader.Close();                        AIResponseText = ResponseData.choices[0].message.content;            Return AIResponseText;        Else            Return "Error! Server Status Code: " + Format(Response.StatusCode, "NG=0");        EndIf;    Except        Return "Connection Error: Unable to reach the API server.";    EndTry;EndFunction
	
	
	
	
	                         