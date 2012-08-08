
OrganizerApp.AddResident = CommonPlace.View.extend({

  template: "organizer_app.new-resident",

  events: {
    //"submit form#add-resident": "addResident"
    "click #new-resident": "addResident"
  },

  name: function(){
    if(this.model){
      return this.model.full_name();
    }
    else{
      return "Enter the info:";
    }
  },

  addResident: function(e){
    e.preventDefault();
    var sectortags = document.getElementsByName('sector-tag');
    var sectorvalue = new Array();
    for(var i = 0; i < sectortags.length; i++){
      if(sectortags[i].checked)
	 sectorvalue.push(sectortags[i].value);
    }
    var typetags = document.getElementsByName('type-tag');
    var typevalue = new Array();
    for(var i = 0; i < typetags.length; i++){
      if(typetags[i].checked)
	 typevalue.push(typetags[i].value);
    }
    var inputmethods = document.getElementsByName('input-method');
    var methodvalue = new Array();
    for(var i = 0; i < inputmethods.length; i++){
      if(inputmethods[i].checked)
	 methodvalue.push(inputmethods[i].value);
    }
    var pfostatus = document.getElementsByName('PFO-status');
    var pfovalue = new Array();
    for(var i = 0; i < pfostatus.length; i++){
      if(pfostatus[i].checked)
	 pfovalue.push(pfostatus[i].value);
    }
    var organizers = document.getElementsByName('organizer');
    var organizer = new Array();
    for(var i = 0; i < organizers.length; i++){
      if(organizers[i].checked)
	 organizer.push(organizers[i].value);
    }    
    if(this.model){

      var params= {};

      if(this.$("#phone").val())
        params.phone=this.$("#phone").val();
      if(this.$("#organization").val())
        params.organization=this.$("#organization").val();
      if(this.$("#address").val())
        params.address=this.$("#address").val();
      if(this.$("#notes").val())
        params.notes=this.$("#notes").val();
      if(this.$("#position").val())
        params.position=this.$("#position").val();
      if(this.$("#email").val())
        params.email=this.$("#email").val();
      if(this.$("#first-name").val())
        params.first_name=this.$("#first-name").val();
      if(this.$("#last-name").val())
        params.last_name=this.$("#last-name").val();
        
      if(sectorvalue.length>0)
        params.sector_tag_list=sectorvalue;
      if(typevalue.length>0)
        params.type_tag_list=typevalue;
      if(methodvalue.length>0)
        params.input_method_list=methodvalue;
      if(pfovalue.length>0)
        params.PFO_statu_list=pfovalue;
      if(organizers.length>0)
        params.organizer_list=organizer;
      //console.log(params);  
      this.model.save(params, {success: function() { //this.show("Added");
		                          alert("Saved. Refreshing to see new residents");
		                          location.reload();
	                                } });

    }
    else{
      if(!this.$("#first-name").val()||!this.$("#last-name").val()){
        alert("At least a full name.....");
      }
      else{
	    
	    //console.log("!");
	    $.ajax({
		type: 'POST',
		contentType: "application/json",
		url: this.collection.url() + "/newresident",
		data: JSON.stringify({
		                      first_name: this.$("#first-name").val(),
		                      last_name: this.$("#last-name").val(),
		                      email: this.$("#email").val(),
		                      phone: this.$("#phone").val(),
		                      organization: this.$("#organization").val(),
		                      position: this.$("#position").val(),
		                      notes: this.$("#notes").val(),
		                      address: this.$("#address").val(),
		                      sector_tag_list: sectorvalue,
		                      type_tag_list: typevalue,
		                      PFO_statu_list: pfovalue,
		                      organizer_list: organizer,
		                      input_method_list: methodvalue
		}),
		cache: 'false',
		success: function() { //this.show("Added");
		           alert("Added. Refreshing to see new residents");
		           location.reload();
	                 }
	    });

	    this.options.filePicker.render();
	    }
	}
  },

  show: function(){
    collection.each(function(model) {
      console.log(model.full_name());
    });
    
  }

});
