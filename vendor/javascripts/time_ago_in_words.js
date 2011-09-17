window.timeAgoInWords = function(date_str) {
  var time = parseDate(date_str);
  var diff_in_seconds = (time - (new Date)) / 1000;
  var diff_in_minutes = Math.abs(Math.floor((diff_in_seconds / 60)));
  var add_token = function (in_words) { return diff_in_seconds > 0 ? "in " + in_words : in_words + " ago"; };
  if (diff_in_minutes === 0) { return add_token('less than a minute'); }
  if (diff_in_minutes == 1) { return add_token('a minute'); }
  if (diff_in_minutes < 45) { return add_token(diff_in_minutes + ' minutes'); }
  if (diff_in_minutes < 90) { return add_token('about 1 hour'); }
  if (diff_in_minutes < 1440) { return add_token('about ' + Math.floor(diff_in_minutes / 60) + ' hours'); }
  if (diff_in_minutes < 2880) { return add_token('1 day'); }
  if (diff_in_minutes < 43200) { return add_token(Math.floor(diff_in_minutes / 1440) + ' days'); }
  if (diff_in_minutes < 86400) { return add_token('about 1 month'); }
  if (diff_in_minutes < 525960) { return add_token(Math.floor(diff_in_minutes / 43200) + ' months'); }
  if (diff_in_minutes < 1051199) { return add_token('about 1 year'); }
  
  return add_token('over ' + Math.floor(diff_in_minutes / 525960) + ' years');
};


window.parseDate = function(date_str) {
  var m = date_str.match(/(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z/);
  return Date.UTC(m[1],m[2] - 1,m[3],m[4],m[5],m[6]);
};