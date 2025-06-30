//**************************//
// Custom-made script for ImageJ (Part 1)
// Multiplex imaging using cumulative microscopy
// Akopyan et al.
// Department of Cell and Molecular Biology
// Karolinska Institutet
//*************************//

//**************//
// 1. This script is for Image J (FIJI) version V1.53q or later 
// 2. Open the script in Image J (FIJI)
// 3. Run
//************//

dialog=1; // Dialog option on
numSamp=1; //
Stepnum=1; //
experiment="Exp001";

NucL="DAPI"; // Nuclear lable (for ex., DAPI)
NucW="w1"; // File names with DAPI contains...

SphL="EdU"; // S phase lable (for ex., EdU)
SphW="w4"; // File names with EdU contains...

MainL="yH2AX"; // Main lable (for ex., yH2AX)
MainW="w3"; // File names with Main lable contains...

Main2L="pTCTP"; // Second Main lable (for ex., Cyclin A)
Main2W="w2"; // File names with Second Main lable contains...





ThreshMethod=0; // default Threshold method

ThreshValMinI=100;
ThreshValMax=65000;
ParticleSizeMin=200;
ParticleSizeMax=1000;

BGchoice=newArray("Skip","Calculate","Use parameters");

WhValS="Int";
WhValM="Int";
WhValM2="Int";
///////////////////////////////////////////////////////////////////////
	
Dialog.create("Welcome");
Dialog.addMessage("Step 1 of 8 \nAdd some general parameters for your experiment.", 20);
Dialog.addMessage("The name of the Experiment (will be used as folder name for results)", 14);
Dialog.addString("Experiment name ", experiment);
Dialog.addNumber("Cycle number", Stepnum, 0, 2,"(Which Cycle)");
Dialog.addNumber("How many Samples", numSamp, 0, 2,"(the number of folders with images)");
Dialog.addMessage("NOTE: The images for every Sample should be in separate folder with Sapmle name", 14, "#cc3300");
Dialog.addMessage("Please choose the background option that may be used for correcting non specific signal from secondary antibodies", 14, "#333300");
Dialog.addChoice("Background options", BGchoice);
//Dialog.addHelp("https://lindqvistgroup.org");
Dialog.show();

experiment=Dialog.getString();
Stepnum=Dialog.getNumber();
numSamp=Dialog.getNumber();
bgch=Dialog.getChoice();
bgchN=0;

if(bgch=="Calculate"){
		bgchN=1;
	}
	if(bgch=="Use parameters"){
		bgchN=2;
	}
	//////**End**////////

//////////////////////////
if (Stepnum==2) {
	MainL="Plk1"; // Main lable (for ex., yH2AX)
	Main2L="CycA"; // Second Main lable (for ex., Cyclin A)
}
if (Stepnum==3) {
	MainL="p53"; // Main lable (for ex., yH2AX)
	Main2L="p21"; // Second Main lable (for ex., Cyclin A)
}

/////////////////////////


//////********////////	
Dialog.create("Specify folder with Samples");
Dialog.addMessage("Step 2 of 8 \nNext you will be asked to choose MAIN folder where the Sample folders with images are located.", 16);
Dialog.addMessage("NOTE: The images for every Sample should be in separate folder with the Sample name", 14, "#cc3300");
Dialog.show();

dirI=getDirectory("Choose directory with Files! "); //

checkForFolder=0;

if (numSamp>0){
	if(bgchN==1){
	numSamp=numSamp+1;	
	}
	Samp=newArray(numSamp);
try=0;
while (checkForFolder<numSamp) {

checkForFolder=0;	
	
Dialog.create("Settings");
if (try==0) {

Dialog.addMessage("Step 3 of 8 \nPlease add names for your samples.", 20);
}else {
	Dialog.addMessage("Errore! The folder(s) for one or more samples not found", 20, "#FF3300");
	Dialog.addMessage("Please, add correct names for your samples.", 20);
}
Dialog.addMessage("NOTE: The sample name should be identical to the folder name with the images for the sample", 14, "#cc3300");
Dialog.addMessage("NOTE: It is recommended to use control as Sample 1", 12);
Dialog.addMessage("", 14);


for (i = 0; i < numSamp-1; i++) {
	Dialog.addString(""+i+1+" Sample name", "Sample"+i+1+"");
	Dialog.addMessage("", 14);
	}
	if(bgchN==1){
		Dialog.addString(""+i+1+" Background Sample", "BG_Sample");
	}else {
	Dialog.addString(""+i+1+" Sample name", "Sample"+i+1+"");
	}
	Dialog.addMessage("", 14);
		
Dialog.show();


for (i = 0; i < numSamp; i++) {
Samp[i]=Dialog.getString();	
}

for (i = 0; i < numSamp; i++) {
if (File.exists(dirI+"/"+Samp[i])) {
	checkForFolder=checkForFolder+1;
}
}
try=1;
}//end for while
	
} else {
exit
}



