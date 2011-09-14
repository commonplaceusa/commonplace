/**
 * Transform text into a URL slug: spaces turned into dashes, remove non alnum
 * @param string text
 */
function slugify(text) {
  text = text.replace(/[^-a-zA-Z0-9,&\s]+/ig, '');
  text = text.replace(/\s/gi, "");
  return text;
}