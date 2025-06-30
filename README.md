Custom-made script for ImageJ (Part 1)
// Multiplex imaging using cumulative microscopy
// Akopyan et al.
// Department of Cell and Molecular Biology
// Karolinska Institutet

// This script is for Image J (FIJI) version V1.53q or later 

// 1.Cumulative_IF_Main_Macro-v4.ijm
// 1. Open in Image J (FIJI)
// 2. Run
//************//

// 2.AdjustingCycles_Macro_v3.ijm
// 1. This script sould be run after running the Main script: "1.Cumulative_IF_Main_Macro-v4.ijm"
// 2. This script will ask you to choose the directory.
//    Please, choose the Directory that conatns folders Graphs, Log and Tables (created by the Main script)
// 3. The script will adjust the data from imaging cycles into one Main table
// 4. The max number of Cycles that can be adjusted by this script is 3. For more samples, the script should be modified
//************//

// 3.Final_Table_Macro-v3.ijm
// 1. This script sould be run after running the Main script (Part 1): "1.Cumulative_IF_Main_Macro-v4.ijm" and adjusting script (Part 2): "2.AdjustingCycles_Macro_v3.ijm"
// 2. This script will ask you to choose the directory.
//    Please, choose the Directory that conatns folders Graphs, Log and Tables (created by the Main script)
// 3. The script will make FInal table for all data
// 4. The max number of Cycles that can be adjusted by this script is 3. For more samples, the script should be modified
//************//
