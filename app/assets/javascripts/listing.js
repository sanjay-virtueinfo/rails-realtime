$( document ).ready(function() {
	client = new Faye.Client('/faye')
	
	client.subscribe('/listing', function(message) {
	   $.ajax({
	     type: "GET",
			 dataType: "script",	     
	     url: '/'+message.text+'?faye=yes',
	   });
	});
	window.client = client;		
});