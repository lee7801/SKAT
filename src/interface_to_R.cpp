/*************************************************************
 *
 * Moving window project 
 * File: interface_to_R.cpp	
 * Date: Jan 14, 2011
 * Author: Larissa Miropolsky
 *
 * Description:
 *   Inteface to R
 *
 **************************************************************/

//#include <R.h>


#include "bed_reader.h"
#include "mwo_reader.h"
#include "setid_bim_index.h"

static BedFileReader* MW = NULL;
static MwoFileReader* MWA_FILE_ID = NULL;
static Hasht* hash_table = NULL;


//	Interface definition.
//	* indicates return value
//===============================================================
//	1. Generate MWA Files
//===============================================================
//Generate_MWA_MovingWindow(Bim, Bed,WindowSize,Overlap, MWA_File)
	//Generate MWA file using moving windows. 
	//Bim : Bim file name
	//Bed : Bed file name
	//WindowSize : Window Size (bp)
	//Overlap : Overlap (bp)
	//MWA_File : MWA file name which will be generated

//USAGE FROM R:
//Generate_MWA_MovingWindow(bed_file, bim_file, fam_file, mwa_file, win_size, ovrlp_size);
//Kill_MWA_MovingWindow();

void Generate_MWA_MovingWindow(char* Bed, char* Bim, char* Fam, 
							   char* Mwa,
							   int WindowSize, int Overlap , char* Info,  int* myerror) 
{
	MW = new BedFileReader(Bed, Bim, Fam, Mwa, WindowSize, Overlap, 1, myerror, Info);
}

void Kill_MWA_MovingWindow() 
{
	delete MW;
}
//===============================================================
//Generate_MWA_SetID_File(Bim, Bed, SetID_File)
	//Generate MWA file from SetID file. 
	//Bim : Bim file name
	//Bed : Bed file name
	//SetID_File : Set ID file. The first column is setid, and the second column is snp id

//USAGE FROM R:
//Generate_MWA_SetID_File(Bed, Bim, Fam, SetID, Mwa);
//Kill_MWA_SetID_File();

void Generate_MWA_SetID_File(char* Bed, char* Bim, char* Fam, 
							 char* SetID, char* Mwa, char* Info, int* myerror) 
{

	hash_table = new Hasht (SetID, Bim, Mwa, myerror);
	if(*myerror != 0)
		return;
	MW = new BedFileReader(Bed,Bim,Fam,Mwa,hash_table,myerror,Info );
}

void Kill_MWA_SetID_File()
{

	if(MW != NULL){
		delete MW;
	}
	if(hash_table != NULL){
		delete hash_table;
	}
}
//===============================================================
//===============================================================
//===============================================================
//===============================================================
//	2. Open and Close MWA Files
//===============================================================
//Open_MWA(MWA_File, *MWA_File_ID)
	//Open an existing MWA file. It returns MWA_File_ID
	//MWA_File_Path : MWA File Name
	//MWA_File_ID : integer value of file ID. 

//USAGE FROM R:
//Open_MWA(MWA_File, MWA_FILE_ID)

void Open_MWA(char* MWA_File, char* Info, int* myerror)
{
	//it will take also "CEU.bed.INFO.txt" from same place - both of them shoul be existed
	//MWA_FILE_ID = new MwoFileReader(MWA_File); 
	MWA_FILE_ID = new  MwoFileReader(MWA_File, myerror, Info); 

}

//===============================================================
//Close_MWA(MWA_FILE_ID)
	//Close the opened MWA file 
	//MWA_File_D : integer value of file ID.

//USAGE FROM R:
//Open_MWA(MWA_File);
//Close_MWA();
void Close_MWA() 
{
	delete MWA_FILE_ID;
}
//===============================================================
//===============================================================
//===============================================================
//===============================================================
//	3. Get DATA from MWA files
//===============================================================
	