Dialog.create("Specify folder for saving Results");
Dialog.addMessage("Step 4 of 8 \nNext you will be asked to choose folder where the results will be saved.", 16);
Dialog.addMessage("NOTE: in the end of the script you will get the destination of all your saved data ", 14, "#00cc33");
Dialog.show();


dirS=getDirectory("Choose directory to save! "); //directory for saving 


//////**END***////////
	
//////********////////
	Dialog.create("Channels");
Dialog.addMessage("Step 5 of 8 \nPlease, add specific parameters for your experiment.", 20);
Dialog.addString("Nuclear lable (for ex., DAPI)", NucL);
Dialog.addString("1st channel (Nuclear) file names contains...", NucW);
Dialog.addString("S phase lable (for ex., EdU )", SphL);
Dialog.addString("2nd channel (S phase) file names contains...", SphW);
Dialog.addString("Main lable (for ex., yH2AX)", MainL);
Dialog.addString("3rd channel (Main) file names contains...", MainW);
Dialog.addString("2ndMain lable (for ex., CycA )", Main2L);
Dialog.addString("4rd channel (2ndMain) file names contains...", Main2W);

Dialog.show();

NucL=Dialog.getString(); // Nuclear lable (for ex., DAPI)
NucW=Dialog.getString(); // File names with DAPI contains...

SphL=Dialog.getString(); // S phase lable (for ex., EdU)
SphW=Dialog.getString(); // File names with EdU contains...

MainL=Dialog.getString(); // Main lable (for ex., yH2AX)
MainW=Dialog.getString(); // File names with Main contains...
Main2L=Dialog.getString(); // 2nd Main lable (for ex., CycA)
Main2W=Dialog.getString(); // File names with 2nd Main contains...

	
	//////********////////		

if (bgchN>0) {
 Dialog.create("Background correction options");
Dialog.addMessage("Please, choose which channels should be corrected for Background", 16);
Dialog.addCheckbox("Correct  "+SphL, 0);
Dialog.addCheckbox("Correct  "+MainL, 0);
Dialog.addCheckbox("Correct  "+Main2L, 0);
Dialog.show();

bgCorrSphL=Dialog.getCheckbox();
bgCorrMainL=Dialog.getCheckbox();
bgCorrMain2L=Dialog.getCheckbox();

}
////////////////////
	if (bgchN==2) {
	BGformSphL=newArray(0,0,1);
BGformMainL=newArray(0,0,1);
BGformMain2L=newArray(0,0,1);
	
	if (bgCorrSphL+bgCorrMainL+bgCorrMain2L>0) {
    Dialog.create("Background parameters");
	Dialog.addMessage("Please, add the parameters for background calculation: y=a+bx", 14);
	if (bgCorrSphL==1) {
	Dialog.addMessage("Please, add the parameters for "+SphL+"", 14);
		Dialog.addNumber("1 Value for 'a'", 0);
		Dialog.addNumber("2 Value for 'b'", 0);
		Dialog.addMessage("", 14);
			}
	if (bgCorrMainL==1) {
	Dialog.addMessage("Please, add the parameters for "+MainL+"", 14);
		Dialog.addNumber("3 Value for 'a'", 0);
		Dialog.addNumber("4 Value for 'b'", 0);
		Dialog.addMessage("", 14);
	}
	if (bgCorrMain2L==1) {
	Dialog.addMessage("Please, add the parameters for "+Main2L+"", 14);
		Dialog.addNumber("5 Value for 'a'", 0);
		Dialog.addNumber("6 Value for 'b'", 0);
		Dialog.addMessage("", 14);
	}
	Dialog.show();
	
	if (bgCorrSphL==1) {
		BGformSphL[0]=Dialog.getNumber();
		BGformSphL[1]=Dialog.getNumber();
		BGformSphL[2]=0;
	}
	if (bgCorrMainL==1) {
		BGformMainL[0]=Dialog.getNumber();
		BGformMainL[1]=Dialog.getNumber();
		BGformMainL[2]=0;
	}
	if (bgCorrMain2L==1) {
		BGformMain2L[0]=Dialog.getNumber();
		BGformMain2L[1]=Dialog.getNumber();
		BGformMain2L[2]=0;
	}
}
}	

