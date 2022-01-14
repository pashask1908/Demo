({
  createCitizen : function(component, event) {
    var newCitizen = component.get("v.newCit");
    var action = component.get("c.saveCitizen");
    action.setParams({ 
        "cit": newCitizen
    });
    action.setCallback(this, function(a) {
           var state = a.getState();
            if (state === "SUCCESS") {
                
               alert("Record Inserted");
            }
        });
    $A.enqueueAction(action)
}
    })