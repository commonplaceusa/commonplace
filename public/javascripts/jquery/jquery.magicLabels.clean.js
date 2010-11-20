/*
Copyright (c) 2009, Henrik Joreteg
All rights reserved.

jQuery Magic Labels v0.6.2

Released under the BSD license, read it here:
http://projects.joreteg.com/licenses/BSD.html
*/

(function($) {
	$.fn.magicLabels = function(settings){
		var formSelector = this.selector;
	  var textSelector = formSelector + " input:text:visible:not(.password), " + 
            formSelector + " textarea:visible, " + 
            formSelector + " input:password";
		var labelText = 0;
		
		$(textSelector).each(function(){
			var oField = $(this);
			var labelText = 0;
			
			labelText = getLabelValue(oField);
			if (!isModified(oField)) {
                          if (oField.attr('type') == "password") {
                            var fakeField = $("<input type='text' class='password labelText' value='" + labelText + "'>");
                            fakeField.insertAfter(oField);
                            fakeField.focus(function() {
                              $(this).prev("input:password").show();
                              $(this).hide();
                            });
                            oField.hide();
                          } else {
				oField.val(labelText);
                          }
			}
		});
		
		$(textSelector).blur(function (){	
			var oField = $(this);

			if (isModified(oField)){
				return false;
			}
			else {
                          if (oField.attr('type') == 'password') {
                            oField.hide();
                            oField.next("input.password").show();
                          } else {
			    oField.val(getLabelValue(oField));
                          }
			}
		});
		
		$(textSelector).focus(function () {
			var oField = $(this);	
			
			if (isModified(oField)){
				return false;
			}
			else {	
				oField.val('');
			}
			oField.removeClass("labelText");
		});
		
		$(formSelector).submit(function () {	
			var formObject = $(this);
			
			$(textSelector).each(function(){
				var oField = $(this);
				// if it's not modified delete values
				if(!isModified(oField)) {
					oField.val('');
				}
				
			});
			return true;		
		});
	
		function getLabelValue(oField){
			var id = oField.attr('id');
			var oLabel = $(formSelector + " label[for = " + id + "]");
			var content = oLabel.html();
			
			oLabel.hide();
			return content;
		}
		
		function isModified(oField){
			var value = oField.attr("value");
			
			if (value == '' || value == getLabelValue(oField)) {
				oField.addClass("labelText");
				return false;
			}
			else {
				oField.removeClass("labelText");
				return true;
			}		
		}
		
		return this;
	};
})(jQuery);