//////////////////////////////////////////////////////////////////////




//********* PART 1 - Segmentation  ********

run("Set Measurements...", "area mean centroid redirect=None decimal=3");

dirF=dirI+"/"+Samp[0];

File.openSequence(dirF, " filter="+NucW);
rename(NucL);
run("Brightness/Contrast...");

newMaxMin=FnChooseSize();

ParticleSizeMax=newMaxMin[0];
ParticleSizeMin=newMaxMin[1];
rad=newMaxMin[2];

BgRadius=round(rad*3); //Rolling ball size calculation based on length of biggest object

selectWindow(NucL);
run("Subtract Background...", "rolling="+BgRadius+" stack");

if (dialog>0) {

rbg=newArray("Auto Threshold", "Manual Threshold");
Dialog.create("Thresholding option");
Dialog.addMessage("Step 8 of 8 \nChoose thresholding method", 20);
Dialog.addRadioButtonGroup("Threshold method", rbg, 1, 2, "Auto Threshold");


Dialog.show();

ThreshM=Dialog.getRadioButton();
if (ThreshM=="Manual Threshold") {
	ThreshMethod=1;
}

	
}

if (ThreshMethod==1) {

newThresh=FnThresh(NucL);
ThreshValMinI=newThresh[0];
ThreshValMax=newThresh[1];

} else { 
	close(NucL);
	if (isOpen("B&C")) {
        close("B&C");
        }
	
}

stTrScr=getTime();

