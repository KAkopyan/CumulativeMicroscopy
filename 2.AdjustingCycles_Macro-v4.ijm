//**************************//
// Custom-made script for ImageJ (Part 2)
// Multiplex imaging using cumulative microscopy
// Akopyan et al.
// Department of Cell and Molecular Biology
// Karolinska Institutet
//*************************//

//**************//
// 1. This script sould be run after running the Main script: "1.Cumulative_IF_Main_Macro-v4.ijm"
// 2. This script will ask you to choose the directory.
//    Please, choose the Directory that conatns folders Graphs, Log and Tables (created by the Main script)
// 3. The script will adjust the data from imaging cycles into one Main table
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
Dialog.addMessage("Step 1 of 3 \n Please specify the number of the Cycles and the number of the Samples.", 16);
Dialog.addNumber("The number of the Cycles", Stepnum, 0, 2,"(How many Cycles should be adjusted)");
Dialog.addMessage("\n", 16);
Dialog.addNumber("The number of the Samples", numSamp, 0, 2,"");
Dialog.addMessage("\nNext you will be asked to choose MAIN folder where the folders Graphs, Log and Tables (created by the Main script) are located.", 16);
Dialog.addMessage("NOTE: The txt data files for every Sample should be in folder named Table (created by the Main script)", 14, "#cc3300");
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

