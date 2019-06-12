%% PubChem_SDQ_LitSearch
% Search PubChem for PubMed, Patent, Springer Nature, and Thieme Literature 
% associated with a CID

% Vincent F. Scalfani, Serena C. Ralph, Ali Al Alshaikh, and Jason E. Bara 
% The University of Alabama
% Version: 1.0, created with MATLAB R2018a

% N.B. PubChem SDQ is used internally by PubChem webpages and is still 
% being rapidly developed.

%% Define the PubChem API and SDQ agent base URL

% PubChem API
api = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/';

% PubChem SDQ agent
sdq = 'https://pubchem.ncbi.nlm.nih.gov/sdq/sdqagent.cgi?outfmt=json&query=';

% set a longer web options timeout and json output
options = weboptions('Timeout', 60, 'ContentType','json');

% Retrieve and display PNG Image of Simvastatin; CID = 54454
CID_query = '54454';
CID_query_url = [api CID_query '/PNG'];
[CID_img,map] = imread(CID_query_url);
imshow(CID_img,map);
%% 
% _Replace the above CID value (CID) with a different CID number to customize_
%% Explore Total Literature and Data Counts

% Retrieve total count of associated literature references
litCountQ_url = [sdq '{"hide":"*","collection":"*","where":{"ands":{"cid":"' CID_query '"}}}'];
litCountQ = webread(litCountQ_url, options);

% display all available collections
litCountQ_coll = extractfield(litCountQ.SDQOutputSet,'collection')';
cell2table(litCountQ_coll)
% Display total literature counts of selected collections:
% pubmed, patent, springer nature, and thiemechemistry

litCountQ_pubmed = litCountQ.SDQOutputSet(6).totalCount;
litCountQ_patent = litCountQ.SDQOutputSet(4).totalCount;
litCountQ_springernature = litCountQ.SDQOutputSet(13).totalCount;
litCountQ_thieme = litCountQ.SDQOutputSet(12).totalCount;

fprintf(['litCountQ_pubmed = %d \nlitCountQ_patent = %d \nlitCountQ_springernature = %d' ...
    '\nlitCountQ_thieme = %d\n'] ,...
    litCountQ_pubmed, litCountQ_patent, litCountQ_springernature, litCountQ_thieme)

%% 
% _If interested in different collections:_
% 
% # _Determine the collection you are interested in (e.g., 'clinicaltrials') 
% from the litCountQ.SDQOutputSet structure_
% # _Then, record the row number the collection appears in (16 for 'clinicaltrials')_
% # _Next, use this number to index into the litCountQ.SDQOutputSet _
% # _For example, litCountQ.SDQOutputSet(16).totalCount_
%% Explore Structure of the Literature Data
%%
% Retrieve 1 associated literature reference from each selected collection to look at 
% JSON field data

% pubmed
litQpubmed1_url = [sdq '{"select":"*","collection":"pubmed","where":{"ands":{"cid":"' CID_query '"}},' ...
    '"start":1,"limit":1}'];
litQpubmed1 = webread(litQpubmed1_url, options);
disp(litQpubmed1.SDQOutputSet.rows)
% patent
litQpatent1_url = [sdq '{"select":"*","collection":"patent","where":{"ands":{"cid":"' CID_query '"}},' ...
    '"start":1,"limit":1}'];
litQpatent1 = webread(litQpatent1_url, options);
disp(litQpatent1.SDQOutputSet.rows)
% springernature
litQspringernature1_url = [sdq '{"select":"*","collection":"springernature","where":{"ands":{"cid":"' CID_query '"}},' ...
    '"start":1,"limit":1}'];
litQspringernature1 = webread(litQspringernature1_url, options);
disp(litQspringernature1.SDQOutputSet.rows)
% thiemechemistry
litQthieme1_url = [sdq '{"select":"*","collection":"thiemechemistry","where":{"ands":{"cid":"' CID_query '"}},' ...
    '"start":1,"limit":1}'];
litQthieme1 = webread(litQthieme1_url, options);
disp(litQthieme1.SDQOutputSet.rows)
%% 
% _Note that in each collection there are multiple unique searchable fields 
% that we can use to perform literature searching._
% 
% _Some examples are presented below for how to combine the fields with keywords. 
% The limit was set at 10 for demo purposes._
%% Search PubMed Collection
%%
% Search pubchem pubmed collection for 
% referencess containing meshheadings "simvastatin" and meshsubheadings "chemical synthesis"
% (associated with CID_query)

