//**************************//
// Custom-made script for ImageJ (Part 3)
// Multiplex imaging using cumulative microscopy
// Akopyan et al.
// Department of Cell and Molecular Biology
// Karolinska Institutet
//*************************//

//**************//
// 1. This script sould be run after running the Main script (Part 1): "1.Cumulative_IF_Main_Macro-v4.ijm" and adjusting script (Part 2): "2.AdjustingCycles_Macro_v3.ijm"
// 2. This script will ask you to choose the directory.
//    Please, choose the Directory that conatns folders Graphs, Log and Tables (created by the Main script)
// 3. The script will make FInal table for all data
// 4. The max number of Cycles that can be adjusted by this script is 3. For more samples, the script should be modified
//************//

//**************//
// 1. This script is for Image J (FIJI) version V1.53q or later 
// 2. Open the script in Image J (FIJI)
// 3. Run
//************//

numSamp=1; //
Stepnum=1;//

Dialog.create("Specify folder with Data");
Dialog.addMessage("Step 1 of 4 \n Please specify the number of the Cycles and the number of the Samples.", 16);
Dialog.addNumber("The number of the Cycles", Stepnum, 0, 2,"(How many Cycles should be adjusted)");
Dialog.addMessage("\n", 16);
Dialog.addNumber("The number of the Samples", numSamp, 0, 2,"");
Dialog.addMessage("\nNext you will be asked to choose MAIN folder where the folders Graphs, Log and Tables (created by the Main script) are located.", 16);
Dialog.addMessage("NOTE: The txt data files for every Sample should be in folder named Table (created by the Adjusting script)", 14, "#cc3300");
Dialog.show();

NumOfSteps=Dialog.getNumber();
numSamp=Dialog.getNumber();

dirI=getDirectory("Choose directory with Files! "); //

dir=dirI+"Tables";

//***********************
checkForFolder=0
Samp=newArray(numSamp);
try=0;
while (checkForFolder<numSamp) {

checkForFolder=0;	
	
Dialog.create("Settings");
if (try==0) {

Dialog.addMessage("Step 2 of 4 \nPlease add names for your samples.", 20);
}else {
	Dialog.addMessage("Errore! The Table for one or more samples not found", 20, "#FF3300");
	Dialog.addMessage("Please, add correct names for your samples.", 20);
}
Dialog.addMessage("NOTE: The sample name should be identical to the sample name added when running the Main script", 14, "#cc3300");
Dialog.addMessage("", 14);

for (i = 0; i < numSamp-1; i++) {
	Dialog.addString(""+i+1+" Sample name", "Sample"+i+1+"");
	Dialog.addMessage("", 14);
	}
	Dialog.addString(""+i+1+" Sample name", "Sample"+i+1+"");
	Dialog.addMessage("", 14);
		
Dialog.show();


for (i = 0; i < numSamp; i++) {
Samp[i]=Dialog.getString();	
}

for (i = 0; i < numSamp; i++) {
if (File.exists(dir+"/MainTab_"+Samp[i]+".txt")) {
	checkForFolder=checkForFolder+1;
}
}
try=1;
}//end for while
	


//************************

NucL="DAPI";
SphL="EdU";
MainL="yH2AX";
Main2L="pTCTP";

MainL2="Plk1";
Main2L2="CycA";

MainL3="p53";
Main2L3="p21";

Dialog.create("Channels");
Dialog.addMessage("Step 3 of 4 \nPlease, add specific parameters for your experiment.", 20);
Dialog.addString("Nuclear lable (for ex., DAPI)", NucL);
Dialog.addString("S phase lable (for ex., EdU )", SphL);
Dialog.addString("1. lable (for ex., yH2AX)", MainL);
Dialog.addString("2. lable (for ex., pTCTP )", Main2L);
Dialog.addString("3. lable (for ex., Plk1)", MainL2);
Dialog.addString("4. lable (for ex., CycA )", Main2L2);

if (NumOfSteps==3) {
Dialog.addString("5. lable (for ex., p53)", MainL3);
Dialog.addString("6. lable (for ex., p21 )", Main2L3);
}

Dialog.show();

NucL=Dialog.getString(); // Nuclear lable (for ex., DAPI)
SphL=Dialog.getString(); // S phase lable (for ex., EdU)
MainL=Dialog.getString(); // Main lable (for ex., yH2AX)
Main2L=Dialog.getString(); // 2nd Main lable (for ex., pTCTP)
MainL2=Dialog.getString(); // 2nd Main lable (for ex., Plk1)
Main2L2=Dialog.getString(); // 2nd Main lable (for ex., CycA)

if (NumOfSteps==3) {
MainL3=Dialog.getString(); // 2nd Main lable (for ex., p53)
Main2L3=Dialog.getString(); // 2nd Main lable (for ex., p21)	
}


//////
Ach1st1=0;
Bch1st1=1;
Ach2st1=0;
Bch2st1=1;
Ach1st2=0;
Bch1st2=1;
Ach2st2=0;
Bch2st2=1;
Ach1st3=0;
Bch1st3=1;
Ach2st3=0;
Bch2st3=1;
	