Dialog.addMessage("Step 2 of 3 \nPlease add names for your samples.", 20);
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
if (File.exists(dir+"/MainTab_"+Samp[i]+"_Step1.txt")) {
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


//////********////////
Dialog.create("Channels");
Dialog.addMessage("Step 3 of 3 \nPlease, add specific parameters for your experiment.", 20);
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
	
	//////********////////	






/////////////*************

	disX=18; //12 or 18
	disY=20; //15 or 20
	difA=0.25; //0.25 or 0.4
	
///////////////**************
stTrScr=getTime();

for (i = 0; i < numSamp; i++) {


//titTable="MainTab_"+Samp[i]+"_Step"+Stepnum;


titTable="MainTab_"+Samp[i]+".txt";

Table.create(titTable);
	//Table.setColumn("Slice");
	Table.setColumn("Num");
	Table.setColumn("CCPh");
	Table.setColumn("X");
	Table.setColumn("Y");
	Table.setColumn("Area1");
	Table.setColumn(NucL+"Mean");
	Table.setColumn(SphL+"Mean");
	Table.setColumn(NucL+"Int");
	Table.setColumn(SphL+"Int");
	Table.setColumn(MainL+"Mean");
	Table.setColumn(Main2L+"Mean");
	Table.setColumn(MainL+"Int");
	Table.setColumn(Main2L+"Int");
	
	Table.setColumn("Area2");
	Table.setColumn(MainL2+"Mean");
	Table.setColumn(Main2L2+"Mean");
	Table.setColumn(MainL2+"Int");
	Table.setColumn(Main2L2+"Int");
	
	if (NumOfSteps==3) {

	Table.setColumn("Area3");
	Table.setColumn(MainL3+"Mean");
	Table.setColumn(Main2L3+"Mean");
	Table.setColumn(MainL3+"Int");
	Table.setColumn(Main2L3+"Int");
	}
	
	tpath=dir+"/"+titTable;
	Table.save(tpath);


titTable1="MainTab_"+Samp[i]+"_Step1.txt";
tpath1=dir+"/"+titTable1;

run("Table... ", "open=["+tpath1+"]");

num=Table.size;

titTable2="MainTab_"+Samp[i]+"_Step2.txt";
tpath2=dir+"/"+titTable2;
run("Table... ", "open=["+tpath2+"]");
num2=Table.size;

////****

SliceNumStep2=newArray();
nachSl=0;
	selectWindow(titTable2);
	for (n = 0; n < num2; n++) {
		nachS=Table.get("Slice", n);
		if (nachS>nachSl) {
			SliceNumStep2[nachS]=n;
			nachSl=nachS;
		}

	}
	


////***

if (NumOfSteps==3) {
titTable3="MainTab_"+Samp[i]+"_Step3.txt";
tpath3=dir+"/"+titTable3;
run("Table... ", "open=["+tpath3+"]");
num3=Table.size;

////****

SliceNumStep3=newArray();
nachSl=0;
	selectWindow(titTable3);
	for (n = 0; n < num3; n++) {
		nachS=Table.get("Slice", n);
		if (nachS>nachSl) {
			SliceNumStep3[nachS]=n;
			nachSl=nachS;
		}

	}
	


////***


}



cnm=0;
for (k = 0; k < num; k++) { /// For1

selectWindow(titTable1);
Slice1=Table.get("Slice", k);
X1=Table.get("X", k);
Y1=Table.get("Y", k);
Area1=Table.get("Area", k);

ch1M=Table.get(MainL+"Mean", k);
ch2M=Table.get(Main2L+"Mean", k);
ch1I=Table.get(MainL+"Int", k);
ch2I=Table.get(Main2L+"Int", k);


dapiM=Table.get(NucL+"Mean", k);
eduM=Table.get(SphL+"Mean", k);
dapiI=Table.get(NucL+"Int", k);
eduI=Table.get(SphL+"Int", k);
ccph=Table.getString("CCPh", k);



for (kk = SliceNumStep2[Slice1]; kk < num2; kk++) { /// For2

	selectWindow(titTable2);
Slice2=Table.get("Slice", kk);
X2=Table.get("X", kk);
Y2=Table.get("Y", kk);
Area2=Table.get("Area", kk);

ch1M2=Table.get(MainL2+"Mean", kk);
ch2M2=Table.get(Main2L2+"Mean", kk);
ch1I2=Table.get(MainL2+"Int", kk);
ch2I2=Table.get(Main2L2+"Int", kk);

if (Slice1<Slice2) {
		kk=num2;
	}	
	

if ((Slice1==Slice2) && (Math.abs(X1-X2)<disX) && (Math.abs(Y1-Y2)<disY) && (Math.abs(Area1-Area2)/Area1<difA)){

if (NumOfSteps==3) {

		
for (kkk = SliceNumStep3[Slice1]; kkk < num3; kkk++) { /// For3

	selectWindow(titTable3);
Slice3=Table.get("Slice", kkk);
X3=Table.get("X", kkk);
Y3=Table.get("Y", kkk);
Area3=Table.get("Area", kkk);

ch1M3=Table.get(MainL3+"Mean", kkk);
ch2M3=Table.get(Main2L3+"Mean", kkk);
ch1I3=Table.get(MainL3+"Int", kkk);
ch2I3=Table.get(Main2L3+"Int", kkk);

if (Slice1<Slice3) {
		kkk=num3;
	}

if ((Slice1==Slice3) && (Math.abs(X1-X3)<disX) && (Math.abs(Y1-Y3)<disY) && (Math.abs(Area1-Area3)/Area1<difA)) {
	
selectWindow(titTable);	

	Table.set("Num", cnm, cnm+1);
	Table.set("CCPh", cnm, ccph);
	Table.set("X", cnm, X1);
	Table.set("Y", cnm, Y1);
	Table.set("Area1", cnm, Area1);
	Table.set(NucL+"Mean", cnm, dapiM);
	Table.set(SphL+"Mean", cnm, eduM);
	Table.set(NucL+"Int", cnm, dapiI);
	Table.set(SphL+"Int", cnm, eduI);
	Table.set(MainL+"Mean", cnm, ch1M);
	Table.set(Main2L+"Mean", cnm, ch2M);
	Table.set(MainL+"Int", cnm, ch1I);
	Table.set(Main2L+"Int", cnm, ch2I);
	
	Table.set("Area2", cnm, Area2);
	Table.set(MainL2+"Mean", cnm, ch1M2);
	Table.set(Main2L2+"Mean", cnm, ch2M2);
	Table.set(MainL2+"Int", cnm, ch1I2);
	Table.set(Main2L2+"Int", cnm, ch2I2);
	
	Table.set("Area3", cnm, Area3);
	Table.set(MainL3+"Mean", cnm, ch1M3);
	Table.set(Main2L3+"Mean", cnm, ch2M3);
	Table.set(MainL3+"Int", cnm, ch1I3);
	Table.set(Main2L3+"Int", cnm, ch2I3);	
	
	Table.update;
	
	cnm++;
	kkk=num3;
	kk=num2;
} // end IF
	
} // end For3

}
else {
	selectWindow(titTable);	

	Table.set("Num", cnm, cnm+1);
	Table.set("CCPh", cnm, ccph);
	Table.set("X", cnm, X1);
	Table.set("Y", cnm, Y1);
	Table.set("Area1", cnm, Area1);
	Table.set(NucL+"Mean", cnm, dapiM);
	Table.set(SphL+"Mean", cnm, eduM);
	Table.set(NucL+"Int", cnm, dapiI);
	Table.set(SphL+"Int", cnm, eduI);
	Table.set(MainL+"Mean", cnm, ch1M);
	Table.set(Main2L+"Mean", cnm, ch2M);
	Table.set(MainL+"Int", cnm, ch1I);
	Table.set(Main2L+"Int", cnm, ch2I);
	
	Table.set("Area2", cnm, Area2);
	Table.set(MainL2+"Mean", cnm, ch1M2);
	Table.set(Main2L2+"Mean", cnm, ch2M2);
	Table.set(MainL2+"Int", cnm, ch1I2);
	Table.set(Main2L2+"Int", cnm, ch2I2);
	
	Table.update;
	
	cnm++;
	kk=num2;
	
}

	
		
				
} // end IF


	
	
} //End For2




} /// End For1
selectWindow(titTable);	
Table.save(tpath);
close(titTable);

close(titTable1);
close(titTable2);
if (NumOfSteps==3) {
close(titTable3);
}
//print(dir);
} // For numSamp

endScr=getTime();
TotTime=round((endScr-stTrScr)/60000);

Dialog.create("GAME OVER");
Dialog.addMessage("Quantification is over!", 20);
Dialog.addMessage("Total runing time was: "+TotTime+" min.", 20);
Dialog.addMessage("All files can be found here:"+dir);

Dialog.show();