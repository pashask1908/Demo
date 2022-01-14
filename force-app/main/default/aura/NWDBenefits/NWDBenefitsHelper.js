({
  // Fetch the accounts from the Apex controller
  getBenefitsList: function(component, event, sortField) {
    //  alert('getBenefits helper called'+sortField);
    var action = component.get('c.getBenefits');
      action.setParams({
         'sortField': sortField,
         'isAsc': component.get("v.isAsc")
      });
    // Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
     component.set('v.citizens', actionResult.getReturnValue());
       // alert('List :'+actionResult.getReturnValue());
    });
    $A.enqueueAction(action);
  },
    sortHelper: function(component, event, sortFieldName) {
      var currentDir = component.get("v.arrowDirection");
 
      if (currentDir == 'arrowdown') {
         // set the arrowDirection attribute for conditionally rendred arrow sign  
         component.set("v.arrowDirection", 'arrowup');
         // set the isAsc flag to true for sort in Assending order.  
         component.set("v.isAsc", true);
      } else {
         component.set("v.arrowDirection", 'arrowdown');
         component.set("v.isAsc", false);
      }
      // call the onLoad function for call server side method with pass sortFieldName 
      this.getBenefitsList(component, event, sortFieldName);
   },
})