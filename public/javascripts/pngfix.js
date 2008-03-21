
	
var arVersion = navigator.appVersion.split("MSIE")
var version = parseFloat(arVersion[1])

if ((version >= 5.5) && (document.body.filters)) 
{
	jq('img').each(function(){
		if (this.src.toUpperCase().indexOf('.PNG') > -1)
	      {
	         var imgID = (this.id) ? "id='" + this.id + "' " : ""
	         var imgClass = (this.className) ? "class='" + this.className + "' " : ""
	         var imgTitle = (this.title) ? "title='" + this.title + "' " : "title='" + this.alt + "' "
	         var imgStyle = "display:inline-block;" + this.style.cssText 
	         if (this.align == "left") imgStyle = "float:left;" + imgStyle
	         if (this.align == "right") imgStyle = "float:right;" + imgStyle
	         if (this.parentElement.href) imgStyle = "cursor:hand;" + imgStyle
	         var strNewHTML = "<span " + imgID + imgClass + imgTitle
	         + " style=\"" + "width:" + this.width + "px; height:" + this.height + "px;" + imgStyle + ";"
	         + "filter:progid:DXImageTransform.Microsoft.AlphaImageLoader"
	         + "(src=\'" + this.src + "\', sizingMethod='scale');\"></span>" 
	         this.outerHTML = strNewHTML
	      }
	})
}