litQpubmedF = [sdq '{"select":"*","collection":"pubmed","where":{"ands":{"cid":"' CID_query '",' ...
    '"meshheadings":"simvastatin", "meshsubheadings":"chemical synthesis"}},"start":1,"limit":10}'];
options = weboptions('Timeout', 60, 'ContentType','json');
litQpubmedF = webread(litQpubmedF, options);

% Display results: pmid, articletitle, articlejourname, articleauth, pubmed link
for k = 1:length(litQpubmedF.SDQOutputSet.rows)
    pmid = litQpubmedF.SDQOutputSet.rows{k,1}.pmid
    articletitle = litQpubmedF.SDQOutputSet.rows{k,1}.articletitle
    articleauth = litQpubmedF.SDQOutputSet.rows{k,1}.articleauth
    articlejourname = litQpubmedF.SDQOutputSet.rows{k,1}.articlejourname
    citation = litQpubmedF.SDQOutputSet.rows{k,1}.citation
    
    pubmed_root = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';
    pmid = num2str(pmid);
    pubmed_link = [pubmed_root pmid];
    fprintf('<a href = " %s ">%s</a>\n', pubmed_link, pubmed_link)
    disp(' ')
end
%% Search Patent Collection
%%
% Search pubchem patent collection for patents with "simvastatin" and "preparation" in the title
% (associated with CID_query)
litQpatentF = [sdq '{"select":"*","collection":"patent","where":{"ands":{"cid":"' CID_query '",' ...
    '"patenttitle":"simvastatin", "patenttitle":"preparation"}},"start":1,"limit":10}'];
options = weboptions('Timeout', 60, 'ContentType','json');
litQpatentF = webread(litQpatentF, options);

% Display results: patentID, patenttitle, patentinventor, and patenturl
for k = 1:length(litQpatentF.SDQOutputSet.rows)
    patentID = litQpatentF.SDQOutputSet.rows{k,1}.patentid
    patenttitle = litQpatentF.SDQOutputSet.rows{k,1}.patenttitle
    patentdate = litQpatentF.SDQOutputSet.rows{k,1}.patentdate
    patentinventor = litQpatentF.SDQOutputSet.rows{k,1}.patentinventor
    patenturl = litQpatentF.SDQOutputSet.rows{k,1}.patenturl;
    fprintf('<a href = " %s ">%s</a>', patenturl, patenturl)
    disp(' ')
end
%% Search Springer Nature
%%
% Search springer nature collection for "simvastatin" in the title and publication year 2019
% (associated with CID_query)
litQspringernatureF = [sdq '{"select":"*","collection":"springernature","where":{"ands":{"cid":"' CID_query '",' ...
    '"articletitle":"simvastatin", "articlepubdate":"2019"}},"start":1,"limit":10}'];
options = weboptions('Timeout', 60, 'ContentType','json');
litQspringernatureF = webread(litQspringernatureF, options);

% Display results
for k = 1:length(litQspringernatureF.SDQOutputSet.rows)
    extID = litQspringernatureF.SDQOutputSet.rows{k,1}.extid
    articletitle = litQspringernatureF.SDQOutputSet.rows{k,1}.articletitle
    articlejournalname = litQspringernatureF.SDQOutputSet.rows{k,1}.articlejourname
    articlepubdate = litQspringernatureF.SDQOutputSet.rows{k,1}.articlepubdate
    articleurl = litQspringernatureF.SDQOutputSet.rows{k,1}.url;
    fprintf('<a href = " %s ">%s</a>', articleurl, articleurl)
    disp(' ')
end
%% Retrieve Thieme Chemistry References

% Retrieve all Thieme Chemistry References (only 2 from above lit count)
% (associated with CID_query)
litQthiemeF = [sdq '{"select":"*","collection":"thiemechemistry","where":{"ands":{"cid":"' CID_query '"}},' ...
    '"start":1,"limit":10}'];

options = weboptions('Timeout', 60, 'ContentType','json');
litQthiemeF = webread(litQthiemeF, options);

% Display results
for k = 1:length(litQthiemeF.SDQOutputSet.rows)
    extID = litQthiemeF.SDQOutputSet.rows{k,1}.extid
    articletitle = litQthiemeF.SDQOutputSet.rows{k,1}.articletitle
    articlejournalname = litQthiemeF.SDQOutputSet.rows{k,1}.articlejourname
    articlepubdate = litQthiemeF.SDQOutputSet.rows{k,1}.articlepubdate
    articleurl = litQthiemeF.SDQOutputSet.rows{k,1}.url;
    fprintf('<a href = " %s ">%s</a>', articleurl, articleurl)
    disp(' ')
end