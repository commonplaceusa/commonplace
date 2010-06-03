 /*******************************************
 * commonscript.js
 *
 * (almost) all of commonplace's javascript
 *
 ********************************************/


 
var map;
 
/***********************************************
* Disable Text Selection script- © Dynamic Drive DHTML code library (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
***********************************************/

function disableSelection(target){
if (typeof target.onselectstart!="undefined") //IE route
	target.onselectstart=function(){return false}
else if (typeof target.style.MozUserSelect!="undefined") //Firefox route
	target.style.MozUserSelect="none"
else //All other route (ie: Opera)
	target.onmousedown=function(){return false}
target.style.cursor = "default"
}

//Sample usages
//disableSelection(document.body) //Disable text selection on entire body
//disableSelection(document.getElementById("mydiv")) //Disable text selection on element with id="mydiv"

/*
 * void
 * restoremsg(id, text)
 * 
 * put "message" back into text areas, and make them grey again
 *
 */
 
function restoremsg(id, text)
{
	// but only if the user hasn't typed anything
	if (document.getElementById(id).value == "")
	{
		// put text back in the box, make it grey
		document.getElementById(id).style.color = "#888888";
		document.getElementById(id).value = text;
	}
} 

/*
 * void
 * clearmsg(id, text)
 *
 * clear message text inside of text areas, and make them black
 *
 */

function clearmsg(id, text)
{
	// but only if they default "Message" is showing
	if (document.getElementById(id).value == text)
	{
		// clear the box, set the color to black
		document.getElementById(id).value = "";
		document.getElementById(id).style.color = "#000000";	
	}
}

/*
 * void
 * limitText(limitField, limitNum) 
 *
 * limit the number of characters in a text area
 * adapted from http://www.rgagnon.com/jsdetails/js-0091.html
 *
 */
 
function limitText(limitField, limitNum)
{
	// check if you're over the limit
    if (limitField.value.length > limitNum)
    {
    	// if so, cut off the text
        limitField.value = limitField.value.substring(0, limitNum);
    } 
}

function changeWire(url)
{
	document.getElementById("wire").src = url;
}

/*
 * void
 * addmarker(lat, lng, text)
 *
 * borrowed liberally from pset 8's addMarker :)
 *
 */
 
function addmarker(lat, lng, text)
{
	// initialize the point
	var point = new GLatLng(lat, lng);
	
	// initialize the marker
	var marker= new GMarker(point);
	
	// only add the bubble if some text is specified
	if (text != undefined)
	{
		GEvent.addListener(marker, "click", function() {
			map.openInfoWindowHtml(point, text);
		});
    }
    
    // add the marker to the map
	map.addOverlay(marker);   
}

/* 
 * void
 * useridmap(lat, lng, mark)
 *
 * print out a map with the specified coordinates on it
 * for use on the edit profile page
 *
 */
 
function useridmap(lat, lng, mark)
{	
	if (GBrowserIsCompatible())
	{
		// declare map as global so other functions can see it
		map = new GMap2(document.getElementById("map_canvas"));
		
		// set center
		map.setCenter(new GLatLng(lat, lng), 14);
		
		// put the marker on the map
		if (mark)
			addmarker(lat, lng);
	}
}


/*
 * void
 * plotEveryUser()
 *
 * prints out a map with every user on it!
 */
 
function animate(lat, lng, name, address, pic) {
	var xhtml = "<table><tr><td width='58px'>";
	xhtml += "<img src='" + pic + "' height='50' width='50'>";
  	xhtml += "</td>";
	xhtml += "<td style='vertical-align: top; padding: 4px'>";
  	xhtml += "<p style='margin-bottom: 5px'><strong>" + name + "</strong></p>";
  	xhtml += "<p style='font-size: .9em'>" + address.replace(", ", "<br />") + "</p>";
	xhtml += "</td></tr></table>";
	
	// var xhtml = "<table><tr><td rowspan='2'>";
	// 	xhtml += "<img height='50' width='50' src='" + pic + "' alt='" + name + "' />";
	// 	xhtml += "</td><td>";
	// 	xhtml += "<b>" + name + "</b><br />";
	// 	xhtml += "<span class='address'>" + address.replace(", ", "<br />") + "</span>";
	// 	xhtml += "</td></tr></table>";
	//var text = "<b>" + name + "</b><br />";
	//text += "<span class='time'>" + address.replace(", ", "<br />") + "</span>";
	var point = new GLatLng(lat, lng);
    window.parent.map.panTo(point);
    window.parent.map.setZoom(18);
    window.parent.map.openInfoWindowHtml(point, xhtml);
    
}

