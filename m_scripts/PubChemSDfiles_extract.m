%% PubChemSDfiles_extract
% Extract data from PubChem SDfiles using a text-based approach

% Vincent F. Scalfani, Serena C. Ralph, and Jason E. Bara 
% The University of Alabama
% Version: 1.0, created with MATLAB R2018a

%{
Overall Description

    1. Read PubChem Compound SDfiles into MATLAB Workspace as text
    2. Extract the PubChem data using the MATLAB extractBetween function
    3. Combine data into a table
    4. Write new tab text files containing extracted data
%}
%% Change directory to location of SDfiles

% prompt user to select folder with SDfiles
SDfiles_folder = uigetdir;

% change directory to selected folder
cd(SDfiles_folder)
%% *Load a Sample PubChem SDfile with one compound to view data fields*

SDF_text_view = fileread('PubChemSDF01.sdf')
%% *Extract Data from SDfiles*

% Create a directory for SDfile names
SDfile_directory = dir('*.sdf');

% Display names of SDfiles for reference
display_SDfile_names = extractfield(SDfile_directory,'name')
% Process the SDfiles in a loop and write a new text file
% with extracted data

for SDfile = SDfile_directory'
    fprintf(1,'Extracting PubChem Data from %s\n', SDfile.name)

    % 1. Read PubChem SDfiles into MATLAB Workspace as text
    SDfile_text = fileread(SDfile.name);
    
    % 2. Extract the PubChem data using the MATLAB extractBetween 
    % function. The extractBetween function extracts data between
    % an indicated SDfile data header and field 
    % (e.g.,'> <PUBCHEM_COMPOUND_CID>') and the start of a new 
    % data header and field (e.g., '> <')
  
    % N.B. You can extract as many data values as necessary, 
    % however be sure to extract the data in the order that the 
    % data fields appear in the SDfile when reading the SDfile
    % from top to bottom.
    
    % in this example, we will extract values associated with:
    
    % > <PUBCHEM_COMPOUND_CID>
    % > <PUBCHEM_IUPAC_INCHIKEY>
    % > <PUBCHEM_MOLECULAR_FORMULA>
    % > <PUBCHEM_MOLECULAR_WEIGHT>
    % > <PUBCHEM_OPENEYE_CAN_SMILES>
    
    CID = extractBetween(SDfile_text, '> <PUBCHEM_COMPOUND_CID>', '> <');
    % delete any leading and trailing whitespace
    CID = strtrim(CID);
    
    IK = extractBetween(SDfile_text, '> <PUBCHEM_IUPAC_INCHIKEY>', '> <');
    IK = strtrim(IK);
    
    MF = extractBetween(SDfile_text, '> <PUBCHEM_MOLECULAR_FORMULA>', '> <');
    MF = strtrim(MF);
    
    MW = extractBetween(SDfile_text, '> <PUBCHEM_MOLECULAR_WEIGHT>', '> <');
    MW = strtrim(MW);
    
    Can_SMI = extractBetween(SDfile_text, '> <PUBCHEM_OPENEYE_CAN_SMILES>', '> <');
    Can_SMI = strtrim(Can_SMI);
    
    % 3. Combine data into a table
    SDfile_data = [Can_SMI CID IK MF MW];
    SDfile_data = cell2table(SDfile_data, 'VariableNames', {'PUBCHEM_OPENEYE_CAN_SMILES',...
        'PUBCHEM_COMPOUND_CID','PUBCHEM_IUPAC_INCHIKEY','PUBCHEM_MOLECULAR_FORMULA',...
        'PUBCHEM_MOLECULAR_WEIGHT'});
    
    % 4. Write new tab text files containing extracted data
    
    % replace .sdf extension in file name with .txt
    txt_filename_ext = strrep(SDfile.name,'.sdf','.txt');
    txt_filename = ['extracted_' txt_filename_ext];
    
    fprintf(1,'Saving as %s\n',txt_filename)
    writetable(SDfile_data, txt_filename,'FileType','Text', 'Delimiter','tab','WriteVariableNames', true)
   
end