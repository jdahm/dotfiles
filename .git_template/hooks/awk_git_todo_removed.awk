{
	for(i=0; i<NF; i++){
		if( match($i,/\-\-\-\ a\//) > 0 ){
			file=substr($i,7);
		}
		if( (j=match($i,/\ TODO\ /)) > 0 && substr($i,1,1) == "-" ){ 
			printf "%s [%s]\n", substr($i,j+6), file;
		}
	}
}
