
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
    
    If  NOT ValueIsFilled(Catalogs.AIPromtTemplates.Default.PromtText) Then 
        Item = Catalogs.AIPromtTemplates.Default.GetObject(); 
        Item.PromtText =  "Describe the main product parameters for customers." ; 
        Item.DefinitionLength = 200;
        Item.Write();
    EndIf;    
    Object.Promt =  Catalogs.AIPromtTemplates.Default; 
    
EndProcedure

&AtClient
Procedure GenerateDescription(Command)
    GenerateDescriptionAtServer();
EndProcedure

&AtServer 
Procedure GenerateDescriptionAtServer()
    If Not ValueIsFilled(Object.Product) Then
        Common.MessageToUser(NSTR("en = 'Please first pick a product'; tr = 'Lütfen önce ürün seçiniz.'"));
        Return;
    EndIf;
    
    ProductName = Object.Product.Description;
    PromptText  = Strtemplate("Create description for Product name %1 with length %2 symbols and using rules %3",ProductName,Object.Promt.DefinitionLength , Object.Promt.PromtText); 
    
    Result = GroqAi.SendToAi(PromptText);
    
    If Result <> Undefined Then
        Object.Definition = Result;
    EndIf;
EndProcedure                         


&AtClient
Procedure ApplyToProduct(Command)
    If Not ValueIsFilled(object.Definition)Then
        ShowMessageBox(, NSTR("en = 'First create a definition.'; tr = 'Önce bir tanım oluşturun.'"));
        return;
    EndIf;
    
    QuestionText = NSTR("en = 'This description will be written on the product and will overwrite the existing description. Are you sure?'; tr = 'Bu açıklama mevcut açıklamanın üzerine yazılacak. Emin misiniz?'");
    ShowQueryBox(New NotifyDescription("ApplyToProductConfirmed", ThisObject), QuestionText, QuestionDialogMode.YesNo);
    
EndProcedure  

&AtClientProcedure ApplyToProductConfirmed(Response, AdditionalParameters) Export        If Response = DialogReturnCode.Yes Then        ApplyToProductAtServer();    EndIf;    EndProcedure

&AtServerProcedure ApplyToProductAtServer()        ProductObject = Object.Product.GetObject(); 
    ProductObject.DetailedDescription = Object.Definition;
    ProductObject.Write();  
    
    Common.MessageToUser(NSTR("en = 'Description has been transferred to the product: '; tr = 'Açıklama ürüne aktarıldı: '") + Common.ObjectAttributeValue(Object.Product, "Description"));
    
EndProcedure


