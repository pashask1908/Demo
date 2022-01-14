({
    packItem: function(component, event, helper)
    {
        var ite = component.get("v.item1");
        ite.Packed__c = true;
        component.set("v.item1", ite);
        component.set("v.disabled", true)
    },
})