//Get_TotalNumberofSets(MWA_FILE_ID, *Total_Num_SNPSets)
	//Return Total number of SNP Sets
	//MWA_File_ID : integer value of file ID. 
	//Total_Num_SNPSets : Total Number of SNP Sets in the MWA file. 


//USAGE FROM R:
//Open_MWA(MWA_File);
//int Total_Num_SNPSets;
//Get_TotalNumberofSets(&Total_Num_SNPSets);

void Get_TotalNumberofSets(int* Total_Num_SNPSets)
{
	MWA_FILE_ID->get_TotalNumberofSets(Total_Num_SNPSets);
}
//===============================================================
	
//Get_TotalNumberofSNPs(MWA_FILE_ID, *Total_Num_SNP)
	//Return Total number of SNP
	//MWA_File_ID : integer value of file ID. 
	//Total_Num_SNP : Total Number of SNPs in the MWA file. 

//USAGE FROM R:
//Open_MWA(MWA_File)
//int* Total_Num_SNP
//Get_TotalNumberofSNPs(Total_Num_SNP)

void Get_TotalNumberofSNPs(int* Total_Num_SNP)
{
	MWA_FILE_ID->get_TotalNumberofSNPs(Total_Num_SNP);
}

//===============================================================
//Get total number of individuals
//Get_TotalNumberofInd(MWA_FILE_ID, *Total_Num_IND) 
	//Return Total number of IND
	//MWA_File_ID : integer value of file ID. 
	//Total_Num_SNP : Total Number of individuals in the MWA file. 

//USAGE FROM R:
//Open_MWA(MWA_File)
//int Total_Num_IND;
//Get_TotalNumberofInd(&Total_Num_IND)

void Get_TotalNumberofInd( int* Total_Num_IND)
{
	MWA_FILE_ID->get_TotalNumberofInd(Total_Num_IND);
}



//===============================================================
//You can see it in automatically generated INFO file  ==== Get_TotalNumberofSets  use 1...Total_Num_SNPSets

//Get_SetID(MWA_FILE_ID, *SetIDs)
	//Return a vector of all of SetIDs in the MWA file
	//MWA_File_ID : integer value of file ID. 
	//SetIDs : a vector of SetIDs in the MWA file

//USAGE FROM R:
//MwoFileReader* MWA_FILE_ID;
//Open_MWA(MWA_File, MWA_FILE_ID)



//===============================================================
	
//Get_NumberofSnps(MWA_FILE_ID, SetID,*Num_SNP)
	//Return a number of SNPs in the given SNP Set. 
	//MWA_File_ID : integer value of file ID. 
	//SetID : SetID
	//Num_SNP : number of SNPs in the given SNP Set. 

//USAGE FROM R:
//MwoFileReader* MWA_FILE_ID;
//Open_MWA(MWA_File, MWA_FILE_ID)

void Get_NumberofSnps(int SetID,int *Num_SNP, int* myerror)
{
	MWA_FILE_ID->get_NumberofSnps( SetID, Num_SNP, myerror);
} 

//===============================================================

//RETURN ONE LONG ARRAY - IT WILL BE MATRIX IN R
	
//Get_Genotypes(MWA_FILE_ID, SetID,*Z)
	//Return a genotype matrix of the given SNPSet
	//MWA_File_ID : integer value of file ID. 
	//SetID : SetID
	//Z : Genotype matrix (row: individual, column: SNP) of the SNP sets. 
	//0,1,2 for AA, Aa, and aa. 9 represents missing. 

//USAGE FROM R:
//MwoFileReader* MWA_FILE_ID;
//Open_MWA(MWA_File, MWA_FILE_ID)

void Get_Genotypes( int Set_number, int* Z,int size, int Is_MakeFile, int* myerror) // set_number base on INFO file. The result will be printed to file.
{
	MWA_FILE_ID->get_set(Set_number, Z, size, myerror, Is_MakeFile); //some integer - enter the value base on CEU.bed.INFO.txt
}	

//===============================================================
