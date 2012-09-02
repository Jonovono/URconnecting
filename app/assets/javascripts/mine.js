$(document).ready(function() {  
	$("#send-confirmation").click(function() {
		var re = /^[\(\)0-9\- \+\.]{10,11}$/;
		
		var phone = $("#user_phone").val();
		phone = phone.replace(/\D+/g,'');

		if (re.test(phone)) {
			if (phone.length == 10) {
				phone = "1" + phone;
			}
			alert("A text message should now be sent to your phone. It will contain a five digit code. Please enter that below and press continue!");
			
			$.get('/send_confirmation', {phone: phone}, function(data) {
				console.log(data);
			});
		} else {
			alert("The phone you entered was incorrect.")
		}
		
	});
});