function plotEveryUser()
{		
	if (GBrowserIsCompatible())
	{
		// declare map as global so other functions can see it
		map = new GMap2(document.getElementById("map_canvas"));
		
		// set center to harvard, adjust map settings
		map.setCenter(new GLatLng(42.372148,-71.104747), 16);
		map.addControl(new GLargeMapControl3D());
		map.enableScrollWheelZoom();
/* 		map.setMapType(G_HYBRID_MAP); */

		// declare the URL to get every user's info
		var url = "source/userinfo.php";
		
		// use google's AJAX stuff to print out a marker for every user
		GDownloadUrl(url, function(data, responseCode) {
		
			// get all the user info into an array
			var users = eval("(" + data + ")");

			// loop over every user
			for (var i in users)
			{
				// declare "user" as shorthand
				var user = users[i];
				
				// only print a marker if the user has a coordinate
				if (user.lat != 0)
				{		
					/* declare the xhtml to put in each bubble
					var xhtml = "<table cellspacing='7'><tr><td rowspan='2'>";
					xhtml += "<img height='50' width='50' src='" + user.pic + "' alt='" + user.first + "' />";
					xhtml += "</td><td>";
					xhtml += "<b>" + user.first + " " + user.last + "</b><br />";
					xhtml += "<span class='address'>" + user.address.replace(", ", "<br />") + "</span>";
					xhtml += "</td></tr></table>"; */
					
					var xhtml = bubbleText(user);
					
					// add the marker
					addmarker(user.lat, user.lng, xhtml);
				}		
			}
		});
	
	showUsers();
	}
}

function bubbleText(user)
{
	// declare the xhtml to put in each bubble
	var xhtml = "<table cellspacing='7'><tr><td rowspan='2'>";
	xhtml += "<img height='50' width='50' src='" + user.pic + "' alt='" + user.first + "' />";
	xhtml += "</td><td>";
	xhtml += "<b>" + user.first + " " + user.last + "</b><br />";
	xhtml += "<span class='address'>" + user.address.replace(", ", "<br />") + "</span>";
	xhtml += "</td></tr></table>";
	
	return xhtml;
}

/*
 * void
 * showusers (biguser)
 *
 * the javascript to generate the user page dynamically!
 * borrowed heavily from lecture 9's source code
 * 
 * first gets the array of all the users, then loops over the page and prints them one at a time
 * when you click a user name, their info changes
 *
 * makes "bigUser" big by default
 *
 */