for (k = 0; k < numSamp; k++) {

dirF=dirI+"/"+Samp[k];

File.openSequence(dirF, " filter="+NucW);
rename(NucL);
run("Subtract Background...", "rolling="+BgRadius+" stack");

if (Stepnum<2) {

File.openSequence(dirF, " filter="+SphW);
rename(SphL);
run("Subtract Background...", "rolling="+BgRadius+" stack");
}
File.openSequence(dirF, " filter="+MainW);
rename(MainL);
run("Subtract Background...", "rolling="+BgRadius+" stack");

File.openSequence(dirF, " filter="+Main2W);
rename(Main2L);
run("Subtract Background...", "rolling="+BgRadius+" stack");

dirSS=experiment;
dir=dirS+"/"+dirSS;
dir2="Log"; //directory for saving logs
dir3="Tables"; //directory for saving tables
dir4="Graphs"; //directory for saving Graphs
File.makeDirectory(dir) //Creates a directory.
File.makeDirectory(dir+"/"+dir2) //Creates a directory.
File.makeDirectory(dir+"/"+dir3) //Creates a directory.
File.makeDirectory(dir+"/"+dir4) //Creates a directory.

titTable="MainTab_"+Samp[k]+"_Step"+Stepnum;
	Table.create(titTable);
	Table.setColumn("Slice");
	Table.setColumn("Num");
	Table.setColumn("X");
	Table.setColumn("Y");
	Table.setColumn("Area");
	Table.setColumn(NucL+"Mean");
	if (Stepnum<2) {
	Table.setColumn(SphL+"Mean");
	}
	Table.setColumn(MainL+"Mean");
	Table.setColumn(Main2L+"Mean");
	Table.setColumn(NucL+"Int");
	if (Stepnum<2) {
	Table.setColumn(SphL+"Int");
	}
	Table.setColumn(MainL+"Int");
	Table.setColumn(Main2L+"Int");
	if (Stepnum<2) {
	Table.setColumn("CCPh");
	}
	tpath=dir+"/"+dir3+"/"+titTable+".txt";
	Table.save(tpath);

run("Set Scale...", "distance=0 known=0 unit=pixel");
//********* END PART 1 **********


//********* PART 2 - Analysis**********

selectWindow(NucL);
depth = nSlices;

for (i = 1; i < nSlices+1; i++) { //Main For

selectWindow(MainL);
setSlice(i);

selectWindow(Main2L);
setSlice(i);
if (Stepnum<2) {
selectWindow(SphL);
setSlice(i);
}
selectWindow(NucL);
setSlice(i);
run("Duplicate...", "title=MainMask");

if (ThreshMethod==1) {

run("Manual Threshold...", "min="+ThreshValMinI+" max="+ThreshValMax+"");
} else {
	run("Auto Threshold", "method=Otsu");
}

setOption("BlackBackground", false);
run("Convert to Mask");

run("Fill Holes");

run("Watershed");

run("Analyze Particles...", "size="+ParticleSizeMin+"-"+ParticleSizeMax+" exclude clear include add");


selectWindow("MainMask");
close();


NumberOfCells=roiManager("count");


for (ii = 0; ii < NumberOfCells; ii++) { // For q1
	selectWindow(NucL);
	roiManager("Select", ii);
	run("Measure");
	
	
	}//end q1
	
	if (Stepnum<2) {
	for (ii = 0; ii < NumberOfCells; ii++) { // For q2
	selectWindow(SphL);
	roiManager("Select", ii);
	run("Measure");
	
	
	}//end q2
	}
	for (ii = 0; ii < NumberOfCells; ii++) { // For q3
	selectWindow(MainL);
	roiManager("Select", ii);
	run("Measure");
	
	
	}//end q3
	
	for (ii = 0; ii < NumberOfCells; ii++) { // For q4
	selectWindow(Main2L);
	roiManager("Select", ii);
	run("Measure");
	
	
	}//end q4
	
	if (isOpen("Results")==true){ //check for Results
		
	num=Table.size;
	
	for (ii = 0; ii < NumberOfCells; ii++) { // For q5
	
	Area=getResult("Area", ii);
    MeanN=getResult("Mean", ii);
    XN=getResult("X", ii);
    YN=getResult("Y", ii);
    IntN=Area*MeanN;
    
    if (Stepnum<2) {
    MeanS=getResult("Mean", ii+NumberOfCells);
    IntS=Area*MeanS;
    
     MeanM=getResult("Mean", ii+NumberOfCells*2);
    IntM=Area*MeanM;
    
    MeanM2=getResult("Mean", ii+NumberOfCells*3);
    IntM2=Area*MeanM2;
    }else {
    	    
     MeanM=getResult("Mean", ii+NumberOfCells);
    IntM=Area*MeanM;
    
    MeanM2=getResult("Mean", ii+NumberOfCells*2);
    IntM2=Area*MeanM2;
    
    }
    Table.set("Slice", ii+num, i);
    Table.set("Num", ii+num, num+ii+1);
    Table.set("X", ii+num, round(XN));
    Table.set("Y", ii+num, round(YN));
	Table.set("Area", ii+num, Area);
	Table.set(NucL+"Mean", ii+num, round(MeanN));
	Table.set(NucL+"Int", ii+num, round(IntN));
	if (Stepnum<2) {
	Table.set(SphL+"Mean", ii+num, round(MeanS));
	Table.set(SphL+"Int", ii+num, round(IntS));
	}
	Table.set(MainL+"Mean", ii+num, round(MeanM));
	Table.set(MainL+"Int", ii+num, round(IntM));
	Table.set(Main2L+"Mean", ii+num, round(MeanM2));
	Table.set(Main2L+"Int", ii+num, round(IntM2));
	Table.update;
	//Table.save(tpath);
		
}//end q5
selectWindow("Results");
run("Close");

	}// End check for Results

roiManager("Deselect");

if (NumberOfCells>0) {
roiManager("Delete");
}

selectWindow(Main2L);
run("Select None");
selectWindow(MainL);
run("Select None");
if (Stepnum<2) {
selectWindow(SphL);
run("Select None");
}
selectWindow(NucL);
run("Select None");

}//End of Main For
Table.save(tpath);
close(titTable);
selectWindow(Main2L);
close();
selectWindow(MainL);
close();
if (Stepnum<2) {
selectWindow(SphL);
close();
}
selectWindow(NucL);
close();
//********* END PART 2 **********

} // ENF FOR (numSamp)

