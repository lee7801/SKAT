/*************************************************************
 *
 * Moving window project 
 * File: interface_to_R.h	
 * Date: Jan 14, 2011
 * Author: Larissa Miropolsky
 *
 * Description:
 *   Inteface to R
 *
 **************************************************************/
#ifndef _INTERFACE_TO_R_H        
#define _INTERFACE_TO_R_H 

void Generate_MWA_MovingWindow(char* Bed, char* Bim, char* Fam, 
							   char* Mwa, 
							   int WindowSize, int Overlap , char* Info , int* Myerror );
void Kill_MWA_MovingWindow();

void Generate_MWA_SetID_File(char* Bed, char* Bim, char* Fam, char* SetID, char* Mwa, char* Info, int* Myerror );
void Kill_MWA_SetID_File();

void Open_MWA(char* MWA_File, char* Info, int* Myerror); 
void Close_MWA();

void Get_TotalNumberofSets(int* Total_Num_SNPSets);
void Get_TotalNumberofSNPs(int* Total_Num_SNP);
void Get_TotalNumberofInd(int* Total_Num_IND);
void Get_NumberofSnps(int SetID,int *Num_SNP, int* Myerror);
void Get_Genotypes( int Set_number, int* Z,int size, int Is_MakeFile, int* Myerror );

#endif //_INTERFACE_TO_R_H
