A = LOAD '/user/cloudera/input/' AS (line:chararray);
B = FOREACH A GENERATE REPLACE(line,'([^a-zA-Z])',' ') AS (newline:chararray);
C = FOREACH B GENERATE FLATTEN(TOKENIZE(newline)) AS word;
D = GROUP C BY LOWER(word);
DA = FILTER D BY ($0 MATCHES '.*hackathon.*' OR $0 MATCHES '.*dec.*' OR $0 MATCHES '.*chicago.*' OR $0 MATCHES '.*java.*');
E = FOREACH DA GENERATE FLATTEN(TOP(1,0,C)), COUNT(C);

F = LOAD '/user/cloudera/input2/' USING PigStorage(' ') AS (final_word_group: chararray, final_col: long);
G = UNION F,E;
H = GROUP G BY $0;
I = FOREACH H GENERATE group, SUM(G.$1);
STORE I INTO '/user/cloudera/output2/'USING PigStorage();