// fade effect ie and ns6+
function makevisible(cur,which){
strength=(which==0)? 1 : 0.2

if (cur.style.MozOpacity)
cur.style.MozOpacity=strength
else if (cur.filters)
cur.filters.alpha.opacity=strength*100
}
// fade effect ie and ns6+