/////////***********BG*****////
if (bgchN==1) {
numSamp=numSamp-1;

BGformSphL=newArray(0,0,1);
BGformMainL=newArray(0,0,1);
BGformMain2L=newArray(0,0,1);

if (bgCorrSphL==1) {
	
	titTable="MainTab_"+Samp[numSamp]+".txt";
path1=dir+"/"+dir3+"/"+titTable;
Ch=SphL;
BGformSphL=FnBGgraph(path1,Ch,titTable);

winN="Background calculation for "+ Ch;
if(isOpen(winN)) {
saveAs("Tiff", dir+"/"+dir4+"/"+winN+".tif");
close(winN+".tif");
}
}



if (bgCorrMainL==1) {
	
	titTable="MainTab_Step"+Stepnum+"_"+Samp[numSamp]+".txt";
path1=dir+"/"+dir3+"/"+titTable;
Ch=MainL;
BGformMainL=FnBGgraph(path1,Ch,titTable);

winN="Background calculation for "+ Ch;
if(isOpen(winN)) {
saveAs("Tiff", dir+"/"+dir4+"/"+winN+".tif");
close(winN+".tif");
}
}


if (bgCorrMain2L==1) {
	
	titTable="MainTab_Step"+Stepnum+"_"+Samp[numSamp]+".txt";
path1=dir+"/"+dir3+"/"+titTable;
Ch=Main2L;
BGformMain2L=FnBGgraph(path1,Ch,titTable);

winN="Background calculation for "+ Ch;
if(isOpen(winN)) {
saveAs("Tiff", dir+"/"+dir4+"/"+winN+".tif");
close(winN+".tif");
}
}
}


if (bgchN>0) {

for (kkb = 0; kkb < numSamp; kkb++) {

titTable="MainTab_"+Samp[kkb]+"_Step"+Stepnum+".txt"; 
path1=dir+"/"+dir3+"/"+titTable;

run("Table... ", "open=["+path1+"]");
CC0=newArray();

if (BGformSphL[2]<1) { 

CC=newArray();
AA = Table.getColumn("Area");
BB = Table.getColumn(SphL+"Int");
for (i=0; i<AA.length; i++){
         CC[i]=round(BB[i]-BGformSphL[0]-BGformSphL[1]*AA[i]);
}
Table.setColumn(SphL+"Int_After_BG", CC);
Table.update;

WhValS="Int_After_BG";


AA=CC0;
BB=CC0;
CC=CC0;
}

if (BGformMainL[2]<1) {

CC1=newArray();
AA = Table.getColumn("Area");
BB1 = Table.getColumn(MainL+"Int");
for (i=0; i<AA.length; i++){
         CC1[i]=round(BB1[i]-BGformMainL[0]-BGformMainL[1]*AA[i]);
}
Table.setColumn(MainL+"Int_After_BG", CC1);
Table.update;
WhValM="Int_After_BG";

AA=CC0;
BB1=CC0;
CC1=CC0;
}

if (BGformMain2L[2]<1) {

CC2=newArray();
AA = Table.getColumn("Area");
BB2 = Table.getColumn(Main2L+"Int");
for (i=0; i<AA.length; i++){
         CC2[i]=round(BB2[i]-BGformMain2L[0]-BGformMain2L[1]*AA[i]);
}
Table.setColumn(Main2L+"Int_After_BG", CC2);
Table.update;
WhValM2="Int_After_BG";

AA=CC0;
BB2=CC0;
CC2=CC0;
}

Table.save(path1);
close(titTable);


} // kkb



}
///////******END BG***////


//********* PART 3 - Results**********

