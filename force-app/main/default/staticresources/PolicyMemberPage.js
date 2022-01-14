
    var openSubtab = function openSubtab(result) 
    {
        primaryTabId = result.id;
		sforce.console.openSubtab(primaryTabId, '/'+ policyMemberId, true, 'test page title', null, testFocusSubtabByNameAndPrimaryTabId, 'salesforceSubtab')		
    };
	var testFocusSubtabByNameAndPrimaryTabId = function testFocusSubtabByNameAndPrimaryTabId() {
		alert(primaryTabId);
		sforce.console.focusSubtabByNameAndPrimaryTabId('salesforceSubtab', primaryTabId, null);
	}
	
	function testOpenSubtab() 
    {
        if (sforce.console.isInConsole()) 
        { 
            sforce.console.getEnclosingPrimaryTabId(openSubtab);
        }
    }