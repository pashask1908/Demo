({  
    doInit: function(component, event, helper) { 
      //alert("Do init ");
    // Fetch the account list from the Apex controller   
    helper.getBenefitsList(component, event, 'Citizen__r.Name');
  },
    sortCitizenName: function(component, event, helper) {
       // set current selected header field on selectedTabsoft attribute.     
       component.set("v.selectedTabsoft", 'Citizen Name');
       // call the helper function with pass sortField Name   
       helper.sortHelper(component, event, 'Citizen__r.Name');
    },
 
    sortAgency: function(component, event, helper) {
       // set current selected header field on selectedTabsoft attribute.    
       component.set("v.selectedTabsoft", 'Agency');
       // call the helper function with pass sortField Name  
       helper.sortHelper(component, event, 'Agency__c');
    },
 
    sortProgram: function(component, event, helper) {
       // set current selected header field on selectedTabsoft attribute.        
       component.set("v.selectedTabsoft", 'Program');
       // call the helper function with pass sortField Name      
       helper.sortHelper(component, event, 'Program__c');
    },
    sortStartDate: function(component, event, helper) {
       // set current selected header field on selectedTabsoft attribute.        
       component.set("v.selectedTabsoft", 'Start Date');
       // call the helper function with pass sortField Name      
       helper.sortHelper(component, event, 'Start_Date__c');
    },
    sortEndDate: function(component, event, helper) {
       // set current selected header field on selectedTabsoft attribute.        
       component.set("v.selectedTabsoft", 'End Date');
       // call the helper function with pass sortField Name      
       helper.sortHelper(component, event, 'End_Date__c');
    },
    
    calculateWidth : function(component, event, helper) {
            var childObj = event.target
            var parObj = childObj.parentNode;
            var count = 1;
            while(parObj.tagName != 'TH') {
                parObj = parObj.parentNode;
                count++;
            }
            console.log('final tag Name'+parObj.tagName);
            var mouseStart=event.clientX;
            component.set("v.mouseStart",mouseStart);
            component.set("v.oldWidth",parObj.offsetWidth);
    },
    setNewWidth : function(component, event, helper) {
            var childObj = event.target
            var parObj = childObj.parentNode;
            var count = 1;
            while(parObj.tagName != 'TH') {
                parObj = parObj.parentNode;
                count++;
            }
            var mouseStart = component.get("v.mouseStart");
            var oldWidth = component.get("v.oldWidth");
            var newWidth = event.clientX- parseFloat(mouseStart)+parseFloat(oldWidth);
            parObj.style.width = newWidth+'px';
    },
    
    closeModal:function(component,event,helper){    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    openmodal: function(component,event,helper) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },
    createCitizen: function (component) {
        var createRecordEvent = $A.get('e.force:createRecord');
        alert('create record'+createRecordEvent);
        if (createRecordEvent) {
            createRecordEvent.setParams({
                'entityApiName': 'NWD_Citizen__c',
                
                
            });
            createRecordEvent.fire();
        } else {
            /* Create Record Event is not supported */
            alert("Account creation not supported");
        }
    }



})