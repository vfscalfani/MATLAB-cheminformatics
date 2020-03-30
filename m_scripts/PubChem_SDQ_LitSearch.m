%% PubChem_SDQ_LitSearch
% Search PubChem for PubMed, Patent, Springer Nature, Thieme, and Wiley Literature 
% associated with a CID

% Vincent F. Scalfani, Serena C. Ralph, Ali Al Alshaikh, and Jason E. Bara 
% The University of Alabama
% Tested with MATLAB R2020a, running Ubuntu 18.04 on March 30, 2020.
% N.B. PubChem SDQ is used internally by PubChem webpages and is still being rapidly developed.
%% Define the PubChem API and SDQ agent base URL

% PubChem API
api = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/';

% PubChem SDQ agent
sdq = 'https://pubchem.ncbi.nlm.nih.gov/sdq/sdqagent.cgi?outfmt=json&query=';

% set a longer web options timeout and json output
options = weboptions('Timeout', 60, 'ContentType','json');

% Retrieve and display PNG Image of 1-Butyl-3-methylimidazolium chloride;
% CID 2734161
CID_query = '2734161';
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
collections = cell(1,length(litCountQ.SDQOutputSet)); % preallocate
for k = 1:length(litCountQ.SDQOutputSet)
    collections{k} = litCountQ.SDQOutputSet{k, 1}.collection;
end
collections = collections'
% Display total literature counts of selected collections:
% pubmed, patent, springernature, thiemechemistry, and wiley

litCountQ_pubmed = litCountQ.SDQOutputSet{7,1}.totalCount;
litCountQ_patent = litCountQ.SDQOutputSet{4,1}.totalCount;
litCountQ_springernature = litCountQ.SDQOutputSet{15,1}.totalCount;
litCountQ_thieme = litCountQ.SDQOutputSet{13,1}.totalCount;
litCountQ_wiley = litCountQ.SDQOutputSet{14,1}.totalCount;

fprintf(['litCountQ_pubmed = %d \nlitCountQ_patent = %d \nlitCountQ_springernature = %d' ...
    '\nlitCountQ_thieme = %d \nlitCountQ_wiley = %d'] ,...
    litCountQ_pubmed, litCountQ_patent, litCountQ_springernature, litCountQ_thieme, litCountQ_wiley)
%% 
% _If interested in different collections:_
%% 
% # _Determine the collection you are interested in (e.g., 'clinicaltrials') 
% from the litCountQ.SDQOutputSet structure_
% # _Then, record the row number the collection appears in (18 for 'clinicaltrials')_
% # _Next, use this number to index into the litCountQ.SDQOutputSet_ 
% # _For example, litCountQ.SDQOutputSet{18,1}.totalCount_
%% Explore Categories of the Literature Data

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
% wiley
litQpwiley1_url = [sdq '{"select":"*","collection":"wiley","where":{"ands":{"cid":"' CID_query '"}},' ...
    '"start":1,"limit":1}'];
litQwiley1 = webread(litQpwiley1_url, options);
disp(litQwiley1.SDQOutputSet.rows)
%% 
% _In each collection there are multiple unique searchable fields that we can 
% use to perform literature searching. Some examples are presented below for how 
% to combine the fields with keywords. Please note that this is still an experimental 
% method. The limit was set at 10 for demo purposes._
%% Search PubMed Collection

% Search pubchem pubmed collection for 
% referencess containing meshheadings "Imidazoles" and meshsubheadings "chemical synthesis"
% (associated with CID_query)

litQpubmedF = [sdq '{"select":"*","collection":"pubmed","where":{"ands":{"cid":"' CID_query '",' ...
    '"meshheadings":"Imidazoles", "meshsubheadings":"chemical synthesis"}},"start":1,"limit":10}'];
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

% Search pubchem patent collection for patents with "imidazolium" in the abstract and "preparation" in the title
% (associated with CID_query)
litQpatentF = [sdq '{"select":"*","collection":"patent","where":{"ands":{"cid":"' CID_query '",' ...
    '"patentabstract":"imidazolium", "patenttitle":"preparation"}},"start":1,"limit":10}'];
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

% Search springer nature collection for "imidazolium" in the title and publication year 2019
% (associated with CID_query)
litQspringernatureF = [sdq '{"select":"*","collection":"springernature","where":{"ands":{"cid":"' CID_query '",' ...
    '"articletitle":"imidazolium", "articlepubdate":"2019"}},"start":1,"limit":10}'];
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
%% Retrieve Thieme and Wiley Chemistry References

% Retrieve all Thieme and Wiley Chemistry References associated with our
% CID query (since both are < 10 results)
% (associated with CID_query)

% Thieme
litQthiemeF = [sdq '{"select":"*","collection":"thiemechemistry","where":{"ands":{"cid":"' CID_query '"}},' ...
    '"start":1,"limit":10}'];

options = weboptions('Timeout', 60, 'ContentType','json');
litQthiemeF = webread(litQthiemeF, options);

% Display results
for k = 1:length(litQthiemeF.SDQOutputSet.rows)
    extID = litQthiemeF.SDQOutputSet.rows(k).extid
    articletitle = litQthiemeF.SDQOutputSet.rows(k).articletitle
    articlejournalname = litQthiemeF.SDQOutputSet.rows(k).articlejourname
    articlepubdate = litQthiemeF.SDQOutputSet.rows(k).articlepubdate
    articleurl = litQthiemeF.SDQOutputSet.rows(k).url;
    fprintf('<a href = " %s ">%s</a>', articleurl, articleurl)
    disp(' ')
end
% Wiley
litQwileyF = [sdq '{"select":"*","collection":"wiley","where":{"ands":{"cid":"' CID_query '"}},' ...
    '"start":1,"limit":10}'];

options = weboptions('Timeout', 60, 'ContentType','json');
litQwileyF = webread(litQwileyF, options);

% Display results
for k = 1:length(litQwileyF.SDQOutputSet.rows)
    extID = litQwileyF.SDQOutputSet.rows(k).extid
    articletitle = litQwileyF.SDQOutputSet.rows(k).articletitle
    articlejournalname = litQwileyF.SDQOutputSet.rows(k).articlejourname
    articlepubdate = litQwileyF.SDQOutputSet.rows(k).articlepubdate
    articleurl = litQwileyF.SDQOutputSet.rows(k).url;
    fprintf('<a href = " %s ">%s</a>', articleurl, articleurl)
    disp(' ')
end