function showUsers(bigUser)
{
	// an XMLHttpRequest
	var xhr = null; 
	
	// make sure biguser isn't undefined
	if (!bigUser)
		bigUser = 0;
		
	// instantiate XMLHttpRequest object
	try
	{
		xhr = new XMLHttpRequest();
	}
	catch (e)
	{
		xhr = new ActiveXObject("Microsoft.XMLHTTP");
	}

	// handle old browsers
	if (xhr == null)
	{
		alert("Ajax not supported by your browser!");
	}

	// construct URL
	var url = "source/userinfo.php";
		
	// get all the user info, and just print out a table with everything
	xhr.onreadystatechange = function() {

		// only handle requests in "loaded" state
		if (xhr.readyState == 4)
		{
			// embed response in page if possible
			if (xhr.status == 200)
			{
				// actually get the info about every user, and make it a global variable
				var users = eval("(" + xhr.responseText + ")");
			
				// initialize the table with all the users
				var xhtml = "";
				
				// loop over every user, give them each their own table with an id
				for (var i in users)
				{	
					// initialize the point
					
					//var bubtext = bubbleText(users[i]);
					//alert(bubtext);
					xhtml += "<table width='470px' cellspacing='0' id='" + users[i].uid + "'";
					xhtml += "onclick='expandUser(" + users[i].uid + ", \"" + users[i].lat + "\", \"";
					xhtml += users[i].lng + "\", \"" + users[i].first + "\", \"" + users[i].address;
					xhtml += "\", \"" + users[i].pic + "\");'";
					xhtml += "class='userinfo'>";
					xhtml += "<tr><td rowspan='3' width='60'><img id='pic' height='50' width='50' src='";
					xhtml += users[i].pic + "' alt='" + users[i].first + "' /></td>";
					//xhtml += "<td></td>";
					xhtml += "<td><b>" + users[i].first + " " + users[i].last + "</b></td></tr>";
					xhtml += "<tr><td><table class='hidden' style='display:none'>";
					
					xhtml += "<tr><td class='time' width='60'>email:</td><td class='email'>" + users[i].email + "</td></tr>";

					// define address 
					if (users[i].address == "" || !users[i].address)
						var address = "<span class='error'>No address listed!</span>";
					else
						var address = "<span class='address'>" + users[i].address.replace(", ", "<br />") + "</span>";
						
					xhtml += "<tr><td class='time'>address:</td><td>";
					xhtml += address + "</td></tr>";
					xhtml += "</tr></td></table>";
					
					xhtml += "</table>";
					
					xhtml += "<table width='470px'>";
					xhtml += "<tr><td colspan='2'><hr /></tr></td>";
					xhtml += "</table>";
				
					
				}
				
				// actually put all the users' info on the page
				document.getElementById("usertable").innerHTML = xhtml;
				
				// initialize the point
				var point = new GLatLng(users[2].lat, users[2].lng);
				
				//addText(point, "hello world!");
				
				// show more info about a user if one's been specified as bigUser
				if (bigUser != '0')
				{	
					// also scroll to where they are
					document.getElementById(bigUser).scrollIntoView(true);
					expandUser(bigUser, point);
				}
				
				// set max height
				document.getElementById("usertable").style.maxHeight="230px";
			}
			else ;
				// alert("Error with Ajax call!");
		}

	};
	
	// actually execute the AJAX stuff
	xhr.open("GET", url, true);
	xhr.send(null);

}

/*
 * void
 * expandUser(uid)
 * 
 * expands a user's row -- also makes it smaller!
 *
 */
 
function expandUser(uid, lat, lng, name, address, picture)
{
	
	// close every other picture
	var usertable = window.parent.document.getElementById("usertable");
	var userpics = usertable.getElementsByTagName("img");
	var userinfo = usertable.getElementsByTagName("table");
	//userpics[0].parentNode.bgColor="blue";
	for(var i in userpics)
	{
	
		userpics[i].height = "50";
		userpics[i].width = "50";
		if(userpics[i].parentNode)
		{
			userpics[i].parentNode.width = "60";
		}
	}
	for(var i in userinfo)
	{
		if (userinfo[i].className == "hidden")
			userinfo[i].style.display = "none";
	}
	
	// store the name of the user's table and where his picture is
	var loc = window.parent.document.getElementById(uid);
	var pic = loc.getElementsByTagName("img")[0];
	var info = loc.getElementsByTagName("table")[0];
	
	//if (document.title == "homeposts" || document.title == "permalink")
	//{
		pic.scrollIntoView(true);
		if (lat != 0 && lng != 0)
		{
			var point = new GLatLng(lat, lng);
			animate(point, name, address, picture);
		}
	//}
	
	// show or hide the address
	//if (info.style.display == "block" && document.title != "homeposts" && document.title != "permalink")
	//	info.style.display = "none";
	//else
		info.style.display = "block";
	
	
	// enlarge and shrink the picture
	if (pic.height == "50")
	{
		pic.height = "100";
		pic.width = "100";	
		pic.parentNode.width = "115";
		/*
		if (lat != 0 && lng != 0)
		{
			var point = new GLatLng(lat, lng);
			animate(point, name, address);
		} */
		
	}
	

	/*
	else if (document.title != "homeposts" && document.title != "permalink")
	{
		pic.height = "50";
		pic.width = "50";
		pic.parentNode.width = "60";
	} */
	

}