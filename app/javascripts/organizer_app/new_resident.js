
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

  backbutton: function(){
    if(this.model){
      this.$("#back").append("<button>");
    }
  },

  addResident: function(e){
    e.preventDefault();
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
      if(sectorvalue.length>0)
        params.sector_tags=sectorvalue;
      if(typevalue.length>0)
        params.type_tags=typevalue;

      this.model.save(params, {success: _.bind(this.render, this)});
      //alert(params['first_name']);
    }
    else{
      if(!this.$("#first-name").val()||!this.$("#last-name").val()){
        alert("At least a full name.....");
      }
      else{
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
		                      sector_tags: sectorvalue,
		                      type_tags:typevalue
		}),
		cache: 'false',
		success: function() { //this.show("Added");
		alert("Added. Refresh to see new residents");
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
