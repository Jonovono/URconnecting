$(document).ready(function() {      
	$("#send-confirmation").click(function() {
		var re = /^[\(\)0-9\- \+\.]{10,11}$/;
		
		var phone = $("#user_phone").val();
		phone = phone.replace(/\D+/g,'');

		if (re.test(phone)) {
			if (phone.length == 10) {
				phone = "1" + phone;
			}
			$.get('/send_confirmation', {phone: phone}, function(data) {
				console.log(data);
			});
		} else {
			alert("The phone you entered was incorrect.")
		}
		
	});
});