///////////////**************
Dialog.create("Correction");
Dialog.addMessage("Step 4 of 4 \nPlease, add specific parameters according to (y = A + Bx)", 20);
Dialog.addNumber("1. Value A for Channel 1 Cycle 1", Ach1st1, 0, 8,"");
Dialog.addNumber("2. Value B for Channel 1 Cycle 1", Bch1st1, 0, 8,"");
Dialog.addNumber("3. Value A for Channel 2 Cycle 1", Ach2st1, 0, 8,"");
Dialog.addNumber("4. Value B for Channel 2 Cycle 1", Bch2st1, 0, 8,"");
Dialog.addNumber("5. Value A for Channel 1 Cycle 2", Ach1st2, 0, 8,"");
Dialog.addNumber("6. Value B for Channel 1 Cycle 2", Bch1st2, 0, 8,"");
Dialog.addNumber("7. Value A for Channel 2 Cycle 2", Ach2st2, 0, 8,"");
Dialog.addNumber("8. Value B for Channel 2 Cycle 2", Bch2st2, 0, 8,"");

if (NumOfSteps==3) {
Dialog.addNumber("9. Value A for Channel 1 Cycle 3", Ach1st2, 0, 8,"");
Dialog.addNumber("10. Value B for Channel 1 Cycle 3", Bch1st2, 0, 8,"");
Dialog.addNumber("11. Value A for Channel 2 Cycle 3", Ach2st2, 0, 8,"");
Dialog.addNumber("12. Value B for Channel 2 Cycle 3", Bch2st2, 0, 8,"");
}

Dialog.show();

Ach1st1=Dialog.getNumber();
Bch1st1=Dialog.getNumber();
Ach2st1=Dialog.getNumber();
Bch2st1=Dialog.getNumber();
Ach1st2=Dialog.getNumber();
Bch1st2=Dialog.getNumber();
Ach2st2=Dialog.getNumber();
Bch2st2=Dialog.getNumber();


if (NumOfSteps==3) {
Ach1st3=Dialog.getNumber();
Bch1st3=Dialog.getNumber();
Ach2st3=Dialog.getNumber();
Bch2st3=Dialog.getNumber();
}






////////********
stTrScr=getTime();

for (i = 0; i < numSamp; i++) {


//titTable="MainTab_"+Samp[i]+"_Step"+Stepnum;


titTable="FinalTab_"+Samp[i]+".txt";

Table.create(titTable);
	Table.setColumn("Num");
	Table.setColumn("CCPh");
	Table.setColumn("Area");
	Table.setColumn(NucL);
	Table.setColumn(SphL);
	Table.setColumn(MainL);
	Table.setColumn(Main2L);
	Table.setColumn(MainL2);
	Table.setColumn(Main2L2);
	if (NumOfSteps==3) {
	Table.setColumn(MainL3);
	Table.setColumn(Main2L3);
	}
	
	tpath=dir+"/"+titTable;
	Table.save(tpath);


titTable1="MainTab_"+Samp[i]+".txt";
tpath1=dir+"/"+titTable1;

run("Table... ", "open=["+tpath1+"]");

num=Table.size;

for (k = 0; k < num; k++) { /// For1

selectWindow(titTable1);
num1=Table.get("Num", k);
ccph=Table.getString("CCPh", k);
Area1=Table.get("Area1", k);
dapiI=Table.get(NucL+"Int", k);
eduI=Table.get(SphL+"Int", k);
ch1I=Table.get(MainL+"Int", k);
ch2I=Table.get(Main2L+"Int", k);
ch1I2=Table.get(MainL2+"Int", k);
ch2I2=Table.get(Main2L2+"Int", k);
if (NumOfSteps==3) {
ch1I3=Table.get(MainL3+"Int", k);
ch2I3=Table.get(Main2L3+"Int", k);
}
//// BG calculation
bgch1st1=round(Ach1st1+Bch1st1*Area1);
bgch2st1=round(Ach2st1+Bch2st1*Area1);
bgch1st2=round(Ach1st2+Bch1st2*ch1I);
bgch2st2=round(Ach2st2+Bch2st2*ch2I);
if (NumOfSteps==3) {
bgch1st3=round(Ach1st3+Bch1st3*ch1I2);
bgch2st3=round(Ach2st3+Bch2st3*ch2I2);
}
/////


selectWindow(titTable);

	Table.set("Num", k, num1);
	Table.set("CCPh", k, ccph);
	Table.set("Area", k, Area1);
	Table.set(NucL, k, dapiI);
	Table.set(SphL, k, eduI);
	Table.set(MainL, k, ch1I-bgch1st1);
	Table.set(Main2L, k, ch2I-bgch2st1);
	Table.set(MainL2, k, ch1I2-bgch1st2);
	Table.set(Main2L2, k, ch2I2-bgch2st2);
	if (NumOfSteps==3) {
	Table.set(MainL3, k, ch1I3-bgch1st3);
	Table.set(Main2L3, k, ch2I3-bgch2st3);	
	}
	Table.update;

}
selectWindow(titTable);	
Table.save(tpath);
close(titTable);

close(titTable1);

}

endScr=getTime();
TotTime=round((endScr-stTrScr)/60000);

Dialog.create("GAME OVER");
Dialog.addMessage("Quantification is over!", 20);
Dialog.addMessage("Total runing time was: "+TotTime+" min.", 20);
Dialog.addMessage("All files can be found here:"+dir);

Dialog.show();