if (Stepnum<2) {


for (kk = 0; kk < numSamp; kk++) {

titTable="MainTab_"+Samp[kk]+"_Step"+Stepnum+".txt";
path1=dir+"/"+dir3+"/"+titTable;

run("Table... ", "open=["+path1+"]");

x = Table.getColumn(NucL+"Int");
y = Table.getColumn(SphL+WhValS); //////


Array.getStatistics(x, min, max, mean, std);
dx1=min;
dx2=mean*3; //max
dx3=mean;
Array.getStatistics(y, min, max, mean, std);
dy1=min;
dy2=max;

borderS=dy1+0.03*(dy2-dy1);

borderG2=dx3;

borderG2e=dx2-0.1*(dx2-dx1);

borderG1=dx1+0.01*(dx2-dx1);


xx=newArray(dx1,dx2);
yy=newArray(borderS,borderS);

xxx=newArray(borderG2,borderG2);
xx11=newArray(borderG2e,borderG2e);
xx22=newArray(borderG1,borderG1);
yyy=newArray(dy1,dy2);

close(titTable);

Plot.create("Estimation of S and G2 phase for "+Samp[kk],  NucL, SphL);
     
       Plot.setLogScaleY(true);
       Plot.setLimits(dx1, dx2, dy1, dy2);
        Plot.setLineWidth(1);
        Plot.setColor("blue");
        Plot.add("circles", x, y);
        Plot.setLineWidth (2);
        Plot.setColor("#33cc00");
        Plot.add("line", xxx, yyy);
        Plot.addText("G1/G2 border (" +borderG2+")", 0.4, 0);
        Plot.setColor("#cc3366");
        Plot.add("line", xx, yy);
        Plot.addText("S border (" +borderS+")", 0.6, 0.65);
        Plot.setColor("#33cccc");
        Plot.add("line", xx11, yyy);
        Plot.addText("G2 border (" +borderG2e+")", 0.6, 0.2);
        Plot.setColor("#cc9933");
        Plot.add("line", xx22, yyy);
        Plot.addText("G1 border (" +borderG1+")", 0, 0);
        Plot.show();
        
        Dialog.create("S and G2 phase border correction for "+Samp[kk]);
Dialog.addMessage("Please, correct the values to separate S phase and G2 if needed (see the plot)", 16);
Dialog.addMessage("Values to separate S phase. Corresponds to RED line", 16, "#cc3366");
Dialog.addNumber("Add Y value for S phase border", borderS, 0, 20,"");
Dialog.addMessage("Values to separate G1 nad G2 phases. Corresponds to GREEN line", 16, "#33cc00");
Dialog.addNumber("Add first X value for G2 phase border", borderG2, 0, 20,"");
Dialog.addMessage("Values to separate G2 phase. Corresponds to BLUE line", 16, "#33cccc");
Dialog.addNumber("Add X second value for G2 phase border", borderG2e, 0, 20,"");
Dialog.addMessage("Values to separate G1 phase. Corresponds to YELLOW line", 16, "#cc9933");
Dialog.addNumber("Add X value for beginning of G1 phase border", borderG1, 0, 20,"");
Dialog.show();

borderS=Dialog.getNumber();
borderG2=Dialog.getNumber();
borderG2e=Dialog.getNumber();
borderG1=Dialog.getNumber();
        print(borderS);
        print(borderG2);
        print(borderG2e);
        print(borderG1);
         
 path2=dir+"/"+dir2+"/Log_"+Samp[kk]; 
 selectWindow("Log");      
        saveAs("Text", path2);
        
        close("Log");
        
 yy1=newArray(borderS,borderS);

xxx1=newArray(borderG2,borderG2);

xxx11=newArray(borderG2e,borderG2e);
xxx22=newArray(borderG1,borderG1);
 
     close("Estimation of S and G2 phase for "+Samp[kk]);  
     
       
   Plot.create("Estimation of S and G2 phase for "+Samp[kk],  NucL, SphL);
     
       Plot.setLogScaleY(true);
       Plot.setLimits(dx1, dx2, dy1, dy2);
        Plot.setLineWidth(1);
        Plot.setColor("blue");
        Plot.add("circles", x, y);
        Plot.setLineWidth (2);
        Plot.setColor("#33cc00");
        Plot.add("line", xxx1, yyy);
        Plot.addText("G1/G2 border (" +borderG2+")", 0.4, 0);
        Plot.setColor("#cc3366");
        Plot.add("line", xx, yy1);
        Plot.addText("S border (" +borderS+")", 0.6, 0.65);
        Plot.setColor("#33cccc");
        Plot.add("line", xxx11, yyy);
        Plot.addText("G2 border (" +borderG2e+")", 0.6, 0.2);
        Plot.setColor("#cc9933");
        Plot.add("line", xxx22, yyy);
        Plot.addText("G1 border (" +borderG1+")", 0, 0);
        Plot.show();        
   saveAs("Tiff", dir+"/"+dir4+"/Estimation of S and G2 phase for "+Samp[kk]+".tif");
     close("Estimation of S and G2 phase for "+Samp[kk]+".tif");
}// ENF FOR (kk)

for (kk = 0; kk < numSamp; kk++) { 


titTable2="Log_"+Samp[kk]+".txt";
path2=dir+"/"+dir2+"/"+titTable2;
run("Table... ", "open=["+path2+"]");
selectWindow(titTable2);
Sbord=Table.get("C1", 0);
Gbord=Table.get("C1", 1);
Gbord2=Table.get("C1", 2);
G1bord=Table.get("C1", 3);
close(titTable2);


titTable1="MainTab_"+Samp[kk]+"_Step"+Stepnum+".txt";
path1=dir+"/"+dir3+"/"+titTable1;

si=0;
gi=0;
g1i=0;





run("Table... ", "open=["+path1+"]");

nn=Table.size(titTable1);


for (i = 0; i < nn; i++) {
selectWindow(titTable1);
	
	dapi=Table.get(NucL+"Int", i);
	edu=Table.get(SphL+WhValS, i); /////////
	
	if ((edu>Sbord)&&(dapi<Gbord2)){
		Table.set("CCPh", i, "1_S");
		si=si+1;
	}
	
	if ((edu<Sbord)&&(dapi<Gbord2)&&(dapi>Gbord)) {
		Table.set("CCPh", i, "2_G2");
		gi=gi+1;
		
	}
	
	if ((edu<Sbord)&&(dapi>G1bord)&&(dapi<Gbord)) {
      Table.set("CCPh", i, "0_G1");
      g1i=g1i+1;
	}
	
Table.update;
}
Table.sort("CCPh");

Table.deleteRows(g1i+gi+si, nn);
Table.sort("Num");
Table.update;
Table.save(path1);

////
close(titTable1);
////
}
}
////************ END for PART 3 **********//



