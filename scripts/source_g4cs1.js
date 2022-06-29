//dynamic menu for Learning Curve (lc) - 3Cs klee v1.0
//3Cs klee v1.1 fix on Opera5 and NS7 and IE cell layer.
function lcLoadMenus() {
  if (window.lc_menu_0) return;
  window.lc_menu_0 = new Menu("root",148,19,"Verdana, Arial, Helvetica, sans-serif",11,"#666633","#ffffff","#ffffff","#666633","left","middle",0,0,1000,0,0,true,true,true,15,true,true);
  lc_menu_0.addMenuItem("<font color='#E6E691'>&raquo;</font>&nbsp;Source&nbsp;1","location='g4cs1s1.htm'");
  lc_menu_0.addMenuItem("<font color='#E6E691'>&raquo;</font>&nbsp;Source&nbsp;2","location='g4cs1s2.htm'");
  lc_menu_0.addMenuItem("<font color='#E6E691'>&raquo;</font>&nbsp;Source&nbsp;3","location='g4cs1s3.htm'");
  lc_menu_0.addMenuItem("<font color='#E6E691'>&raquo;</font>&nbsp;Source&nbsp;4","location='g4cs1s4a.htm'");
  lc_menu_0.addMenuItem("<font color='#E6E691'>&raquo;</font>&nbsp;Source&nbsp;5","location='g4cs1s5.htm?zoomifyImagePath=g4cs1s5zoomify&zoomifyNavX=0&zoomifyNavY=0&zoomifyX=0&zoomifyY=0&zoomifyZoom=18&zoomifyNavWidth=180&zoomifyNavHeight=120&zoomifySlider=1&zoomifyMinZoom=-1&zoomifyMaxZoom=100&zoomifyNavWindow=1&zoomifyToolbar=1'");
  lc_menu_0.addMenuItem("<font color='#E6E691'>&raquo;</font>&nbsp;Source&nbsp;6","location='g4cs1s6.htm'");
  lc_menu_0.bgImageUp="../../images/dropdown/drop_option_gallery_d.gif";
  lc_menu_0.bgImageOver="../../images/dropdown/drop_option_gallery_u.gif";
  lc_menu_0.fontWeight="normal";
  lc_menu_0.hideOnMouseOut=true;
  lc_menu_0.writeMenus();
}//dynamic menu for Learning Curve end