endScr=getTime();
TotTime=round((endScr-stTrScr)/60000);

Dialog.create("GAME OVER");
Dialog.addMessage("Quantification is over!", 20);
Dialog.addMessage("Total runing time was: "+TotTime+" min.", 20);
Dialog.addMessage("All files can be found here:"+dir);

Dialog.show();


///******FUNCTIONS****///

function FnChooseSize(){
	
	tmax="Max length of the objects";
mmax="Step 6 of 8 \nPlease, select the tool 'Line' and mark the Max length for objects \n (choose the bigest object)"; 
mmax1="Line need to be selected \n Please, choose the tool 'Line' and choose the Max length for objects \n (choose the bigest object)";      
        
    wh=0;    
while(wh==0){
	waitForUser(tmax, mmax);
	if(is("line")){
	run("Measure");
lngth=getResult("Length", 0);	
chMax=round(pow(lngth/2, 2)*3.14);

close("Results");
run("Select None");
wh=1;
}
}


tmin="Min length of the objects";
mmin="Step 7 of 8 \nThank you! Now, please, select the tool 'Line' and mark the Min length for objects \n (choose the smalest object)";       
mmix1="Line need to be selected \n Please, choose the tool 'Line' and choose the Min length for objects \n (choose the smalest object)"; 
        

wh=0;    
while(wh==0){
	waitForUser(tmin, mmin);
	if(is("line")){
	run("Measure");
chMin=round(pow(getResult("Length", 0)/2, 2)*3.14);
close("Results");
run("Select None");
wh=1;
}
}


return newArray(chMax,chMin,lngth);

}

function FnThresh(NucL){
run("Threshold...");
tt="Adjusting threshold manually";
mm="Please, adjust the Threshold using slidebares and press ok";       
        waitForUser(tt, mm);

        getThreshold(lower,upper);
        close("Threshold");
        if (isOpen("B&C")) {

        close("B&C");
        }
        selectWindow(NucL);
        close();
        return newArray(lower,upper);
}

function FnBGgraph(path1,Ch,titTable){
run("Table... ", "open=["+path1+"]");

x = Table.getColumn("Area");
y = Table.getColumn(Ch+"Int");

close(titTable);

// Do a straight line fit
  Fit.doFit("Straight Line", x, y);
  a=d2s(Fit.p(0),6);
  b=d2s(Fit.p(1),6);
  //print(a, b);

 Fit.plot();
 rename("Background calculation for "+ Ch);
 Plot.setXYLabels("Area", Ch);
        
        Dialog.create("Background calculation for "+Ch);
Dialog.addMessage("Please, check the Background calculation (see the plot)", 16);
Dialog.addMessage("If you don't want to use the suggested background formula tick the box Don't use", 16, "#cc3366");
Dialog.addCheckbox("Don't use", 0);
Dialog.show();

BgUse=Dialog.getCheckbox();

return newArray(a,b,BgUse);
}